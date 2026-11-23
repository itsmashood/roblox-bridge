#!/usr/bin/env node
/**
 * Roblox Bridge — authorised Elvebredd public snapshot importer.
 * The source repo and its extraction code were shared by xjacksssss.
 * This importer keeps the current values_elvebredd structure and all 12 variants.
 * Default source: xjacksssss/elve-values-public (published JSON, no key needed).
 * Optional INPUT_FILE: locally collected snapshot from scripts/scrape-elve.js.
 */
'use strict';

const fs = require('node:fs/promises');
const path = require('node:path');

const ROOT = __dirname;
const DB_FILE = process.env.OUT_FILE || path.join(ROOT, 'values_elvebredd');
const INPUT_FILE = process.env.INPUT_FILE || '';
const FEED_URL = 'https://raw.githubusercontent.com/xjacksssss/elve-values-public/main/data/elve-values.json';
const MAX_AGE_HOURS = Number(process.env.MAX_SNAPSHOT_AGE_HOURS || 72);
const MIN_SOURCE_ITEMS = Number(process.env.MIN_SOURCE_ITEMS || 3000);
const MIN_MATCHED_ITEMS = Number(process.env.MIN_MATCHED_ITEMS || 3000);
const MIN_MATCHED_PETS = Number(process.env.MIN_MATCHED_PETS || 750);
const DRY_RUN = process.env.DRY_RUN === 'true';
const DIAG_FILE = process.env.DIAGNOSTICS_FILE || path.join(ROOT, 'elve-update-diagnostics.json');

// IDs, not names or array order, are the authoritative matching key.
const FIELDS = Object.freeze({
  NP: 'rvalueNopotion', F: 'rvalueFly', R: 'rvalueRide', FR: 'rvalueFlyRide',
  N: 'nvalueNopotion', NF: 'nvalueFly', NR: 'nvalueRide', NFR: 'nvalueFlyRide',
  M: 'mvalueNopotion', MF: 'mvalueFly', MR: 'mvalueRide', MFR: 'mvalueFlyRide',
});
const PET_VARIANTS = Object.keys(FIELDS);
const EMPTY_NAME = /^(nan|none|null|undefined|n\/?a|-)$/i;

function normalizedName(str) {
  return String(str || '').normalize('NFKD').replace(/[\u0300-\u036f]/g, '')
    .replace(/[’‘']/g, '').replace(/&/g, 'and').replace(/[^a-z0-9]/gi, '')
    .toLowerCase();
}
function validName(n) {
  return typeof n === 'string' && n.trim().length > 1 && n.length < 180 && !EMPTY_NAME.test(n.trim());
}
function numberOrNull(n) {
  return typeof n === 'number' && Number.isFinite(n) && n >= 0 && n < 1e8
    ? Math.round((n + Number.EPSILON) * 1e8) / 1e8 : null;
}
function currentVariant(pet, key) {
  const raw = numberOrNull(pet[FIELDS[key]]);
  if (raw !== null) return raw;
  if (key === 'FR') return numberOrNull(pet.rvalue);
  if (key === 'NFR') return numberOrNull(pet.nvalue);
  if (key === 'MFR') return numberOrNull(pet.mvalue);
  return null;
}
function validateFeed(feed, clock = Date.now()) {
  if (!feed || typeof feed !== 'object' || !Array.isArray(feed.pets)) {
    throw new Error('Source is missing its pets array.');
  }
  if (feed.pets.length < MIN_SOURCE_ITEMS) {
    throw new Error(`Source incomplete: ${feed.pets.length} rows, need ${MIN_SOURCE_ITEMS}+.`);
  }
  const ts = Date.parse(feed.scrapedAt);
  if (!Number.isFinite(ts)) throw new Error('Source has no valid scrapedAt timestamp.');
  const hoursOld = (clock - ts) / 3600000;
  if (hoursOld > MAX_AGE_HOURS || hoursOld < -0.5) {
    throw new Error(`Source timestamp is stale/future (${hoursOld.toFixed(1)} hours).`);
  }
  const ids = new Set();
  let named = 0, invalidIds = 0;
  for (const pet of feed.pets) {
    if (pet && Number.isInteger(pet.id) && pet.id >= 0 && !ids.has(pet.id)) {
      ids.add(pet.id);
      if (validName(pet.name)) named++;
    } else invalidIds++;
  }
  if (invalidIds > 0 || ids.size < MIN_SOURCE_ITEMS || named < MIN_SOURCE_ITEMS * .98) {
    throw new Error(`Malformed source records (valid IDs ${ids.size}, valid names ${named}, duplicate/invalid IDs ${invalidIds}).`);
  }
  return {sourceCount: feed.pets.length, scrapedAt: feed.scrapedAt, hoursOld: +hoursOld.toFixed(2)};
}
function validateDb(db) {
  if (!db || typeof db.items !== 'object' || Array.isArray(db.items) || !db.items || Object.keys(db.items).length < 3000) {
    throw new Error('Existing database is missing or incomplete; refusing to update.');
  }
  for (const [key, it] of Object.entries(db.items)) {
    if (!it || !it.valueMeta || !Number.isInteger(it.valueMeta.elvebreddId)) {
      throw new Error(`Existing DB invalid or missing item ID: ${key}`);
    }
    for (const field of PET_VARIANTS) {
      if (typeof it[field] !== 'number' || !Number.isFinite(it[field])) throw new Error(`Existing DB invalid field ${key}.${field}`);
    }
  }
}
function newPetFromSource(raw, key) {
  const fields = {};
  for (const variant of PET_VARIANTS) {
    const v = currentVariant(raw, variant);
    if (v === null) return null; // never invent variants for a newly inserted pet
    fields[variant] = v;
  }
  const valueMeta = {source: {}, confidence: {}, originalRaw: {}, notes: ['Imported as a new pet from the owner-published Elvebredd snapshot.'], elvebreddId: raw.id};
  for (const variant of PET_VARIANTS) {
    valueMeta.source[variant] = `elvebredd-public:${FIELDS[variant]}`;
    valueMeta.confidence[variant] = 'direct-snapshot';
    valueMeta.originalRaw[variant] = fields[variant];
  }
  return { displayName: raw.name.trim(), category: 'pets', source: 'elvebredd', ...fields,
    demand: {}, aliases: [], valueMeta, rarity: raw.rarity || null, status: 'Ready', image: raw.image || null };
}

function mergeSnapshot(db, feed, options = {}) {
  validateDb(db);
  const meta = validateFeed(feed, options.clock ?? Date.now());
  const next = structuredClone(db);
  const index = new Map();
  const nameIndex = new Map();
  for (const [key, item] of Object.entries(db.items)) {
    const id = item.valueMeta.elvebreddId;
    if (index.has(id)) throw new Error(`Duplicate existing Elvebredd ID ${id}`);
    index.set(id, key);
    nameIndex.set(normalizedName(item.displayName), key);
  }
  const stats = { ...meta, matched: 0, matchedPets: 0, existingPets: 0, variantsCompared: 0,
    changedItems: 0, changedFields: 0, insertedPets: 0, unclassifiedNewItems: 0,
    missingNumericFields: 0, skippedNameMismatches: [], skippedOutliers: [], totalOutliers: 0, newNames: [], samples: [] };
  stats.existingPets = Object.values(db.items).filter(x => x.category === 'pets').length;
  const modified = new Set();
  for (const raw of feed.pets) {
    if (!validName(raw.name)) continue;
    const key = index.get(raw.id);
    if (!key) {
      const isPet = numberOrNull(raw.nvalue) !== null && numberOrNull(raw.mvalue) !== null;
      const newKey = String(raw.name).trim().toLowerCase().replace(/[^a-z0-9]+/g, ' ').trim();
      if (!isPet || !newKey || Object.hasOwn(next.items, newKey) || nameIndex.has(normalizedName(raw.name))) {
        stats.unclassifiedNewItems++;
        if (stats.newNames.length < 15) stats.newNames.push(raw.name);
        continue;
      }
      const inserted = newPetFromSource(raw, newKey);
      if (inserted) {
        next.items[newKey] = inserted;
        stats.insertedPets++;
        modified.add(newKey);
        index.set(raw.id, newKey);
        nameIndex.set(normalizedName(raw.name), newKey);
      } else stats.unclassifiedNewItems++;
      continue;
    }
    const old = db.items[key];
    const dest = next.items[key];
    // Skip a row if the same ID suddenly maps to a very different name.
    if (normalizedName(old.displayName) !== normalizedName(raw.name)) {
      stats.skippedNameMismatches.push({id: raw.id, existing: old.displayName, fromSource: raw.name});
      continue;
    }
    stats.matched++;
    if (old.category === 'pets') stats.matchedPets++;
    const variants = old.category === 'pets' ? PET_VARIANTS : ['NP','FR'];
    const candidate = {};
    if (old.category === 'pets') {
      for (const variant of variants) candidate[variant] = currentVariant(raw, variant);
    } else {
      const value = numberOrNull(raw.rvalue) ?? numberOrNull(raw.value);
      candidate.NP = value;
      candidate.FR = value;
    }
    for (const variant of variants) {
      const value = candidate[variant];
      if (value === null) {stats.missingNumericFields++; continue;}
      stats.variantsCompared++;
      const prev = old[variant];
      if (prev > 0 && value > 0 && (value / prev > 20 || prev / value > 20)) {
        stats.totalOutliers++;
        if (stats.skippedOutliers.length < 30) stats.skippedOutliers.push({name: old.displayName, variant, before: prev, after: value});
        continue;
      }
      if (Math.abs(prev - value) < 1e-8) continue;
      dest[variant] = value;
      dest.valueMeta ||= {};
      dest.valueMeta.source ||= {};
      dest.valueMeta.confidence ||= {};
      dest.valueMeta.originalRaw ||= {};
      dest.valueMeta.source[variant] = `elvebredd-public:${old.category === 'pets' ? FIELDS[variant] : 'rvalue'}`;
      dest.valueMeta.confidence[variant] = 'direct-snapshot';
      dest.valueMeta.originalRaw[variant] = value;
      stats.changedFields++;
      modified.add(key);
      if (stats.samples.length < 12) stats.samples.push({name: old.displayName, variant, before: prev, after: value});
    }
  }
  if (stats.matched < MIN_MATCHED_ITEMS || stats.matchedPets < MIN_MATCHED_PETS || stats.matchedPets / stats.existingPets < .90) {
    throw new Error(`Unsafe coverage: ${stats.matched} existing records, ${stats.matchedPets}/${stats.existingPets} pets. No DB changes saved.`);
  }
  if (stats.skippedNameMismatches.length > 10 || stats.totalOutliers > 100) {
    throw new Error(`Too many anomalous records: ${stats.skippedNameMismatches.length} ID/name mismatches, ${stats.totalOutliers} outliers.`);
  }
  stats.changedItems = modified.size;
  if (stats.changedItems) {
    next.updatedAt = new Date(options.clock ?? Date.now()).toISOString();
    next.source = 'elvebredd-owner-published-snapshot';
    next.sourceUrl = feed.source || 'https://elvebredd.com/calculator';
    next.itemCount = Object.keys(next.items).length;
    const categoryItemCounts = {};
    for (const item of Object.values(next.items)) categoryItemCounts[item.category] = (categoryItemCounts[item.category] || 0) + 1;
    next.categoryItemCounts = Object.fromEntries(Object.entries(categoryItemCounts).sort(([a],[b]) => a.localeCompare(b)));
    next.lastElveSource = {repo: 'xjacksssss/elve-values-public', snapshotAt: feed.scrapedAt,
      importedAt: next.updatedAt, matchedItems: stats.matched, insertedPets: stats.insertedPets,
      changedFields: stats.changedFields};
  }
  return {db:next, stats};
}

async function fetchSnapshot() {
  if (INPUT_FILE) return JSON.parse(await fs.readFile(INPUT_FILE, 'utf8'));
  let lastErr;
  for (let attempt = 1; attempt <= 3; attempt++) {
    try {
      const response = await fetch(FEED_URL, {
        signal: AbortSignal.timeout(45000),
        headers: { 'Accept': 'application/json', 'User-Agent': 'roblox-bridge-value-updater/2.0' }
      });
      if (!response.ok) throw new Error(`GitHub snapshot HTTP ${response.status}`);
      return await response.json();
    } catch (err) {
      lastErr = err;
      if (attempt < 3) await new Promise(r => setTimeout(r, 2500 * attempt));
    }
  }
  throw lastErr;
}
async function atomicWrite(file, content) {
  const tmp = `${file}.tmp-${process.pid}`;
  try {
    await fs.writeFile(tmp, content, 'utf8');
    JSON.parse(await fs.readFile(tmp, 'utf8'));
    await fs.rename(tmp, file);
  } finally { await fs.rm(tmp, {force:true}).catch(() => {}); }
}
async function main() {
  const diag = {startedAt:new Date().toISOString(), feedUrl:INPUT_FILE || FEED_URL, status:'started'};
  try {
    const db = JSON.parse(await fs.readFile(DB_FILE, 'utf8'));
    const feed = await fetchSnapshot();
    const {db:next, stats} = mergeSnapshot(db, feed);
    diag.stats = stats;
    diag.status = stats.changedItems ? (DRY_RUN?'validated-dry-run':'updated') : 'unchanged';
    console.log(JSON.stringify(stats, null, 2));
    if (!DRY_RUN && stats.changedItems) {
      await atomicWrite(DB_FILE, JSON.stringify(next, null, 2) + '\n');
      console.log(`Updated ${stats.changedFields} values in ${stats.changedItems} items; inserted ${stats.insertedPets} new pets.`);
    } else console.log('No database write needed.');
    if (process.env.GITHUB_STEP_SUMMARY) {
      await fs.appendFile(process.env.GITHUB_STEP_SUMMARY,
        `### Elvebredd update\n\nSource snapshot: ${stats.scrapedAt}\n\nMatched: ${stats.matched}, pets: ${stats.matchedPets}/${stats.existingPets}, updated fields: ${stats.changedFields}, new pets: ${stats.insertedPets}.\n`);
    }
  } catch (err) {
    diag.status = 'failed'; diag.error = String(err.stack || err);
    console.error(diag.error); process.exitCode = 1;
  } finally {
    diag.finishedAt = new Date().toISOString();
    await fs.writeFile(DIAG_FILE, JSON.stringify(diag,null,2)+'\n').catch(()=>{});
  }
}
if (require.main === module) main();
module.exports = {normalizedName, numberOrNull, currentVariant, validateFeed, validateDb, newPetFromSource, mergeSnapshot, PET_VARIANTS};

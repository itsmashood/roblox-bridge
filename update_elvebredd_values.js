#!/usr/bin/env node
// Snapshot and extraction code shared by xjacksssss (elve-values-public).
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
const FIELDS = Object.freeze({
    NP: 'rvalueNopotion', F: 'rvalueFly', R: 'rvalueRide', FR: 'rvalueFlyRide',
    N: 'nvalueNopotion', NF: 'nvalueFly', NR: 'nvalueRide', NFR: 'nvalueFlyRide',
    M: 'mvalueNopotion', MF: 'mvalueFly', MR: 'mvalueRide', MFR: 'mvalueFlyRide',
});
const PET_VARIANTS = Object.keys(FIELDS);
const EMPTY_NAME = /^(nan|none|null|undefined|n\/?a|-)$/i;

function normalizedName(name) {
    return String(name || '').normalize('NFKD').replace(/[\u0300-\u036f]/g, '')
        .replace(/[’‘']/g, '').replace(/&/g, 'and').replace(/[^a-z0-9]/gi, '')
        .toLowerCase();
}

function validName(name) {
    return typeof name === 'string' && name.trim().length > 1 && name.length < 180 && !EMPTY_NAME.test(name.trim());
}

function numberOrNull(value) {
    return typeof value === 'number' && Number.isFinite(value) && value >= 0 && value < 1e8
        ? Math.round((value + Number.EPSILON) * 1e8) / 1e8 : null;
}

function currentVariant(pet, key) {
    const value = numberOrNull(pet[FIELDS[key]]);
    if (value !== null) return value;
    if (key === 'FR')
        return numberOrNull(pet.rvalue);
    if (key === 'NFR')
        return numberOrNull(pet.nvalue);
    if (key === 'MFR')
        return numberOrNull(pet.mvalue);
    return null;
}

function validateFeed(feed, clock = Date.now()) {
    if (!feed || typeof feed !== 'object' || !Array.isArray(feed.pets)) {
        throw new Error('Source is missing its pets array.');
    }
    if (feed.pets.length < MIN_SOURCE_ITEMS) {
        throw new Error(`Source incomplete: ${feed.pets.length} rows, need ${MIN_SOURCE_ITEMS}+.`);
    }
    const timestamp = Date.parse(feed.scrapedAt);
    if (!Number.isFinite(timestamp))
        throw new Error('Source has no valid scrapedAt timestamp.');
    const hoursOld = (clock - timestamp) / 3600000;
    if (hoursOld > MAX_AGE_HOURS || hoursOld < -0.5) {
        throw new Error(`Source timestamp is stale/future (${hoursOld.toFixed(1)} hours).`);
    }
    const ids = new Set();
    let named = 0, invalidIds = 0;
    for (const pet of feed.pets) {
        if (pet && Number.isInteger(pet.id) && pet.id >= 0 && !ids.has(pet.id)) {
            ids.add(pet.id);
            if (validName(pet.name))
                named++;
        } else
            invalidIds++;
    }
    if (invalidIds > 0 || ids.size < MIN_SOURCE_ITEMS || named < MIN_SOURCE_ITEMS * .98) {
        throw new Error(`Malformed source records (valid IDs ${ids.size}, valid names ${named}, duplicate/invalid IDs ${invalidIds}).`);
    }
    return { sourceCount: feed.pets.length, scrapedAt: feed.scrapedAt, hoursOld: +hoursOld.toFixed(2) };
}

function validateDb(db) {
    if (!db || typeof db.items !== 'object' || Array.isArray(db.items) || !db.items || Object.keys(db.items).length < 3000) {
        throw new Error('Existing database is missing or incomplete; refusing to update.');
    }
    for (const [key, item] of Object.entries(db.items)) {
        if (!item || !item.valueMeta || !Number.isInteger(item.valueMeta.elvebreddId)) {
            throw new Error(`Existing DB invalid or missing item ID: ${key}`);
        }
        for (const field of PET_VARIANTS) {
            if (typeof item[field] !== 'number' || !Number.isFinite(item[field]))
                throw new Error(`Existing DB invalid field ${key}.${field}`);
        }
    }
}

function newPetFromSource(sourceItem, key) {
    const fields = {};
    for (const variant of PET_VARIANTS) {
        const value = currentVariant(sourceItem, variant);
        if (value === null)
            return null;
        fields[variant] = value;
    }
    const valueMeta = { source: {}, confidence: {}, originalRaw: {}, notes: ['Imported as a new pet from the owner-published Elvebredd snapshot.'], elvebreddId: sourceItem.id };
    for (const variant of PET_VARIANTS) {
        valueMeta.source[variant] = `elvebredd-public:${FIELDS[variant]}`;
        valueMeta.confidence[variant] = 'direct-snapshot';
        valueMeta.originalRaw[variant] = fields[variant];
    }
    return { displayName: sourceItem.name.trim(), category: 'pets', source: 'elvebredd', ...fields,
        demand: {}, aliases: [], valueMeta, rarity: sourceItem.rarity || null, status: 'Ready', image: sourceItem.image || null };
}

function mergeSnapshot(db, feed, options = {}) {
    validateDb(db);
    const feedInfo = validateFeed(feed, options.clock ?? Date.now());
    const next = structuredClone(db);
    const idIndex = new Map();
    const nameIndex = new Map();
    for (const [key, item] of Object.entries(db.items)) {
        const id = item.valueMeta.elvebreddId;
        if (idIndex.has(id))
            throw new Error(`Duplicate existing Elvebredd ID ${id}`);
        idIndex.set(id, key);
        nameIndex.set(normalizedName(item.displayName), key);
    }
    const stats = { ...feedInfo, matched: 0, matchedPets: 0, existingPets: 0, variantsCompared: 0,
        changedItems: 0, changedFields: 0, insertedPets: 0, unclassifiedNewItems: 0,
        missingNumericFields: 0, skippedNameMismatches: [], skippedOutliers: [], totalOutliers: 0, newNames: [], samples: [] };
    stats.existingPets = Object.values(db.items).filter(item => item.category === 'pets').length;
    const changedKeys = new Set();
    for (const sourceItem of feed.pets) {
        if (!validName(sourceItem.name))
            continue;
        const key = idIndex.get(sourceItem.id);
        if (!key) {
            const isPet = numberOrNull(sourceItem.nvalue) !== null && numberOrNull(sourceItem.mvalue) !== null;
            const newKey = String(sourceItem.name).trim().toLowerCase().replace(/[^a-z0-9]+/g, ' ').trim();
            if (!isPet || !newKey || Object.hasOwn(next.items, newKey) || nameIndex.has(normalizedName(sourceItem.name))) {
                stats.unclassifiedNewItems++;
                if (stats.newNames.length < 15)
                    stats.newNames.push(sourceItem.name);
                continue;
            }
            const inserted = newPetFromSource(sourceItem, newKey);
            if (inserted) {
                next.items[newKey] = inserted;
                stats.insertedPets++;
                changedKeys.add(newKey);
                idIndex.set(sourceItem.id, newKey);
                nameIndex.set(normalizedName(sourceItem.name), newKey);
            } else
                stats.unclassifiedNewItems++;
            continue;
        }
        const oldItem = db.items[key];
        const updatedItem = next.items[key];
        if (normalizedName(oldItem.displayName) !== normalizedName(sourceItem.name)) {
            stats.skippedNameMismatches.push({ id: sourceItem.id, existing: oldItem.displayName, fromSource: sourceItem.name });
            continue;
        }
        stats.matched++;
        if (oldItem.category === 'pets')
            stats.matchedPets++;
        const variants = oldItem.category === 'pets' ? PET_VARIANTS : ['NP', 'FR'];
        const prices = {};
        if (oldItem.category === 'pets') {
            for (const variant of variants)
                prices[variant] = currentVariant(sourceItem, variant);
        } else {
            const value = numberOrNull(sourceItem.rvalue) ?? numberOrNull(sourceItem.value);
            prices.NP = value;
            prices.FR = value;
        }
        for (const variant of variants) {
            const value = prices[variant];
            if (value === null) {
                stats.missingNumericFields++;
                continue;
            }
            stats.variantsCompared++;
            const oldValue = oldItem[variant];
            if (oldValue > 0 && value > 0 && (value / oldValue > 20 || oldValue / value > 20)) {
                stats.totalOutliers++;
                if (stats.skippedOutliers.length < 30)
                    stats.skippedOutliers.push({ name: oldItem.displayName, variant, before: oldValue, after: value });
                continue;
            }
            if (Math.abs(oldValue - value) < 1e-8)
                continue;
            updatedItem[variant] = value;
            updatedItem.valueMeta ||= {};
            updatedItem.valueMeta.source ||= {};
            updatedItem.valueMeta.confidence ||= {};
            updatedItem.valueMeta.originalRaw ||= {};
            updatedItem.valueMeta.source[variant] = `elvebredd-public:${oldItem.category === 'pets' ? FIELDS[variant] : 'rvalue'}`;
            updatedItem.valueMeta.confidence[variant] = 'direct-snapshot';
            updatedItem.valueMeta.originalRaw[variant] = value;
            stats.changedFields++;
            changedKeys.add(key);
            if (stats.samples.length < 12)
                stats.samples.push({ name: oldItem.displayName, variant, before: oldValue, after: value });
        }
    }
    if (stats.matched < MIN_MATCHED_ITEMS || stats.matchedPets < MIN_MATCHED_PETS || stats.matchedPets / stats.existingPets < .90) {
        throw new Error(`Unsafe coverage: ${stats.matched} existing records, ${stats.matchedPets}/${stats.existingPets} pets. No DB changes saved.`);
    }
    if (stats.skippedNameMismatches.length > 10 || stats.totalOutliers > 100) {
        throw new Error(`Too many anomalous records: ${stats.skippedNameMismatches.length} ID/name mismatches, ${stats.totalOutliers} outliers.`);
    }
    stats.changedItems = changedKeys.size;
    if (stats.changedItems) {
        next.updatedAt = new Date(options.clock ?? Date.now()).toISOString();
        next.source = 'elvebredd-owner-published-snapshot';
        next.sourceUrl = feed.source || 'https://elvebredd.com/calculator';
        next.itemCount = Object.keys(next.items).length;
        const categoryItemCounts = {};
        for (const item of Object.values(next.items))
            categoryItemCounts[item.category] = (categoryItemCounts[item.category] || 0) + 1;
        next.categoryItemCounts = Object.fromEntries(Object.entries(categoryItemCounts).sort(([a], [b]) => a.localeCompare(b)));
        next.lastElveSource = { repo: 'xjacksssss/elve-values-public', snapshotAt: feed.scrapedAt,
            importedAt: next.updatedAt, matchedItems: stats.matched, insertedPets: stats.insertedPets,
            changedFields: stats.changedFields };
    }
    return { db: next, stats };
}

async function fetchSnapshot() {
    if (INPUT_FILE)
        return JSON.parse(await fs.readFile(INPUT_FILE, 'utf8'));
    let lastError;
    for (let attempt = 1; attempt <= 3; attempt++) {
        try {
            const response = await fetch(FEED_URL, {
                signal: AbortSignal.timeout(45000),
                headers: { 'Accept': 'application/json', 'User-Agent': 'roblox-bridge-value-updater/2.0' }
            });
            if (!response.ok)
                throw new Error(`GitHub snapshot HTTP ${response.status}`);
            return await response.json();
        } catch (error) {
            lastError = error;
            if (attempt < 3)
                await new Promise(resolve => setTimeout(resolve, 2500 * attempt));
        }
    }
    throw lastError;
}

async function atomicWrite(file, content) {
    const tempFile = `${file}.tmp-${process.pid}`;
    try {
        await fs.writeFile(tempFile, content, 'utf8');
        JSON.parse(await fs.readFile(tempFile, 'utf8'));
        await fs.rename(tempFile, file);
    } finally {
        await fs.rm(tempFile, { force: true }).catch(() => { });
    }
}

async function main() {
    const diagnostics = { startedAt: new Date().toISOString(), feedUrl: INPUT_FILE || FEED_URL, status: 'started' };
    try {
        const db = JSON.parse(await fs.readFile(DB_FILE, 'utf8'));
        const feed = await fetchSnapshot();
        const { db: next, stats } = mergeSnapshot(db, feed);
        diagnostics.stats = stats;
        diagnostics.status = stats.changedItems ? (DRY_RUN ? 'validated-dry-run' : 'updated') : 'unchanged';
        console.log(JSON.stringify(stats, null, 2));
        if (!DRY_RUN && stats.changedItems) {
            await atomicWrite(DB_FILE, JSON.stringify(next, null, 2) + '\n');
            console.log(`Updated ${stats.changedFields} values in ${stats.changedItems} items; inserted ${stats.insertedPets} new pets.`);
        } else
            console.log('No database write needed.');
        if (process.env.GITHUB_STEP_SUMMARY) {
            await fs.appendFile(process.env.GITHUB_STEP_SUMMARY, `### Elvebredd update\n\nSource snapshot: ${stats.scrapedAt}\n\nMatched: ${stats.matched}, pets: ${stats.matchedPets}/${stats.existingPets}, updated fields: ${stats.changedFields}, new pets: ${stats.insertedPets}.\n`);
        }
    } catch (error) {
        diagnostics.status = 'failed';
        diagnostics.error = String(error.stack || error);
        console.error(diagnostics.error);
        process.exitCode = 1;
    } finally {
        diagnostics.finishedAt = new Date().toISOString();
        await fs.writeFile(DIAG_FILE, JSON.stringify(diagnostics, null, 2) + '\n').catch(() => { });
    }
}

if (require.main === module)
    main();

module.exports = { normalizedName, numberOrNull, currentVariant, validateFeed, validateDb, newPetFromSource, mergeSnapshot, PET_VARIANTS };

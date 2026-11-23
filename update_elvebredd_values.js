/**
 * Xyneria / Roblox Bridge: AMVerse public-page value updater.
 *
 * No API key. Reads publicly displayed Elvebredd Regular / Neon / Mega values
 * through AMVerse's values page. Preserves the existing 12-variant DB schema.
 *
 * IMPORTANT: this is a public-page extractor, not an official AMVerse API.
 * Obtain permission for automated extraction and reuse before enabling.
 */
'use strict';

const fs = require('node:fs/promises');
const path = require('node:path');
const { performance } = require('node:perf_hooks');

const DB_PATH = process.env.OUT_FILE || path.join(__dirname, 'values_elvebredd');
const SOURCE_URL = 'https://amverse.co/values';
const DIAGNOSTICS_PATH = process.env.DIAGNOSTICS_FILE || path.join(__dirname, 'amverse_fetch_diagnostics.json');
const HEADLESS = process.env.HEADLESS !== 'false';
const DRY_RUN = process.env.DRY_RUN === 'true';
const MIN_MATCHED_ITEMS = Number(process.env.MIN_MATCHED_ITEMS || 350);
const MIN_PET_COVERAGE = Number(process.env.MIN_PET_COVERAGE || 0.45);
const MAX_SEARCH_QUERIES = Number(process.env.MAX_SEARCH_QUERIES || 3800);
const MAX_FETCH_MINUTES = Number(process.env.MAX_FETCH_MINUTES || 32);
const DEBUG = process.env.DEBUG === 'true';

function delay(ms) { return new Promise(resolve => setTimeout(resolve, ms)); }
function nameKey(v) {
  return String(v || '')
    .normalize('NFKD')
    .replace(/[\u0300-\u036f]/g, '')
    .replace(/[’‘']/g, '')
    .replace(/&/g, 'and')
    .replace(/[^a-z0-9]+/gi, ' ')
    .toLowerCase().trim().replace(/\s+/g, ' ');
}
function numericValue(input) {
  if (input === null || input === undefined || typeof input === 'boolean') return null;
  if (typeof input === 'number') return Number.isFinite(input) && input >= 0 ? input : null;
  const s = String(input).trim();
  if (!s || /^[\-—–−\s]+$/.test(s) || /^(null|none|n\/a|undefined)$/i.test(s)) return null;
  // A table cell may say `170−1` (value + an hourly delta). Keep only the leading value.
  const m = s.match(/^\s*([\d,]+(?:\.\d+)?|\.\d+)(?=$|\s|[+−–\-(])/);
  if (!m) return null;
  const n = Number(m[1].replace(/,/g, ''));
  return Number.isFinite(n) && n >= 0 ? n : null;
}
function petSlugFromHref(url) {
  const m = String(url || '').match(/\/pet\/([^/?#]+)/i);
  return m ? decodeURIComponent(m[1]).replace(/-/g, ' ') : null;
}
function parseTableRow(raw) {
  const cells = raw.cells || [];
  // In AMVerse's public table, the last 9 columns are E, A, € for each of
  // Regular, Neon and Mega. E is Elvebredd; A is AMVGG (different scale).
  if (!raw.name || cells.length < 9) return null;
  const tail = cells.slice(-9);
  const regular = numericValue(tail[0]);
  const neon = numericValue(tail[3]);
  const mega = numericValue(tail[6]);
  if ([regular, neon, mega].every(v => v === null)) return null;
  return {
    name: String(raw.name).trim(),
    slug: petSlugFromHref(raw.href),
    regular, neon, mega,
    origin: 'public-table'
  };
}
function field(o, names) {
  if (!o || typeof o !== 'object' || Array.isArray(o)) return null;
  for (const k of names) {
    if (Object.prototype.hasOwnProperty.call(o, k)) {
      const n = numericValue(o[k]);
      if (n !== null) return n;
    }
  }
  return null;
}
function extractEmbeddedRecord(o) {
  if (!o || typeof o !== 'object' || Array.isArray(o)) return null;
  const name = o.name || o.petName || o.pet_name || o.displayName || o.display_name || o.itemName;
  if (!name || typeof name !== 'string' || name.length > 160) return null;
  const candidates = [
    o.elvebredd, o.elvebreddValues, o.elvebredd_values,
    o.values?.elvebredd, o.values?.Elvebredd,
    o.value?.elvebredd, o.sources?.elvebredd,
    o.prices?.elvebredd, o.eValues
  ].filter(x => x && typeof x === 'object');
  const direct = {
    regular: field(o, ['elvebredd_regular', 'elvebreddRegular', 'elvebreddNormal', 'elvebredd_normal', 'e_regular', 'eRegular']),
    neon: field(o, ['elvebredd_neon', 'elvebreddNeon', 'e_neon', 'eNeon']),
    mega: field(o, ['elvebredd_mega', 'elvebreddMega', 'e_mega', 'eMega'])
  };
  if (String(o.source || '').toLowerCase() === 'elvebredd') candidates.push(o);
  for (const c of candidates) {
    for (const [k, keys] of Object.entries({
      regular: ['regular', 'normal', 'base', 'np', 'rvalue'],
      neon: ['neon', 'nvalue', 'n'],
      mega: ['mega', 'mega_neon', 'mvalue', 'm']
    })) {
      if (direct[k] === null) direct[k] = field(c, keys);
    }
  }
  if (Object.values(direct).every(x => x === null)) return null;
  return {name, slug: o.slug || petSlugFromHref(o.url), ...direct, origin: 'public-json'};
}
function extractJsonRecords(payload, limit = 200000) {
  const out = [];
  const queue = [payload];
  const seen = new WeakSet();
  let inspected = 0;
  for (let cursor = 0; cursor < queue.length && inspected < limit; cursor++) {
    const val = queue[cursor];
    if (!val || typeof val !== 'object' || seen.has(val)) continue;
    seen.add(val);
    inspected++;
    const pet = extractEmbeddedRecord(val);
    if (pet) out.push(pet);
    if (Array.isArray(val)) {
      for (const o of val) if (o && typeof o === 'object') queue.push(o);
    } else {
      for (const [k,o] of Object.entries(val)) {
        if (['history','snapshots','chart','priceHistory','transactions'].includes(k)) continue;
        if (o && typeof o === 'object') queue.push(o);
      }
    }
  }
  return out;
}
function isValidRecord(item) {
  return !!(item && nameKey(item.name) && ['regular','neon','mega'].some(v =>
    typeof item[v] === 'number' && Number.isFinite(item[v]) && item[v] >= 0));
}
function mergeCandidate(store, input) {
  if (!isValidRecord(input)) return;
  const k = nameKey(input.name);
  if (!k) return;
  const existing = store.get(k);
  if (!existing) { store.set(k, {...input}); return; }
  for (const variant of ['regular','neon','mega']) {
    // Prefer a numeric value from a public HTML row over indirect JSON guesses.
    if (typeof input[variant] === 'number' &&
        (existing[variant] === null || existing[variant] === undefined ||
         (input.origin === 'public-table' && existing.origin !== 'public-table'))) {
      existing[variant] = input[variant];
    }
  }
  if (input.origin === 'public-table') existing.origin = input.origin;
}
function getCurrentNameIndex(db) {
  const map = new Map();
  const ambiguous = new Set();
  for (const [key, item] of Object.entries(db.items)) {
    for (const candidate of [key, item.displayName, ...(item.aliases || [])]) {
      const nk = nameKey(candidate);
      if (!nk) continue;
      if (map.has(nk) && map.get(nk) !== key) ambiguous.add(nk);
      else map.set(nk, key);
    }
  }
  for (const nk of ambiguous) map.delete(nk);
  return map;
}
function prepareUpdate(db, rawRows, opts = {}) {
  const minMatched = opts.minMatched ?? MIN_MATCHED_ITEMS;
  const minPetCoverage = opts.minPetCoverage ?? MIN_PET_COVERAGE;
  const byName = getCurrentNameIndex(db);
  const changedItems = new Set();
  let matched = 0, matchedPets = 0, updatedFields = 0, unmatched = 0, invalid = 0;
  let outliers = 0, unchangedFields = 0;
  const exampleChanges = [], unmatchedNames = [];
  const seenDbKeys = new Set();
  const petTotal = Object.values(db.items).filter(i => i.category === 'pets').length;
  const next = structuredClone(db);
  const sorted = [...rawRows].sort((a,b) => a.name.localeCompare(b.name));
  for (const r of sorted) {
    if (!isValidRecord(r)) {invalid++; continue;}
    const key = byName.get(nameKey(r.name)) || byName.get(nameKey(r.slug));
    if (!key) {unmatched++; if (unmatchedNames.length < 30) unmatchedNames.push(r.name); continue;}
    if (seenDbKeys.has(key)) continue;
    seenDbKeys.add(key);
    matched++;
    const oldItem = db.items[key];
    const item = next.items[key];
    if (item.category === 'pets') matchedPets++;
    const mapping = item.category === 'pets' ? {regular:'NP',neon:'N',mega:'M'} : {regular:'NP'};
    for (const [src, fieldName] of Object.entries(mapping)) {
      const n = r[src];
      if (typeof n !== 'number' || !Number.isFinite(n) || n < 0) continue;
      const old = Number(oldItem[fieldName]);
      // Ignore an individual extreme outlier rather than corrupting a trusted field.
      if (old > 0 && n > 0 && (n / old > 25 || old / n > 25)) {outliers++; continue;}
      if (old === n) {unchangedFields++; continue;}
      item[fieldName] = n;
      item.valueMeta ||= {};
      item.valueMeta.source ||= {};
      item.valueMeta.confidence ||= {};
      item.valueMeta.originalRaw ||= {};
      item.valueMeta.source[fieldName] = `amverse:elvebredd:${src}`;
      item.valueMeta.confidence[fieldName] = 'direct-public-list';
      item.valueMeta.originalRaw[fieldName] = n;
      // A non-pet can only have a single Regular value. Keep legacy FR in sync
      // only where it was already a duplicate of NP.
      if (src === 'regular' && item.category !== 'pets' && oldItem.FR === oldItem.NP) {
        item.FR = n;
        item.valueMeta.source.FR = `amverse:elvebredd:${src}`;
        item.valueMeta.confidence.FR = 'copied-from-np-nonpet';
        item.valueMeta.originalRaw.FR = n;
      }
      changedItems.add(key);
      updatedFields++;
      if (exampleChanges.length < 20) exampleChanges.push({name: item.displayName, field:fieldName, before:oldItem[fieldName], after:n});
    }
  }
  const petCoverage = petTotal ? matchedPets / petTotal : 0;
  const stats = {source: SOURCE_URL, candidates:rawRows.length, matched, matchedPets, petTotal,
    petCoverage:Math.round(petCoverage*10000)/10000, changedItems:changedItems.size, updatedFields,
    unchangedFields, outliers, unmatched, invalid, exampleChanges, unmatchedNames};
  if (matched < minMatched || petCoverage < minPetCoverage) {
    const error = new Error(`Safety check failed: only ${matched} matches (${matchedPets}/${petTotal} pets, ${(100*petCoverage).toFixed(1)}%). Requires >=${minMatched} matches and >=${(minPetCoverage*100).toFixed(1)}% of pets. Existing DB preserved.`);
    error.stats = stats;
    throw error;
  }
  if (matched > 0 && outliers > matched * 0.08) {
    const error = new Error(`Too many extreme-value outliers (${outliers}/${matched}). Existing DB preserved.`);
    error.stats = stats;
    throw error;
  }
  if (updatedFields) {
    next.updatedAt = new Date().toISOString();
    next.source = 'elvebredd-through-amverse-public-values';
    next.sourceUrl = SOURCE_URL;
    next.itemCount = Object.keys(next.items).length;
    next.amverseLastFetch = {at: next.updatedAt, matched, changedItems:changedItems.size,
      updatedFields, variantsUpdated: ['NP','N','M'], note:'Other variant values retained from previous Elvebredd snapshot.'};
  }
  return {db:next, stats};
}

async function readVisibleTable(page) {
  const rows = await page.evaluate(() => {
    return [...document.querySelectorAll('table tbody tr')].map(tr => {
      const cells = [...tr.querySelectorAll('td')].map(td => (td.innerText || td.textContent || '').trim());
      const anchor = tr.querySelector('a[href*="/pet/"]');
      return {name:(anchor?.innerText || anchor?.textContent || cells[0] || '').trim(), href: anchor?.getAttribute('href') || '', cells};
    });
  });
  return rows.map(parseTableRow).filter(Boolean);
}
async function consumeTable(page, records, log) {
  const rows = await readVisibleTable(page);
  for (const r of rows) mergeCandidate(records, r);
  log.tableScans++;
  return rows.length;
}
function looksRelevantUrl(url) {
  try {
    const u = new URL(url);
    return (u.hostname === 'amverse.co' || u.hostname === 'www.amverse.co') &&
       /\b(value|pet|item|catalog|list|data)\b/i.test(u.pathname);
  } catch { return false; }
}
async function extractPublicValues(db, log) {
  // Lazy import: test suite needs no browser installation.
  const { chromium } = require('playwright');
  const browser = await chromium.launch({headless:HEADLESS, args:['--no-sandbox']});
  const context = await browser.newContext({viewport:{width:1440,height:1000}, locale:'en-GB'});
  const page = await context.newPage();
  const found = new Map();
  const asyncTasks = [];
  let relevantSearchTraffic = 0;
  page.on('response', response => {
    if (!looksRelevantUrl(response.url())) return;
    const url = new URL(response.url());
    const contentType = String(response.headers()['content-type'] || '');
    if (log.networkSamples.length < 30) log.networkSamples.push({path:url.pathname,status:response.status(),contentType:contentType.slice(0,80)});
    if (/\/api\//.test(url.pathname)) relevantSearchTraffic++;
    if (!/json/i.test(contentType)) return;
    const task = (async () => {
      try {
        const body = await response.json();
        const rows = extractJsonRecords(body);
        if (rows.length) log.jsonCandidates += rows.length;
        for (const r of rows) mergeCandidate(found, r);
      } catch (e) { if (DEBUG) log.errors.push(`JSON: ${String(e).slice(0,150)}`); }
    })();
    asyncTasks.push(task);
  });
  page.on('requestfailed', req => {
    if (log.failedRequests.length < 12) {
      try {const url=new URL(req.url());log.failedRequests.push({path:url.pathname,error:req.failure()?.errorText||'request failed'});} catch {}
    }
  });
  try {
    const resp = await page.goto(SOURCE_URL, {waitUntil:'domcontentloaded',timeout:60000});
    log.pageStatus = resp?.status() || null;
    const lastUpdatedText = await page.locator('body').innerText().then(t => t.match(/Values last updated\s+([^\n]+)/i)?.[1]?.trim() || null).catch(() => null);
    log.siteUpdatedText = lastUpdatedText;
    if (lastUpdatedText) {
      const lastUpdated = new Date(lastUpdatedText);
      if (Number.isFinite(lastUpdated.getTime()) && (Date.now()-lastUpdated.getTime()) > 72*3600*1000)
        throw new Error('AMVerse values page reports data older than 72 hours; refusing a stale update.');
    }
    if (!resp || resp.status() >= 400) throw new Error(`AMVerse values page returned HTTP ${resp?.status()}`);
    await page.waitForTimeout(1300);
    await consumeTable(page, found, log);
    // Some versions render the entire catalogue into JSON in Next.js hydration.
    // Parse only public JSON scripts (never credentials, local storage or cookies).
    const publicScripts = await page.evaluate(() => [...document.querySelectorAll('script[type="application/json"],script#__NEXT_DATA__')]
      .map(s => s.textContent || '').filter(s => s.length < 20_000_000).slice(0,20));
    for (const script of publicScripts) {
      try {
        const records = extractJsonRecords(JSON.parse(script));
        log.jsonCandidates += records.length;
        for (const record of records) mergeCandidate(found, record);
      } catch {}
    }
    // Paginated or lazy-loaded rows: scroll a little and try accessible Next controls.
    for (let n=0; n<45; n++) {
      await page.evaluate(() => window.scrollTo(0, document.body.scrollHeight));
      await page.waitForTimeout(100);
      const before = found.size;
      await consumeTable(page, found, log);
      const next = page.getByRole('button',{name:/^(next|next page|more|load more)$/i}).first();
      if (await next.count() && await next.isEnabled().catch(()=>false)) {
        await next.click({timeout:2000}).catch(()=>{});
        await page.waitForTimeout(170);
        await consumeTable(page,found,log);
      } else if (found.size === before) break;
    }
    await Promise.allSettled(asyncTasks);
    log.beforeSearch = found.size;
    const nameIndex = getCurrentNameIndex(db);
    const petCount = Object.values(db.items).filter(x => x.category==='pets').length;
    const existingPetCoverage = [...found.values()].filter(x=>{
      const k=nameIndex.get(nameKey(x.name));return k&&db.items[k].category==='pets';
    }).length / Math.max(petCount,1);
    // Search only if bulk extraction didn't already cover most pet entries.
    if (found.size < 2600 || existingPetCoverage < 0.85) {
      const search = page.locator('input[placeholder*="Search" i]').first();
      if (await search.count()) {
        log.searchAvailable = true;
        // Prioritise all pets; after these, try other items so their one-form
        // Regular values are not left behind. Search is one UI action at a time.
        const names = Object.entries(db.items).sort((a,b) => {
          const p = Number(b[1].category==='pets')-Number(a[1].category==='pets');
          return p || (a[1].displayName||a[0]).localeCompare(b[1].displayName||b[0]);
        });
        const started = performance.now();
        const cap = Math.max(0,Math.min(names.length,MAX_SEARCH_QUERIES));
        for (let i=0;i<cap;i++) {
          if (performance.now()-started > MAX_FETCH_MINUTES*60*1000) {log.timeLimitReached = true;break;}
          const [key,item] = names[i];
          const label = nameKey(item.displayName || key);
          const previouslyFound = found.has(label);
          if (previouslyFound) continue;
          const trafficBefore = relevantSearchTraffic;
          try {
            await search.fill(item.displayName || key,{timeout:3500});
            // Client-side filtering generally settles within two animation frames;
            // a debounce/network-backed UI needs a little longer.
            await page.waitForTimeout(relevantSearchTraffic>log.initialApiRequests+12 ? 380 : 95);
            let rows = await readVisibleTable(page);
            if (!rows.some(r => nameKey(r.name)===label)) {
              await page.waitForTimeout(260);
              rows = await readVisibleTable(page);
            }
            for (const r of rows) {
              if (nameKey(r.name) === label) mergeCandidate(found,r);
            }
            log.searchQueries++;
          } catch (e) {if (log.errors.length<15)log.errors.push(`Search ${i}: ${String(e).slice(0,130)}`);}
          // Keep requests modest if the search UI is server-backed.
          if (relevantSearchTraffic>trafficBefore) await page.waitForTimeout(500);
          if (i%150===0 && i>0) console.log(`AMVerse search: ${i}/${cap}; collected ${found.size} candidates`);
        }
        await search.fill('').catch(()=>{});
      } else {
        log.searchAvailable = false;
      }
    }
    await Promise.allSettled(asyncTasks);
    log.count = found.size;
    log.exampleValues = [...found.values()].slice(0,14);
    return [...found.values()];
  } finally {
    await browser.close();
  }
}

async function main() {
  const log = {generatedAt: new Date().toISOString(), source:SOURCE_URL, networkSamples:[],
    failedRequests:[], errors:[], jsonCandidates:0, tableScans:0, beforeSearch:0,
    searchQueries:0, pageStatus:null, sourceMode:'public-page-no-api-key'};
  try {
    const db = JSON.parse(await fs.readFile(DB_PATH,'utf8'));
    if (!db?.items || Object.keys(db.items).length < 100) throw new Error('Missing or incomplete existing database. Refusing to update.');
    const rows = await extractPublicValues(db,log);
    const result = prepareUpdate(db,rows);
    log.statistics = result.stats;
    console.log('AMVerse extraction result:',JSON.stringify(result.stats,null,2));
    if (DRY_RUN) console.log('DRY_RUN=true: database not changed.');
    else if (result.stats.updatedFields) {
      const tmp = `${DB_PATH}.tmp-${process.pid}`;
      await fs.writeFile(tmp,JSON.stringify(result.db,null,2)+'\n','utf8');
      JSON.parse(await fs.readFile(tmp,'utf8'));
      await fs.rename(tmp,DB_PATH);
      console.log(`Updated ${result.stats.updatedFields} fields in ${result.stats.changedItems} items; original 12-variant format preserved.`);
    } else console.log('No observed changes; existing DB preserved.');
    if (process.env.GITHUB_STEP_SUMMARY) {
      await fs.appendFile(process.env.GITHUB_STEP_SUMMARY,`### AMVerse value update\n\nMatched ${result.stats.matched} existing items; updated ${result.stats.updatedFields} fields (${result.stats.changedItems} items). Other variants preserved.\n`);
    }
  } catch (e) {
    log.error = String(e?.stack || e);
    if (e?.stats) log.statistics = e.stats;
    console.error(log.error);
    process.exitCode = 1;
  } finally {
    await fs.writeFile(DIAGNOSTICS_PATH,JSON.stringify(log,null,2)+'\n').catch(()=>{});
  }
}
if (require.main === module) main();
module.exports = {nameKey,numericValue,parseTableRow,extractEmbeddedRecord,extractJsonRecords,mergeCandidate,prepareUpdate,isValidRecord};

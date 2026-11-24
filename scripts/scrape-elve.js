#!/usr/bin/env node
// Adapted from xjacksssss/elve-values-public/scripts/scrape-elve.js with permission.
'use strict';

const fs = require('node:fs');
const path = require('node:path');
const TARGET_URL = 'https://elvebredd.com/calculator';
const FLARESOLVERR_URL = process.env.FLARESOLVERR_URL || 'http://localhost:8191/v1';
const OUTPUT_FILE = process.env.OUTPUT_FILE || 'data/elve-values.json';
const MIN_PETS = Number(process.env.MIN_PETS || 3000);
const ATTEMPTS = 3;
const RETRY_DELAY_MS = 30000;

async function fetchViaFlareSolverr() {
    const response = await fetch(FLARESOLVERR_URL, {
        method: 'POST', headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ cmd: 'request.get', url: TARGET_URL, maxTimeout: 90000 }),
        signal: AbortSignal.timeout(120000),
    });
    const data = await response.json().catch(() => null);
    if (!data || data.status !== 'ok')
        throw new Error(`FlareSolverr failed: ${data?.message || `HTTP ${response.status}`}`);
    const html = data.solution?.response || data.solution?.text || data.solution?.body;
    if (!html)
        throw new Error('FlareSolverr response did not include HTML');
    return html;
}

async function withRetry(task) {
    let lastError;
    for (let attempt = 1; attempt <= ATTEMPTS; attempt++) {
        try {
            return await task();
        } catch (error) {
            lastError = error;
            console.warn(`Attempt ${attempt}/${ATTEMPTS} failed: ${error.message}`);
            if (attempt < ATTEMPTS)
                await new Promise(resolve => setTimeout(resolve, RETRY_DELAY_MS));
        }
    }
    throw lastError;
}
const JUNK_NAME = /^\s*(nan|none|null|undefined|n\/a|-)?\s*$/i;
const isJunkName = name => name == null || JUNK_NAME.test(String(name));
const isTruthyFlag = value => value === true || (typeof value === 'string' && value.replace(/"/g, '').trim().toLowerCase() === 'true');

function normalizePet(row) {
    return {
        id: row.id, name: row.name, image: row.image, rarity: row.rarity, category: row.categoryd,
        flyRide: isTruthyFlag(row['fly&ride?']),
        rvalue: row.rvalue ?? row.value ?? null, nvalue: row.nvalue ?? null, mvalue: row.mvalue ?? null,
        rvalueNopotion: row['rvalue - nopotion'] ?? null,
        rvalueRide: row['rvalue - ride'] ?? null,
        rvalueFly: row['rvalue - fly'] ?? null,
        rvalueFlyRide: row['rvalue - fly&ride'] ?? null,
        nvalueNopotion: row['nvalue - nopotion'] ?? null,
        nvalueRide: row['nvalue - ride'] ?? null,
        nvalueFly: row['nvalue - fly'] ?? null,
        nvalueFlyRide: row['nvalue - fly&ride'] ?? null,
        mvalueNopotion: row['mvalue - nopotion'] ?? null,
        mvalueRide: row['mvalue - ride'] ?? null,
        mvalueFly: row['mvalue - fly'] ?? null,
        mvalueFlyRide: row['mvalue - fly&ride'] ?? null,
    };
}
const isPetRow = row => row != null && typeof row === 'object' && typeof row.name === 'string' && (row.rvalue !== undefined || row.value !== undefined);
const isPetArray = rows => Array.isArray(rows) && rows.length > 0 && rows.slice(0, 5).some(isPetRow);

function findPetArrays(value, depth = 0, out = []) {
    if (value == null || typeof value !== 'object' || depth > 8)
        return out;
    if (isPetArray(value)) {
        out.push(value);
        return out;
    }
    for (const child of Array.isArray(value) ? value : Object.values(value))
        findPetArrays(child, depth + 1, out);
    return out;
}

function parsePets(html) {
    const segments = [];
    for (const match of html.matchAll(/self\.__next_f\.push\(\[(\d+),([\s\S]*?)\]\)/g)) {
        if (match[1] === '1') {
            try {
                segments.push(JSON.parse(match[2]));
            } catch { }
        } else if (match[1] === '0')
            segments.push(match[2]);
    }
    const lines = segments.join('').split('\n').filter(Boolean);
    const byId = new Map();
    for (const line of lines) {
        const colon = line.indexOf(':');
        if (colon === -1)
            continue;
        const payload = line.slice(colon + 1);
        if (!payload.startsWith('[') && !payload.startsWith('{'))
            continue;
        let parsed;
        try {
            parsed = JSON.parse(payload);
        } catch {
            continue;
        }
        for (const rows of findPetArrays(parsed))
            for (const row of rows) {
                if (isJunkName(row?.name))
                    continue;
                const pet = normalizePet(row);
                if (pet.id != null && !byId.has(pet.id))
                    byId.set(pet.id, pet);
            }
    }
    return [...byId.values()].sort((a, b) => a.id - b.id);
}

async function main() {
    console.log(`Fetching ${TARGET_URL} via ${FLARESOLVERR_URL}`);
    const html = await withRetry(fetchViaFlareSolverr);
    const pets = parsePets(html);
    console.log(`Parsed ${pets.length} items`);
    if (pets.length < MIN_PETS)
        throw new Error(`Only ${pets.length} items parsed; expected ${MIN_PETS}+`);
    const snapshot = { source: TARGET_URL, scrapedAt: new Date().toISOString(), count: pets.length, pets };
    fs.mkdirSync(path.dirname(OUTPUT_FILE), { recursive: true });
    const tempFile = `${OUTPUT_FILE}.tmp`;
    fs.writeFileSync(tempFile, JSON.stringify(snapshot, null, 2) + '\n');
    fs.renameSync(tempFile, OUTPUT_FILE);
    console.log(`Wrote ${OUTPUT_FILE}`);
}

if (require.main === module)
    main().catch(error => { console.error(error.message); process.exitCode = 1; });

module.exports = { parsePets, normalizePet, findPetArrays };

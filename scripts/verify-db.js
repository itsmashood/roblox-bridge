'use strict';

const fs = require('node:fs');
const path = require('node:path');
const db = JSON.parse(fs.readFileSync(path.join(__dirname, '..', 'values_elvebredd'), 'utf8'));
const { PET_VARIANTS } = require('../update_elvebredd_values');
if (!db.items || Object.keys(db.items).length < 3000)
    throw Error('DB has too few items');
const ids = new Set();
for (const [name, item] of Object.entries(db.items)) {
    for (const variant of PET_VARIANTS)
        if (typeof item[variant] !== 'number' || !Number.isFinite(item[variant]) || item[variant] < 0)
            throw Error(`Invalid ${name}.${variant}`);
    const id = item.valueMeta?.elvebreddId;
    if (!Number.isInteger(id) || ids.has(id))
        throw Error(`Missing/duplicate ID: ${name}`);
    ids.add(id);
}
console.log(`Validated ${Object.keys(db.items).length} items with all 12 numeric variants and unique IDs`);

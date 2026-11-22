const assert = require('node:assert/strict');
const fs = require('node:fs');
const { extractElvebreddItems, validateCandidate } = require('./update_elvebredd_values');
const existing = JSON.parse(fs.readFileSync('./values_elvebredd', 'utf8'));
const original = Object.values(existing.items).find(v => v.displayName === 'Shadow Dragon');
assert.equal(existing.itemCount, Object.keys(existing.items).length);
assert.equal(existing.itemCount, 3475);
// Current page shape: the former initialPets property is no longer in the HTML,
// and values are supplied as nested JSON in a separately requested response.
const response = JSON.stringify({ data: { pets: [
  { id: 1337, name: 'Shadow Dragon', type: 'pets', values: {
      default: { base: original.FR, nopotion: original.NP, fly: original.F, ride: original.R, fly_ride: original.FR },
      neon: { base: original.NFR, nopotion: original.N, fly: original.NF, ride: original.NR, fly_ride: original.NFR },
      mega: { base: original.MFR, nopotion: original.M, fly: original.MF, ride: original.MR, fly_ride: original.MFR }
  } },
  { id: 1234, name: 'Toy Horse', type: 'toys', value: 0.25 }
] }});
const parsed = extractElvebreddItems(response);
assert.equal(parsed.size, 2);
assert.equal(parsed.get('shadow dragon').FR, original.FR);
assert.equal(parsed.get('shadow dragon').NP, original.NP);
assert.equal(parsed.get('toy horse').NP, .25);
assert.throws(() => validateCandidate({items: Object.fromEntries(parsed)}, existing), /Only extracted/);
validateCandidate(existing, existing);
// Source with old initialPets continues to work.
const oldPage = `<html><script>self.__next_f.push([1,${JSON.stringify('test {"initialPets":[{"name":"Shadow Dragon","type":"pets","rvalue":677}]}')}]);</script></html>`;
assert.equal(extractElvebreddItems(oldPage).get('shadow dragon').FR, 677);
console.log('Passed: embedded page data, nested response values, non-pet mapping, and database protection.');

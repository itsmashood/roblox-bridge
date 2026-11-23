'use strict';
const test = require('node:test');
const assert = require('node:assert/strict');
const { numericValue, nameKey, parseTableRow, extractJsonRecords, mergeCandidate, prepareUpdate } = require('./update_elvebredd_values');

test('parses values without mistaking badges/deltas or AMVGG amounts for Elvebredd', () => {
  assert.equal(numericValue('1,209.5+3'),1209.5);
  assert.equal(numericValue('170−1'),170);
  assert.equal(numericValue('0.945+0.005'),0.945);
  assert.equal(numericValue('–'),null);
  assert.equal(numericValue('€35.91'),null);
});
test('parses AMVerse public table: E, A and euros columns for all three forms', () => {
  const row=parseTableRow({name:'Hedgehog',href:'/pet/hedgehog',cells:[
    'Hedgehog','ultra rare','ultra rare',
    '114.5+3','0.67+0.015','€35.91','306+1','1.65','–','1209.5+3','6.45','–'
  ]});
  assert.deepEqual([row.regular,row.neon,row.mega],[114.5,306,1209.5]);
  assert.equal(row.slug,'hedgehog');
});
test('extracts only explicit Elvebredd JSON fields and ignores AMVGG scale', () => {
  const data={data:{pets:[
    {name:'Bat Dragon',elvebredd:{regular:1014,neon:2483,mega:7397},amvgg:{regular:5.58}},
    {name:'Shadow Dragon',elvebreddRegular:854,elvebreddNeon:2028,elvebreddMega:5320},
    {name:'Fake',amvgg:{regular:800,neon:1000}}
  ]}};
  const rows=extractJsonRecords(data);
  assert.equal(rows.length,2);
  assert.equal(rows[0].regular,1014);
  assert.equal(rows[1].mega,5320);
});
test('public HTML rows override indirect JSON values', () => {
  const records = new Map();
  mergeCandidate(records,{name:'Bat Dragon',regular:100,neon:null,mega:null,origin:'public-json'});
  mergeCandidate(records,{name:'Bat Dragon',regular:1014,neon:2483,mega:7397,origin:'public-table'});
  assert.equal(records.get('bat dragon').regular,1014);
});
test('preserves untouched variants and existing IDs and fields', () => {
  const item={displayName:'Hedgehog',category:'pets',source:'elvebredd',
    NP:102.5,F:102.9,R:102.75,FR:104,N:304,NF:293,NR:293,NFR:292,M:1192.5,MF:1100,MR:1100,MFR:1090,
    valueMeta:{elvebreddId:0,source:{NP:'elvebredd'},notes:['existing']},aliases:[]};
  const db={version:5,updatedAt:'2026-11-18T00:42:14.242Z',items:{hedgehog:item}};
  const {db:next,stats}=prepareUpdate(db,[{name:'Hedgehog',regular:114.5,neon:306,mega:1209.5}],{minMatched:1,minPetCoverage:1});
  assert.equal(stats.updatedFields,3);
  assert.equal(next.items.hedgehog.NP,114.5);
  assert.equal(next.items.hedgehog.N,306);
  assert.equal(next.items.hedgehog.M,1209.5);
  assert.equal(next.items.hedgehog.FR,104);
  assert.equal(next.items.hedgehog.MFR,1090);
  assert.equal(next.items.hedgehog.valueMeta.elvebreddId,0);
  assert.equal(db.items.hedgehog.NP,102.5);
});
test('keeps equivalent non-pet NP and legacy FR synchronized',()=>{
  const db={items:{'safari egg':{displayName:'Safari Egg',category:'eggs',NP:250,FR:250,valueMeta:{}}}};
  const {db:next}=prepareUpdate(db,[{name:'Safari Egg',regular:260,neon:null,mega:null}],{minMatched:1,minPetCoverage:0});
  assert.equal(next.items['safari egg'].NP,260);
  assert.equal(next.items['safari egg'].FR,260);
});
test('refuses partial extraction, original database unchanged',()=>{
  const db={items:{'bat dragon':{displayName:'Bat Dragon',category:'pets',NP:1013}}};
  assert.throws(()=>prepareUpdate(db,[],{minMatched:1,minPetCoverage:1}),/Safety check failed/);
  assert.equal(db.items['bat dragon'].NP,1013);
});
test('matches punctuation variants safely',()=>{
  assert.equal(nameKey('2021 Uplift Butterfly'),nameKey('2021  Uplift Butterfly'));
  assert.equal(nameKey("Crow's Nest"),nameKey('Crows Nest'));
});

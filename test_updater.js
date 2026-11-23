'use strict';
const test = require('node:test');
const assert = require('node:assert/strict');
const fs = require('node:fs');
const path = require('node:path');
const {validateFeed,mergeSnapshot,currentVariant,normalizedName,PET_VARIANTS} = require('./update_elvebredd_values');
const {parsePets} = require('./scripts/scrape-elve');
const original = JSON.parse(fs.readFileSync(path.join(__dirname,'values_elvebredd'),'utf8'));
const map = {
  NP:'rvalueNopotion',F:'rvalueFly',R:'rvalueRide',FR:'rvalueFlyRide',
  N:'nvalueNopotion',NF:'nvalueFly',NR:'nvalueRide',NFR:'nvalueFlyRide',
  M:'mvalueNopotion',MF:'mvalueFly',MR:'mvalueRide',MFR:'mvalueFlyRide'
};
function snapshot() {
  const pets=[];
  for (const it of Object.values(original.items)) {
    if (!it.displayName || /^(nan|none)$/i.test(it.displayName)) continue;
    const raw={id:it.valueMeta.elvebreddId,name:it.displayName,
      image:it.valueMeta.image||null,rarity:it.valueMeta.rarity||null,
      rvalue:it.FR,nvalue:it.category==='pets'?it.NFR:null,
      mvalue:it.category==='pets'?it.MFR:null};
    if(it.category==='pets')for(const [k,v] of Object.entries(map))raw[v]=it[k];
    pets.push(raw);
  }
  return {source:'https://elvebredd.com/calculator',scrapedAt:new Date().toISOString(),count:pets.length,pets};
}
test('current owner format maps all 12 pet variants correctly',()=>{
  const h={rvalue:119,nvalue:294,mvalue:1095,rvalueNopotion:117.5,rvalueFly:117.9,rvalueRide:117.75,rvalueFlyRide:119,
    nvalueNopotion:306,nvalueFly:295,nvalueRide:295,nvalueFlyRide:294,mvalueNopotion:1212.5,mvalueFly:1105,mvalueRide:1105,mvalueFlyRide:1095};
  assert.equal(currentVariant(h,'NP'),117.5);assert.equal(currentVariant(h,'M'),1212.5);
  assert.equal(currentVariant(h,'FR'),119);assert.equal(currentVariant(h,'MFR'),1095);
});
test('name normalization does not lose item identity',()=>{
  assert.equal(normalizedName('2026 Birthday Butterfly'),normalizedName('2026 Birthday  Butterfly'));
  assert.equal(normalizedName('Crow’s Nest'),normalizedName('Crows Nest'));
});
test('accepts a full, fresh source snapshot',()=>{
  const feed=snapshot();assert.ok(feed.pets.length>3000);
  assert.equal(validateFeed(feed).sourceCount,feed.pets.length);
});
test('rejects stale source before DB write',()=>{
  const feed=snapshot();feed.scrapedAt='2026-01-01T00:00:00.000Z';
  assert.throws(()=>validateFeed(feed),/stale\/future/);
});
test('rejects partial catalogues before any DB write',()=>{
  const feed=snapshot();feed.pets=feed.pets.slice(0,50);
  assert.throws(()=>mergeSnapshot(original,feed),/Source incomplete/);
});
test('rejects duplicate IDs in new data',()=>{
  const feed=snapshot();feed.pets[3].id=feed.pets[2].id;
  assert.throws(()=>mergeSnapshot(original,feed),/Malformed source/);
});
test('full database roundtrip preserves 12 variants for all existing records',()=>{
  const feed=snapshot();
  const {db:result,stats}=mergeSnapshot(original,feed);
  assert.equal(stats.matched,3473);
  assert.equal(stats.matchedPets,807);
  assert.equal(stats.insertedPets,0);
  assert.equal(Object.keys(result.items).length,3475);
  assert.equal(result.items.hedgehog.MFR,original.items.hedgehog.MFR);
  for(const it of Object.values(result.items))for(const k of PET_VARIANTS)assert.equal(typeof it[k],'number');
});
test('live-style changed prices update by ID; nonpets retain all variants',()=>{
  const feed=snapshot();
  const hedge=feed.pets.find(p=>p.id===0);hedge.rvalueNopotion=117.5;hedge.mvalueNopotion=1212.5;
  const ribbon=feed.pets.find(p=>p.id===1140);ribbon.rvalue=1.25;
  const {db:result,stats}=mergeSnapshot(original,feed);
  assert.ok(stats.changedFields>=4);
  assert.equal(result.items.hedgehog.NP,117.5);
  assert.equal(result.items.hedgehog.M,1212.5);
  assert.equal(result.items['1 ribbon'].NP,1.25);
  assert.equal(result.items['1 ribbon'].FR,1.25);
  assert.equal(result.items.hedgehog.MFR,original.items.hedgehog.MFR);
  assert.equal(original.items.hedgehog.NP,102.5);
});
test('new well-formed pet is inserted, unclassified new accessory is not',()=>{
  const feed=snapshot();
  feed.pets.push({id:90001,name:'Example New Pet',rarity:'legendary',rvalue:10,nvalue:20,mvalue:30,
    rvalueNopotion:10,rvalueFly:11,rvalueRide:11,rvalueFlyRide:12,
    nvalueNopotion:20,nvalueFly:21,nvalueRide:21,nvalueFlyRide:22,
    mvalueNopotion:30,mvalueFly:31,mvalueRide:31,mvalueFlyRide:32});
  feed.pets.push({id:90002,name:'New Toy',rvalue:0.1});
  const {db:result,stats}=mergeSnapshot(original,feed);
  assert.equal(stats.insertedPets,1);
  assert.ok(stats.unclassifiedNewItems>=1);
  assert.equal(result.items['example new pet'].category,'pets');
  assert.equal(result.items['example new pet'].MFR,32);
  assert.equal(result.items['new toy'],undefined);
  assert.equal(result.itemCount,3476);
});
test('individual wild outlier ignored but normal updates accepted',()=>{
  const feed=snapshot();const hedge=feed.pets.find(p=>p.id===0);
  hedge.rvalueNopotion=999999;hedge.rvalueRide=130;
  const {db:result,stats}=mergeSnapshot(original,feed);
  assert.equal(result.items.hedgehog.NP,original.items.hedgehog.NP);
  assert.equal(result.items.hedgehog.R,130);
  assert.ok(stats.skippedOutliers.length>0);
});
test('owner Next.js flight-parser can find renamed pet collection',()=>{
  const rows=[{id:0,name:'Hedgehog',rvalue:119,nvalue:294,mvalue:1095,'rvalue - nopotion':117.5},
    {id:1,name:'African Wild Dog',rvalue:159,nvalue:600,mvalue:2050}];
  const flightLine='0:'+JSON.stringify({nested:{catalog:{pets:rows}}})+'\n';
  const escaped=JSON.stringify(flightLine);
  const html=`<script>self.__next_f.push([1,${escaped}])</script>`;
  const pets=parsePets(html);
  assert.equal(pets.length,2);
  assert.equal(pets[0].rvalueNopotion,117.5);
  assert.equal(pets[1].name,'African Wild Dog');
});

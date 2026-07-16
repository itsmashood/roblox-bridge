const fs = require("fs/promises");

const AMVGG_URLS = [
  "https://amvgg.com/calculator?_rsc=19zvn",
  "https://amvgg.com/calculator",
  "https://amvgg.com/values/pets"
];

const OUT_FILE = "values";

const VARIANTS = {
  NP: { raw: "npRegularValue", base: "FR", baseRaw: "regularValue" },
  F: { raw: "fValue", base: "FR", baseRaw: "regularValue" },
  R: { raw: "rValue", base: "FR", baseRaw: "regularValue" },
  FR: { raw: "regularValue", base: null, baseRaw: null },

  N: { raw: "npNeonValue", base: "NFR", baseRaw: "neonValue" },
  NF: { raw: "nfValue", base: "NFR", baseRaw: "neonValue" },
  NR: { raw: "nrValue", base: "NFR", baseRaw: "neonValue" },
  NFR: { raw: "neonValue", base: null, baseRaw: null },

  M: { raw: "npMegaValue", base: "MFR", baseRaw: "megaValue" },
  MF: { raw: "mfValue", base: "MFR", baseRaw: "megaValue" },
  MR: { raw: "mrValue", base: "MFR", baseRaw: "megaValue" },
  MFR: { raw: "megaValue", base: null, baseRaw: null }
};

const BASE_VARIANTS = new Set(["FR", "NFR", "MFR"]);

function normalizeKey(name) {
  return String(name || "")
    .toLowerCase()
    .replace(/<[^>]*>/g, " ")
    .replace(/&amp;/g, "&")
    .replace(/[^a-z0-9]+/g, " ")
    .replace(/\s+/g, " ")
    .trim();
}

function toNumber(value) {
  if (value === null || value === undefined) return 0;

  const cleaned = String(value).replace(/,/g, "").trim();
  if (!cleaned) return 0;

  const n = Number(cleaned);
  return Number.isFinite(n) && n > 0 ? n : 0;
}

function roundValue(value) {
  if (!Number.isFinite(value) || value <= 0) return 0;
  return Math.round(value * 1000000) / 1000000;
}

function median(values) {
  const clean = values
    .filter(v => Number.isFinite(v) && v > 0)
    .sort((a, b) => a - b);

  if (clean.length === 0) return 0;

  const mid = Math.floor(clean.length / 2);

  if (clean.length % 2 === 1) {
    return clean[mid];
  }

  return (clean[mid - 1] + clean[mid]) / 2;
}

function getStringField(obj, keys) {
  for (const key of keys) {
    if (typeof obj[key] === "string" && obj[key].trim()) {
      return obj[key].trim();
    }
  }

  return "";
}

function cleanDisplayName(name) {
  return String(name || "")
    .replace(/<[^>]*>/g, " ")
    .replace(/&amp;/g, "&")
    .replace(/\s+/g, " ")
    .trim();
}

function findMatchingBrace(text, openIndex) {
  let depth = 0;
  let inString = false;
  let escaped = false;

  for (let i = openIndex; i < text.length; i++) {
    const ch = text[i];

    if (inString) {
      if (escaped) {
        escaped = false;
      } else if (ch === "\\") {
        escaped = true;
      } else if (ch === '"') {
        inString = false;
      }

      continue;
    }

    if (ch === '"') {
      inString = true;
      continue;
    }

    if (ch === "{") {
      depth++;
    } else if (ch === "}") {
      depth--;

      if (depth === 0) {
        return i;
      }
    }
  }

  return -1;
}

function parseObjectCandidatesAround(text, markerIndex) {
  const objects = [];
  let searchFrom = markerIndex;

  for (let tries = 0; tries < 30; tries++) {
    const openIndex = text.lastIndexOf("{", searchFrom);

    if (openIndex === -1) break;

    const closeIndex = findMatchingBrace(text, openIndex);

    if (closeIndex !== -1 && closeIndex > markerIndex) {
      const rawObject = text.slice(openIndex, closeIndex + 1);

      try {
        const parsed = JSON.parse(rawObject);
        objects.push(parsed);
      } catch (_) {
        // Ignore non-JSON React/RSC chunks.
      }
    }

    searchFrom = openIndex - 1;
  }

  return objects;
}

function objectHasValueFields(obj) {
  return obj && typeof obj === "object" && (
    "regularValue" in obj ||
    "npRegularValue" in obj ||
    "neonValue" in obj ||
    "npNeonValue" in obj ||
    "megaValue" in obj ||
    "npMegaValue" in obj ||
    "rValue" in obj ||
    "fValue" in obj ||
    "nrValue" in obj ||
    "nfValue" in obj ||
    "mrValue" in obj ||
    "mfValue" in obj
  );
}

function extractDisplayName(obj) {
  let name = getStringField(obj, [
    "displayName",
    "name",
    "title",
    "petName",
    "itemName",
    "label"
  ]);

  if (!name && typeof obj.slug === "string") {
    name = obj.slug.replace(/-/g, " ");
  }

  if (!name && typeof obj.href === "string") {
    const parts = obj.href.split("/").filter(Boolean);
    name = parts[parts.length - 1] || "";
    name = name.replace(/-/g, " ");
  }

  return cleanDisplayName(name);
}

function extractCategoryId(obj) {
  const keys = [
    "valueCategory",
    "valueCategoryId",
    "categoryId",
    "category",
    "category_id",
    "value_category",
    "value_category_id",
    "multiplierCategory",
    "multiplierCategoryId",
    "group",
    "groupId",
    "tier",
    "tierId",
    "valueType",
    "valueTypeId"
  ];

  for (const key of keys) {
    const value = obj[key];

    if (value === null || value === undefined) continue;

    if (typeof value === "string" || typeof value === "number") {
      const out = String(value).trim();

      if (out) {
        return out;
      }
    }

    if (typeof value === "object") {
      for (const innerKey of ["id", "_id", "value", "name", "slug", "key"]) {
        const innerValue = value[innerKey];

        if (innerValue !== null && innerValue !== undefined) {
          const out = String(innerValue).trim();

          if (out) {
            return out;
          }
        }
      }
    }
  }

  // Last fallback: group by demand pattern.
  // This is not as good as AMVGG's real category ID, but prevents everything
  // from collapsing into one bucket if the category field name changes.
  const demandKey = [
    obj.regularDemand,
    obj.neonDemand,
    obj.megaDemand,
    obj.npRegularDemand,
    obj.npNeonDemand,
    obj.npMegaDemand
  ]
    .map(v => v || "null")
    .join("|");

  return "demand:" + demandKey;
}

function makeAliases(displayName, key) {
  const aliases = new Set();

  const clean = normalizeKey(displayName);

  if (clean && clean !== key) {
    aliases.add(clean);
  }

  if (clean.includes(" dragon")) {
    aliases.add(clean.replace(" dragon", " drag"));
  }

  if (clean.includes(" unicorn")) {
    aliases.add(clean.replace(" unicorn", " uni"));
  }

  return Array.from(aliases);
}

function getRawVariantValues(obj) {
  return {
    NP: toNumber(obj.npRegularValue),
    F: toNumber(obj.fValue),
    R: toNumber(obj.rValue),
    FR: toNumber(obj.regularValue),

    N: toNumber(obj.npNeonValue),
    NF: toNumber(obj.nfValue),
    NR: toNumber(obj.nrValue),
    NFR: toNumber(obj.neonValue),

    M: toNumber(obj.npMegaValue),
    MF: toNumber(obj.mfValue),
    MR: toNumber(obj.mrValue),
    MFR: toNumber(obj.megaValue)
  };
}

function convertAmvggObject(obj) {
  const displayName = extractDisplayName(obj);
  const key = normalizeKey(displayName);

  if (!key || key.length < 2) return null;

  const categoryId = extractCategoryId(obj);
  const rawValues = getRawVariantValues(obj);

  return {
    key,
    raw: obj,
    categoryId,
    rawValues,
    value: {
      displayName,
      category: "pet",
      amvggCategory: categoryId,

      NP: rawValues.NP,
      F: rawValues.F,
      R: rawValues.R,
      FR: rawValues.FR,

      N: rawValues.N,
      NF: rawValues.NF,
      NR: rawValues.NR,
      NFR: rawValues.NFR,

      M: rawValues.M,
      MF: rawValues.MF,
      MR: rawValues.MR,
      MFR: rawValues.MFR,

      demand: {
        regular: obj.regularDemand || null,
        noPotionRegular: obj.npRegularDemand || null,
        fly: obj.fDemand || null,
        ride: obj.rDemand || null,
        neon: obj.neonDemand || null,
        noPotionNeon: obj.npNeonDemand || null,
        neonFly: obj.nfDemand || null,
        neonRide: obj.nrDemand || null,
        mega: obj.megaDemand || null,
        noPotionMega: obj.npMegaDemand || null,
        megaFly: obj.mfDemand || null,
        megaRide: obj.mrDemand || null
      },

      valueMeta: {
        calculated: {},
        multiplierSource: {},
        originalRaw: {}
      },

      aliases: makeAliases(displayName, key)
    }
  };
}

async function fetchText(url) {
  console.log(`Fetching ${url}`);

  const response = await fetch(url, {
    headers: {
      "User-Agent": "xyneria-values-bridge/1.0",
      "Accept": "text/html,application/json,text/plain,*/*"
    }
  });

  if (!response.ok) {
    throw new Error(`Fetch failed ${response.status} for ${url}`);
  }

  return await response.text();
}

function extractItemsFromText(text) {
  const items = new Map();
  const marker = '"regularValue"';

  let index = 0;

  while (true) {
    const markerIndex = text.indexOf(marker, index);

    if (markerIndex === -1) {
      break;
    }

    const candidates = parseObjectCandidatesAround(text, markerIndex);

    for (const obj of candidates) {
      if (!objectHasValueFields(obj)) continue;

      const converted = convertAmvggObject(obj);
      if (!converted) continue;

      if (!items.has(converted.key)) {
        items.set(converted.key, converted);
      }
    }

    index = markerIndex + marker.length;
  }

  return items;
}

function buildMultiplierSamples(rawItems) {
  const byCategory = {};
  const global = {};

  for (const variant of Object.keys(VARIANTS)) {
    if (BASE_VARIANTS.has(variant)) continue;
    global[variant] = [];
  }

  for (const item of rawItems) {
    const categoryId = item.categoryId || "unknown";

    if (!byCategory[categoryId]) {
      byCategory[categoryId] = {};
    }

    for (const variant of Object.keys(VARIANTS)) {
      if (BASE_VARIANTS.has(variant)) continue;

      if (!byCategory[categoryId][variant]) {
        byCategory[categoryId][variant] = [];
      }

      const exactValue = item.rawValues[variant];
      const baseVariant = VARIANTS[variant].base;
      const baseValue = item.rawValues[baseVariant];

      if (!exactValue || !baseValue || exactValue <= 0 || baseValue <= 0) {
        continue;
      }

      const ratio = exactValue / baseValue;

      // Filter obvious bad ratios.
      // Most potion/no-potion modifiers should be close-ish to 1.
      // This still allows high no-pot premium categories.
      if (!Number.isFinite(ratio) || ratio <= 0.05 || ratio >= 3.5) {
        continue;
      }

      byCategory[categoryId][variant].push(ratio);
      global[variant].push(ratio);
    }
  }

  return { byCategory, global };
}

function summarizeMultipliers(samples) {
  const categoryMultipliers = {};
  const globalMultipliers = {};

  for (const variant of Object.keys(samples.global)) {
    const sampleList = samples.global[variant] || [];

    globalMultipliers[variant] = {
      multiplier: roundValue(median(sampleList)),
      samples: sampleList.length
    };
  }

  for (const [categoryId, categorySamples] of Object.entries(samples.byCategory)) {
    categoryMultipliers[categoryId] = {};

    for (const variant of Object.keys(VARIANTS)) {
      if (BASE_VARIANTS.has(variant)) continue;

      const sampleList = categorySamples[variant] || [];
      const categoryMedian = median(sampleList);

      if (categoryMedian > 0) {
        categoryMultipliers[categoryId][variant] = {
          multiplier: roundValue(categoryMedian),
          samples: sampleList.length
        };
      }
    }
  }

  return { categoryMultipliers, globalMultipliers };
}

function getMultiplierForVariant(categoryId, variant, multipliers) {
  const categoryInfo = multipliers.categoryMultipliers[categoryId];

  if (
    categoryInfo &&
    categoryInfo[variant] &&
    categoryInfo[variant].multiplier > 0
  ) {
    return {
      multiplier: categoryInfo[variant].multiplier,
      source: "category:" + categoryId,
      samples: categoryInfo[variant].samples
    };
  }

  const globalInfo = multipliers.globalMultipliers[variant];

  if (globalInfo && globalInfo.multiplier > 0) {
    return {
      multiplier: globalInfo.multiplier,
      source: "global",
      samples: globalInfo.samples
    };
  }

  return {
    multiplier: 0,
    source: "none",
    samples: 0
  };
}

function fillMissingValues(item, multipliers) {
  const out = item.value;
  const categoryId = item.categoryId;

  for (const variant of Object.keys(VARIANTS)) {
    const rawValue = item.rawValues[variant] || 0;

    out.valueMeta.originalRaw[variant] = rawValue || null;

    if (rawValue > 0) {
      out[variant] = rawValue;
      out.valueMeta.calculated[variant] = false;
      out.valueMeta.multiplierSource[variant] = "amvgg-direct";
      continue;
    }

    if (BASE_VARIANTS.has(variant)) {
      out[variant] = 0;
      out.valueMeta.calculated[variant] = false;
      out.valueMeta.multiplierSource[variant] = "missing-base";
      continue;
    }

    const baseVariant = VARIANTS[variant].base;
    const baseValue = item.rawValues[baseVariant] || 0;

    if (baseValue <= 0) {
      out[variant] = 0;
      out.valueMeta.calculated[variant] = false;
      out.valueMeta.multiplierSource[variant] = "missing-base";
      continue;
    }

    const multiplierInfo = getMultiplierForVariant(categoryId, variant, multipliers);

    if (multiplierInfo.multiplier <= 0) {
      out[variant] = 0;
      out.valueMeta.calculated[variant] = false;
      out.valueMeta.multiplierSource[variant] = "no-multiplier";
      continue;
    }

    out[variant] = roundValue(baseValue * multiplierInfo.multiplier);
    out.valueMeta.calculated[variant] = true;
    out.valueMeta.multiplierSource[variant] = multiplierInfo.source;
  }

  return out;
}

async function main() {
  const allItems = new Map();

  for (const url of AMVGG_URLS) {
    try {
      const text = await fetchText(url);
      const items = extractItemsFromText(text);

      console.log(`Found ${items.size} item(s) from ${url}`);

      for (const [key, item] of items.entries()) {
        if (!allItems.has(key)) {
          allItems.set(key, item);
        }
      }
    } catch (error) {
      console.warn(`Failed ${url}:`, error.message || error);
    }
  }

  const rawItems = Array.from(allItems.values());
  const samples = buildMultiplierSamples(rawItems);
  const multipliers = summarizeMultipliers(samples);

  for (const item of rawItems) {
    fillMissingValues(item, multipliers);
  }

  const sortedItems = Object.fromEntries(
    rawItems
      .map(item => [item.key, item.value])
      .sort(([a], [b]) => a.localeCompare(b))
  );

  const output = {
    version: 2,
    updatedAt: new Date().toISOString(),
    source: "amvgg-auto-generated-with-category-multipliers",
    sourceUrls: AMVGG_URLS,
    itemCount: Object.keys(sortedItems).length,

    multiplierRules: {
      NP: "FR * category NP multiplier",
      F: "FR * category F multiplier",
      R: "FR * category R multiplier",
      N: "NFR * category N multiplier",
      NF: "NFR * category NF multiplier",
      NR: "NFR * category NR multiplier",
      M: "MFR * category M multiplier",
      MF: "MFR * category MF multiplier",
      MR: "MFR * category MR multiplier"
    },

    variantKeys: {
      NP: "No Potion / Normal",
      F: "Fly Only",
      R: "Ride Only",
      FR: "Fly Ride",
      N: "Neon No Potion",
      NF: "Neon Fly",
      NR: "Neon Ride",
      NFR: "Neon Fly Ride",
      M: "Mega No Potion",
      MF: "Mega Fly",
      MR: "Mega Ride",
      MFR: "Mega Fly Ride"
    },

    categoryMultipliers: multipliers.categoryMultipliers,
    globalMultipliers: multipliers.globalMultipliers,
    items: sortedItems
  };

  if (output.itemCount < 50) {
    throw new Error(`Only found ${output.itemCount} items. Parser probably needs adjustment.`);
  }

  await fs.writeFile(OUT_FILE, JSON.stringify(output, null, 2) + "\n");

  console.log(`Wrote ${OUT_FILE} with ${output.itemCount} item(s).`);
}

main().catch(error => {
  console.error(error);
  process.exit(1);
});

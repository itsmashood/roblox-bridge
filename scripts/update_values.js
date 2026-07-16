const fs = require("fs/promises");

const AMVGG_URLS = [
  "https://amvgg.com/calculator?_rsc=19zvn",
  "https://amvgg.com/calculator",
  "https://amvgg.com/values/pets"
];

const OUT_FILE = "values";

const MANUAL_CATEGORY_MULTIPLIERS = {
  "0": {
    "NP": 0.0857142857,
    "F": 0.6,
    "R": 0.5142857143,
    "N": 0.2142857143,
    "NF": 0.7571428571,
    "NR": 0.6,
    "M": 0.45,
    "MF": 0.775,
    "MR": 0.65
  },
  "1": {
    "NP": 0.0857142857,
    "F": 0.6,
    "R": 0.5142857143,
    "N": 0.2142857143,
    "NF": 0.7571428571,
    "NR": 0.6,
    "M": 0.45,
    "MF": 0.775,
    "MR": 0.65
  },
  "2": {
    "NP": 0.0857142857,
    "F": 0.6,
    "R": 0.5142857143,
    "N": 0.2142857143,
    "NF": 0.7571428571,
    "NR": 0.6,
    "M": 0.45,
    "MF": 0.775,
    "MR": 0.65
  },
  "3": {
    "NP": 0.1263157895,
    "F": 0.6526315789,
    "R": 0.6105263158,
    "N": 0.5473684211,
    "NF": 0.8105263158,
    "NR": 0.8,
    "M": 0.7261538462,
    "MF": 0.8492307692,
    "MR": 0.8
  },
  "4": {
    "NP": 0.1636363636,
    "F": 0.7090909091,
    "R": 0.6545454545,
    "N": 0.6272727273,
    "NF": 0.8181818182,
    "NR": 0.8090909091,
    "M": 0.75,
    "MF": 0.86,
    "MR": 0.825
  },
  "5": {
    "NP": 0.2,
    "F": 0.7333333333,
    "R": 0.6833333333,
    "N": 0.675,
    "NF": 0.8333333333,
    "NR": 0.8166666667,
    "M": 0.7755555556,
    "MF": 0.8911111111,
    "MR": 0.8511111111
  },
  "6": {
    "NP": 0.3,
    "F": 0.75,
    "R": 0.7,
    "N": 0.725,
    "NF": 0.8666666667,
    "NR": 0.85,
    "M": 0.8244444444,
    "MF": 0.9244444444,
    "MR": 0.9
  },
  "7": {
    "NP": 0.4571428571,
    "F": 0.7714285714,
    "R": 0.7285714286,
    "N": 0.75,
    "NF": 0.91,
    "NR": 0.9,
    "M": 0.85,
    "MF": 0.95,
    "MR": 0.92
  },
  "8": {
    "NP": 0.5529411765,
    "F": 0.8,
    "R": 0.7529411765,
    "N": 0.7709090909,
    "NF": 0.9163636364,
    "NR": 0.9018181818,
    "M": 0.8754545455,
    "MF": 0.96,
    "MR": 0.93
  },
  "9": {
    "NP": 0.6538461538,
    "F": 0.8538461538,
    "R": 0.8230769231,
    "N": 0.8495238095,
    "NF": 0.940952381,
    "NR": 0.9257142857,
    "M": 0.9252380952,
    "MF": 0.9752380952,
    "MR": 0.95
  },
  "10": {
    "NP": 0.8,
    "F": 0.925,
    "R": 0.9,
    "N": 0.925,
    "NF": 0.97,
    "NR": 0.96,
    "M": 0.2727272727,
    "MF": 0.99,
    "MR": 0.98
  },
  "11": {
    "NP": 0.9,
    "F": 0.975,
    "R": 0.95,
    "N": 1.0,
    "NF": 0.9852307692,
    "NR": 0.9803076923,
    "M": 1.05,
    "MF": 1.0,
    "MR": 1.0
  },
  "12": {
    "NP": 0.8965517241,
    "F": 0.9793103448,
    "R": 0.9517241379,
    "N": 1.03,
    "NF": 0.985,
    "NR": 0.98,
    "M": 1.1,
    "MF": 1.0,
    "MR": 1.0
  },
  "13": {
    "NP": 0.9936305732,
    "F": 1.0,
    "R": 1.0,
    "N": 1.0094339623,
    "NF": 1.0,
    "NR": 1.0,
    "M": 1.0374331551,
    "MF": 1.0053475936,
    "MR": 1.0053475936
  },
  "21": {
    "NP": 0.7692307692,
    "F": 0.8846153846,
    "R": 0.8461538462,
    "N": 0.88,
    "NF": 0.95,
    "NR": 0.93,
    "M": 1.0,
    "MF": 0.99,
    "MR": 0.98
  },
  "22": {
    "NP": 0.7636363636,
    "F": 0.8727272727,
    "R": 0.8727272727,
    "N": 0.88,
    "NF": 0.95,
    "NR": 0.93,
    "M": 0.97,
    "MF": 0.99,
    "MR": 0.98
  },
  "23": {
    "NP": 0.7,
    "F": 0.8533333333,
    "R": 0.8,
    "N": 0.85,
    "NF": 0.93,
    "NR": 0.9,
    "M": 0.95,
    "MF": 0.985,
    "MR": 0.965
  },
  "33": {
    "NP": 0.1395348837,
    "F": 0.6511627907,
    "R": 0.6046511628,
    "N": 0.3529411765,
    "NF": 0.8,
    "NR": 0.7529411765,
    "M": 0.5018181818,
    "MF": 0.8,
    "MR": 0.7018181818
  },
  "44": {
    "NP": 0.9720930233,
    "F": 0.9860465116,
    "R": 0.9813953488,
    "N": 1.0,
    "NF": 1.0,
    "NR": 1.0,
    "M": 1.025,
    "MF": 1.0,
    "MR": 1.0
  },
  "50": {
    "NP": 0.9851851852,
    "F": 0.9955555556,
    "R": 0.9896296296,
    "N": 1.0,
    "NF": 1.0,
    "NR": 1.0,
    "M": 1.025,
    "MF": 1.0,
    "MR": 1.0
  },
  "66": {
    "NP": 0.9,
    "F": 0.98,
    "R": 0.96,
    "N": 1.0,
    "NF": 0.985,
    "NR": 0.98,
    "M": 1.125,
    "MF": 1.0,
    "MR": 1.0
  },
  "69": {
    "NP": 0.9028571429,
    "F": 0.9714285714,
    "R": 0.9485714286,
    "N": 0.96,
    "NF": 0.9850746269,
    "NR": 0.98,
    "M": 1.0,
    "MF": 1.0,
    "MR": 1.0
  },
  "70": {
    "NP": 0.9381818182,
    "F": 0.9818181818,
    "R": 0.96,
    "N": 0.97,
    "NF": 0.99,
    "NR": 0.98,
    "M": 1.0,
    "MF": 1.0,
    "MR": 1.0
  },
  "72": {
    "NP": 0.94,
    "F": 0.98,
    "R": 0.96,
    "N": 0.9701098901,
    "NF": 0.9901098901,
    "NR": 0.98,
    "M": 1.05,
    "MF": 1.0,
    "MR": 1.0
  },
  "79": {
    "NP": 0.9692307692,
    "F": 0.9846153846,
    "R": 0.9794871795,
    "N": 1.0,
    "NF": 1.0,
    "NR": 1.0,
    "M": 1.0500215054,
    "MF": 1.0,
    "MR": 1.0
  },
  "81": {
    "NP": 0.98,
    "F": 0.99,
    "R": 0.985,
    "N": 1.0,
    "NF": 1.0,
    "NR": 1.0,
    "M": 1.025,
    "MF": 1.0,
    "MR": 1.0
  },
  "99": {
    "NP": 0.8,
    "F": 0.9166666667,
    "R": 0.9,
    "N": 0.9502040816,
    "NF": 0.98,
    "NR": 0.9751020408,
    "M": 1.0,
    "MF": 1.0,
    "MR": 1.0
  },
  "111": {
    "NP": 0.0333333333,
    "F": 0.6,
    "R": 0.5,
    "N": 0.1272727273,
    "NF": 0.7454545455,
    "NR": 0.6,
    "M": 0.3272727273,
    "MF": 0.7545454545,
    "MR": 0.6545454545
  },
  "222": {
    "NP": 0.0333333333,
    "F": 0.5666666667,
    "R": 0.4666666667,
    "N": 0.08,
    "NF": 0.66,
    "NR": 0.5,
    "M": 0.275,
    "MF": 0.65,
    "MR": 0.55
  },
  "333": {
    "NP": 0.0333333333,
    "F": 0.6,
    "R": 0.5,
    "N": 0.1,
    "NF": 0.7,
    "NR": 0.56,
    "M": 0.3,
    "MF": 0.7,
    "MR": 0.6
  }
};

const MANUAL_CATEGORY_NOTES = {
  "3": "DFR was omitted in the supplied category text; using Arctic Hare DFR/FR 0.0048.",
  "5": "NFR was omitted in the supplied category text; using Angus Bull NFR 0.012.",
  "8": "DFR was omitted in the supplied category text; using Binturong DFR/FR 0.0085.",
  "10": "DFR was omitted in the supplied category text; using Arctic Fox DFR/FR 0.04."
};

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
  if (!cleaned || cleaned === "null") return 0;

  const n = Number(cleaned);
  return Number.isFinite(n) && n > 0 ? n : 0;
}

function roundValue(value) {
  if (!Number.isFinite(value) || value <= 0) return 0;
  return Math.round(value * 1000000) / 1000000;
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

  return "unknown";
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
        confidence: {},
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

function getManualMultiplier(categoryId, variant) {
  const categoryMultipliers = MANUAL_CATEGORY_MULTIPLIERS[String(categoryId || "")];

  if (!categoryMultipliers) {
    return 0;
  }

  return toNumber(categoryMultipliers[variant]);
}

function fillMissingValues(item) {
  const out = item.value;
  const categoryId = String(item.categoryId || "");
  const hasManualCategory = Boolean(MANUAL_CATEGORY_MULTIPLIERS[categoryId]);

  for (const variant of Object.keys(VARIANTS)) {
    const rawValue = item.rawValues[variant] || 0;

    out.valueMeta.originalRaw[variant] = rawValue || null;

    if (rawValue > 0) {
      out[variant] = rawValue;
      out.valueMeta.calculated[variant] = false;
      out.valueMeta.multiplierSource[variant] = "amvgg-direct";
      out.valueMeta.confidence[variant] = "direct";
      continue;
    }

    if (BASE_VARIANTS.has(variant)) {
      out[variant] = 0;
      out.valueMeta.calculated[variant] = false;
      out.valueMeta.multiplierSource[variant] = "missing-base";
      out.valueMeta.confidence[variant] = "blocked";
      continue;
    }

    const baseVariant = VARIANTS[variant].base;
    const baseValue = item.rawValues[baseVariant] || 0;

    if (baseValue <= 0) {
      out[variant] = 0;
      out.valueMeta.calculated[variant] = false;
      out.valueMeta.multiplierSource[variant] = "missing-base";
      out.valueMeta.confidence[variant] = "blocked";
      continue;
    }

    if (!hasManualCategory) {
      out[variant] = 0;
      out.valueMeta.calculated[variant] = false;
      out.valueMeta.multiplierSource[variant] = "no-manual-category";
      out.valueMeta.confidence[variant] = "blocked";
      continue;
    }

    const multiplier = getManualMultiplier(categoryId, variant);

    if (multiplier <= 0) {
      out[variant] = 0;
      out.valueMeta.calculated[variant] = false;
      out.valueMeta.multiplierSource[variant] = "no-manual-multiplier";
      out.valueMeta.confidence[variant] = "blocked";
      continue;
    }

    out[variant] = roundValue(baseValue * multiplier);
    out.valueMeta.calculated[variant] = true;
    out.valueMeta.multiplierSource[variant] = "manual-category:" + categoryId;
    out.valueMeta.confidence[variant] = "manual-category";
  }

  return out;
}

function buildCategoryCounts(rawItems) {
  const counts = {};

  for (const item of rawItems) {
    const categoryId = String(item.categoryId || "unknown");
    counts[categoryId] = (counts[categoryId] || 0) + 1;
  }

  return Object.fromEntries(
    Object.entries(counts).sort(([a], [b]) => Number(a) - Number(b))
  );
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

  for (const item of rawItems) {
    fillMissingValues(item);
  }

  const sortedItems = Object.fromEntries(
    rawItems
      .map(item => [item.key, item.value])
      .sort(([a], [b]) => a.localeCompare(b))
  );

  const output = {
    version: 3,
    updatedAt: new Date().toISOString(),
    source: "amvgg-auto-generated-with-manual-category-multipliers",
    sourceUrls: AMVGG_URLS,
    itemCount: Object.keys(sortedItems).length,

    valueRules: {
      NP: "D / DFR, then FR * category NP multiplier when AMVGG direct value is missing",
      F: "DF / DFR, then FR * category F multiplier when AMVGG direct value is missing",
      R: "DR / DFR, then FR * category R multiplier when AMVGG direct value is missing",
      N: "N / NFR, then NFR * category N multiplier when AMVGG direct value is missing",
      NF: "NF / NFR, then NFR * category NF multiplier when AMVGG direct value is missing",
      NR: "NR / NFR, then NFR * category NR multiplier when AMVGG direct value is missing",
      M: "M / MFR, then MFR * category M multiplier when AMVGG direct value is missing",
      MF: "MF / MFR, then MFR * category MF multiplier when AMVGG direct value is missing",
      MR: "MR / MFR, then MFR * category MR multiplier when AMVGG direct value is missing"
    },

    variantKeys: {
      NP: "Default / Normal / No Potion",
      F: "Default Fly",
      R: "Default Ride",
      FR: "Default Fly Ride",
      N: "Neon No Potion",
      NF: "Neon Fly",
      NR: "Neon Ride",
      NFR: "Neon Fly Ride",
      M: "Mega No Potion",
      MF: "Mega Fly",
      MR: "Mega Ride",
      MFR: "Mega Fly Ride"
    },

    manualCategoryMultiplierCount: Object.keys(MANUAL_CATEGORY_MULTIPLIERS).length,
    manualCategoryMultipliers: MANUAL_CATEGORY_MULTIPLIERS,
    manualCategoryNotes: MANUAL_CATEGORY_NOTES,
    categoryPetCounts: buildCategoryCounts(rawItems),

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

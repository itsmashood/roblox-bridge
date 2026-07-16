const fs = require("fs/promises");

const AMVGG_URLS = [
  "https://amvgg.com/calculator?_rsc=19zvn",
  "https://amvgg.com/calculator",
  "https://amvgg.com/values/pets"
];

const OUT_FILE = "values";

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

  for (let tries = 0; tries < 20; tries++) {
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

function makeAliases(displayName, key) {
  const aliases = new Set();

  const clean = normalizeKey(displayName);
  if (clean && clean !== key) aliases.add(clean);

  if (clean.includes(" dragon")) {
    aliases.add(clean.replace(" dragon", " drag"));
  }

  if (clean.includes(" unicorn")) {
    aliases.add(clean.replace(" unicorn", " uni"));
  }

  return Array.from(aliases);
}

function convertAmvggObject(obj) {
  const displayName = extractDisplayName(obj);
  const key = normalizeKey(displayName);

  if (!key || key.length < 2) return null;

  return {
    key,
    value: {
      displayName,
      category: "pet",

      "NP": toNumber(obj.npRegularValue),
      "F": toNumber(obj.fValue),
      "R": toNumber(obj.rValue),
      "FR": toNumber(obj.regularValue),

      "N": toNumber(obj.npNeonValue),
      "NF": toNumber(obj.nfValue),
      "NR": toNumber(obj.nrValue),
      "NFR": toNumber(obj.neonValue),

      "M": toNumber(obj.npMegaValue),
      "MF": toNumber(obj.mfValue),
      "MR": toNumber(obj.mrValue),
      "MFR": toNumber(obj.megaValue),

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
    if (markerIndex === -1) break;

    const candidates = parseObjectCandidatesAround(text, markerIndex);

    for (const obj of candidates) {
      if (!objectHasValueFields(obj)) continue;

      const converted = convertAmvggObject(obj);
      if (!converted) continue;

      if (!items.has(converted.key)) {
        items.set(converted.key, converted.value);
      }
    }

    index = markerIndex + marker.length;
  }

  return items;
}

async function main() {
  const allItems = new Map();

  for (const url of AMVGG_URLS) {
    try {
      const text = await fetchText(url);
      const items = extractItemsFromText(text);

      console.log(`Found ${items.size} item(s) from ${url}`);

      for (const [key, value] of items.entries()) {
        if (!allItems.has(key)) {
          allItems.set(key, value);
        }
      }
    } catch (error) {
      console.warn(`Failed ${url}:`, error.message || error);
    }
  }

  const sortedItems = Object.fromEntries(
    Array.from(allItems.entries()).sort(([a], [b]) => a.localeCompare(b))
  );

  const output = {
    version: 1,
    updatedAt: new Date().toISOString(),
    source: "amvgg-auto-generated",
    sourceUrls: AMVGG_URLS,
    itemCount: Object.keys(sortedItems).length,
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

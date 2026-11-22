const fs = require("fs/promises");

const ELVEBREDD_URL = process.env.ELVEBREDD_URL || "https://elvebredd.com/adopt-me-calculator";
const OUT_FILE = process.env.OUT_FILE || "values_elvebredd";
const MIN_ITEMS = Number(process.env.MIN_ITEMS || 100);
const MIN_PREVIOUS_ITEM_RATIO = Number(process.env.MIN_PREVIOUS_ITEM_RATIO || 0.90);
const MIN_PREVIOUS_OVERLAP_RATIO = Number(process.env.MIN_PREVIOUS_OVERLAP_RATIO || 0.85);
const MIN_PREVIOUS_NONZERO_RATIO = Number(process.env.MIN_PREVIOUS_NONZERO_RATIO || 0.85);
const BROWSER_WAIT_MS = Number(process.env.BROWSER_WAIT_MS || 12000);
const DIAGNOSTICS_FILE = process.env.DIAGNOSTICS_FILE || "elvebredd_fetch_diagnostics.json";

const VARIANTS = ["NP", "F", "R", "FR", "N", "NF", "NR", "NFR", "M", "MF", "MR", "MFR"];

const EXPLICIT_PET_TAGS = new Set([
  "pet",
  "pets"
]);

const EXPLICIT_NON_PET_TAGS = new Set([
  "egg",
  "eggs",
  "food",
  "foods",
  "toy",
  "toys",
  "stroller",
  "strollers",
  "vehicle",
  "vehicles",
  "gift",
  "gifts",
  "pet wear",
  "petwear",
  "pet wears",
  "wing",
  "wings",
  "potion",
  "potions",
  "accessory",
  "accessories"
]);

const PET_SPECIFIC_VALUE_KEYS = [
  "rvalue - nopotion",
  "rvalue-nopotion",
  "rvalue_nopotion",
  "rvalue no potion",
  "rvalue nopotion",
  "npvalue",
  "no potion",
  "nopotion",
  "noPotionValue",

  "rvalue - fly",
  "rvalue-fly",
  "rvalue_fly",
  "rvalue fly",
  "flyvalue",
  "fly value",

  "rvalue - ride",
  "rvalue-ride",
  "rvalue_ride",
  "rvalue ride",
  "ridevalue",
  "ride value",

  "nvalue",
  "neon value",
  "neonValue",
  "nvalue - nopotion",
  "nvalue-nopotion",
  "nvalue_nopotion",
  "nvalue no potion",
  "nvalue nopotion",
  "neon no potion",
  "neonNoPotionValue",
  "nvalue - fly",
  "nvalue-fly",
  "nvalue_fly",
  "neon fly",
  "neonFlyValue",
  "nvalue - ride",
  "nvalue-ride",
  "nvalue_ride",
  "neon ride",
  "neonRideValue",
  "nvalue - fly ride",
  "nvalue - fr",
  "nvalue-fr",
  "nvalue_fr",
  "neon fly ride",
  "neonFlyRideValue",
  "nfrvalue",

  "mvalue",
  "mega value",
  "megaValue",
  "mvalue - nopotion",
  "mvalue-nopotion",
  "mvalue_nopotion",
  "mvalue no potion",
  "mvalue nopotion",
  "mega no potion",
  "megaNoPotionValue",
  "mvalue - fly",
  "mvalue-fly",
  "mvalue_fly",
  "mega fly",
  "megaFlyValue",
  "mvalue - ride",
  "mvalue-ride",
  "mvalue_ride",
  "mega ride",
  "megaRideValue",
  "mvalue - fly ride",
  "mvalue - fr",
  "mvalue-fr",
  "mvalue_fr",
  "mega fly ride",
  "megaFlyRideValue",
  "mfrvalue"
];

const KNOWN_NON_PET_SENTINELS = [
  "royal egg",
  "retired egg",
  "ride a pet potion forever",
  "choosy potion"
];

function normalizeName(value) {
  return String(value || "")
    .toLowerCase()
    .replace(/&amp;/g, "&")
    .replace(/[^a-z0-9]+/g, " ")
    .replace(/\s+/g, " ")
    .trim();
}

function cleanName(value) {
  return String(value || "")
    .replace(/\\u0026/g, "&")
    .replace(/&amp;/g, "&")
    .replace(/&quot;/g, '"')
    .replace(/&#39;/g, "'")
    .replace(/\\\//g, "/")
    .replace(/\s+/g, " ")
    .trim();
}

function toNumber(value) {
  if (value === null || value === undefined) return 0;
  if (typeof value === "number") return Number.isFinite(value) && value > 0 ? value : 0;

  const text = String(value).replace(/,/g, "").trim();
  if (!text || text === "false" || text === "true" || text.toLowerCase() === "nan") return 0;

  const match = text.match(/-?\d+(?:\.\d+)?/);
  if (!match) return 0;

  const n = Number(match[0]);
  return Number.isFinite(n) && n > 0 ? n : 0;
}

function roundValue(value) {
  if (!Number.isFinite(value) || value <= 0) return 0;
  return Math.round(value * 1000000) / 1000000;
}

function getCaseInsensitive(obj, keys) {
  if (!obj || typeof obj !== "object") return undefined;

  for (const key of keys) {
    if (Object.prototype.hasOwnProperty.call(obj, key)) return obj[key];
  }

  const normalizedWanted = keys.map(k => normalizeName(k));
  for (const [key, value] of Object.entries(obj)) {
    const nk = normalizeName(key);
    if (normalizedWanted.includes(nk)) return value;
  }

  return undefined;
}

function firstPositiveNumber(obj, keys) {
  for (const key of keys) {
    const value = getCaseInsensitive(obj, [key]);
    const n = toNumber(value);
    if (n > 0) return n;
  }
  return 0;
}

function itemNameFromElvebredd(raw) {
  return cleanName(
    raw.name ||
    raw.displayName ||
    raw.display_name ||
    raw.petName ||
    raw.itemName ||
    raw.title ||
    raw.label ||
    raw.d ||
    ""
  );
}

function buildAliases(displayName, key) {
  const aliases = new Set();
  const normalized = normalizeName(displayName);

  if (normalized && normalized !== key) aliases.add(normalized);

  const shorthandPairs = [
    [" dragon", " drag"],
    [" unicorn", " uni"],
    [" kangaroo", " kanga"],
    [" turtle", " turt"],
    [" tyrannosaurus rex", " t rex"],
    [" t rex", " trex"],
    [" strawberry shortcake bat dragon", " ssbd"],
    [" chocolate chip bat dragon", " ccbd"]
  ];

  for (const [from, to] of shorthandPairs) {
    if (normalized.includes(from)) aliases.add(normalized.replace(from, to));
  }

  return Array.from(aliases).filter(Boolean);
}

function makeBlankItem(displayName, raw) {
  const category = cleanName(raw.type || raw.category || raw.rarity || raw.kind || "unknown").toLowerCase() || "unknown";

  return {
    displayName,
    category,
    source: "elvebredd",
    NP: 0,
    F: 0,
    R: 0,
    FR: 0,
    N: 0,
    NF: 0,
    NR: 0,
    NFR: 0,
    M: 0,
    MF: 0,
    MR: 0,
    MFR: 0,
    demand: {},
    aliases: [],
    valueMeta: {
      source: {},
      confidence: {},
      originalRaw: {},
      notes: []
    }
  };
}

function setVariant(item, variant, value, sourceKey, confidence) {
  const n = roundValue(value);
  if (!VARIANTS.includes(variant) || n <= 0) return false;

  item[variant] = n;
  item.valueMeta.source[variant] = sourceKey;
  item.valueMeta.confidence[variant] = confidence;
  item.valueMeta.originalRaw[variant] = value;
  return true;
}

function classificationTags(raw) {
  const fields = [
    raw.type,
    raw.category,
    raw.kind,
    raw.itemType,
    raw.item_type,
    raw.categoryName,
    raw.category_name,
    raw.group,
    raw.section
  ];

  return Array.from(
    new Set(fields.map(normalizeName).filter(Boolean))
  );
}

function hasPetSpecificValueEvidence(raw) {
  return firstPositiveNumber(raw, PET_SPECIFIC_VALUE_KEYS) > 0;
}

function strongNonPetNameReason(displayName) {
  const name = normalizeName(displayName);



  if (name === "egg" || name.endsWith(" egg")) return "name is an egg item";
  if (/(^| )potion( |$)/.test(name)) return "name contains standalone 'potion'";

  return null;
}

function classifyElvebreddItem(raw, displayName) {
  const tags = classificationTags(raw);
  const explicitPetTag = tags.find(tag => EXPLICIT_PET_TAGS.has(tag)) || null;
  const explicitNonPetTag = tags.find(tag => EXPLICIT_NON_PET_TAGS.has(tag)) || null;
  const petSpecificValueEvidence = hasPetSpecificValueEvidence(raw);
  const nameNonPetReason = strongNonPetNameReason(displayName);



  if (nameNonPetReason) {
    if (petSpecificValueEvidence) {
      return {
        kind: "unknown",
        reason: `${nameNonPetReason}, but pet-specific value fields were also present`
      };
    }

    return {
      kind: "nonpet",
      reason: nameNonPetReason
    };
  }

  if (explicitNonPetTag) {
    if (petSpecificValueEvidence) {
      return {
        kind: "unknown",
        reason: `non-pet tag '${explicitNonPetTag}' conflicted with pet-specific value fields`
      };
    }

    return {
      kind: "nonpet",
      reason: `explicit Elvebredd category/type '${explicitNonPetTag}'`
    };
  }

  if (explicitPetTag || petSpecificValueEvidence) {
    return {
      kind: "pet",
      reason: explicitPetTag
        ? `explicit Elvebredd category/type '${explicitPetTag}'`
        : "pet-specific potion/neon/mega value fields were present"
    };
  }

  return {
    kind: "unknown",
    reason: tags.length > 0
      ? `unrecognized category/type tag(s): ${tags.join(", ")}`
      : "no reliable pet/non-pet classification evidence"
  };
}

function copyVariantPreservingMetadata(item, targetVariant, donorVariant, note) {
  if ((item[targetVariant] || 0) > 0) return false;
  if ((item[donorVariant] || 0) <= 0) return false;

  const donorSource = item.valueMeta.source[donorVariant] || `elvebredd:${donorVariant.toLowerCase()}`;
  const donorConfidence = item.valueMeta.confidence[donorVariant] || "direct";
  const donorOriginalRaw = Object.prototype.hasOwnProperty.call(item.valueMeta.originalRaw, donorVariant)
    ? item.valueMeta.originalRaw[donorVariant]
    : item[donorVariant];

  item[targetVariant] = item[donorVariant];
  item.valueMeta.source[targetVariant] = donorSource;
  item.valueMeta.confidence[targetVariant] = donorConfidence;
  item.valueMeta.originalRaw[targetVariant] = donorOriginalRaw;

  if (note) item.valueMeta.notes.push(note);
  return true;
}

function convertElvebreddItem(raw) {
  if (!raw || typeof raw !== "object" || Array.isArray(raw)) return null;

  const displayName = itemNameFromElvebredd(raw);
  if (!displayName || displayName.length < 2) return null;

  const key = normalizeName(displayName);
  if (!key) return null;

  const item = makeBlankItem(displayName, raw);
  item.aliases = buildAliases(displayName, key);
  item.valueMeta.elvebreddId = raw.id ?? raw.petId ?? raw.itemId ?? null;
  item.valueMeta.status = raw.status || null;
  item.valueMeta.rarity = raw.rarity || null;
  item.valueMeta.image = raw.image || null;

  const mapping = {
    NP: [
      "rvalue - nopotion",
      "rvalue-nopotion",
      "rvalue_nopotion",
      "rvalue no potion",
      "rvalue nopotion",
      "npvalue",
      "no potion",
      "nopotion",
      "noPotionValue"
    ],
    F: [
      "rvalue - fly",
      "rvalue-fly",
      "rvalue_fly",
      "rvalue fly",
      "flyvalue",
      "fly value"
    ],
    R: [
      "rvalue - ride",
      "rvalue-ride",
      "rvalue_ride",
      "rvalue ride",
      "ridevalue",
      "ride value"
    ],







    FR: [
      "rvalue - fly ride",
      "rvalue - fr",
      "rvalue-fr",
      "rvalue_fr",
      "regular value",
      "regularValue",
      "frvalue",
      "fly ride",
      "flyride",
      "value",
      "rvalue"
    ],




    N: [
      "nvalue - nopotion",
      "nvalue-nopotion",
      "nvalue_nopotion",
      "nvalue no potion",
      "nvalue nopotion",
      "neon no potion",
      "neonNoPotionValue"
    ],
    NF: [
      "nvalue - fly",
      "nvalue-fly",
      "nvalue_fly",
      "neon fly",
      "neonFlyValue"
    ],
    NR: [
      "nvalue - ride",
      "nvalue-ride",
      "nvalue_ride",
      "neon ride",
      "neonRideValue"
    ],
    // FIX: no idea what i did here





    NFR: [
      "nvalue - fly ride",
      "nvalue - fr",
      "nvalue-fr",
      "nvalue_fr",
      "neon fly ride",
      "neonFlyRideValue",
      "nfrvalue",
      "nvalue"
    ],


    M: [
      "mvalue - nopotion",
      "mvalue-nopotion",
      "mvalue_nopotion",
      "mvalue no potion",
      "mvalue nopotion",
      "mega no potion",
      "megaNoPotionValue"
    ],
    MF: [
      "mvalue - fly",
      "mvalue-fly",
      "mvalue_fly",
      "mega fly",
      "megaFlyValue"
    ],
    MR: [
      "mvalue - ride",
      "mvalue-ride",
      "mvalue_ride",
      "mega ride",
      "megaRideValue"
    ],

    MFR: [
      "mvalue",
      "mvalue - fly ride",
      "mvalue - fr",
      "mvalue-fr",
      "mvalue_fr",
      "mega fly ride",
      "megaFlyRideValue",
      "mfrvalue"
    ]
  };

  let foundAny = false;

  for (const [variant, keys] of Object.entries(mapping)) {
    const value = firstPositiveNumber(raw, keys);
    if (value > 0) {
      setVariant(item, variant, value, `elvebredd:${keys[0]}`, "direct");
      foundAny = true;
    }
  }

  if (!foundAny) return null;

  const classification = classifyElvebreddItem(raw, displayName);

  if ((item.NP || 0) <= 0 && (item.FR || 0) > 0 && classification.kind === "nonpet") {
    copyVariantPreservingMetadata(
      item,
      "NP",
      "FR",
      `NP copied from Elvebredd's regular rvalue for confirmed non-pet (${classification.reason}). FR was preserved for backwards compatibility.`
    );
  }

  if ((item.NP || 0) <= 0 && (item.FR || 0) > 0) {
    item.valueMeta.notes.push(
      `NP was not exposed by Elvebredd and was not inferred because this item was not confidently classified as a non-pet (${classification.reason}).`
    );
  }

  if ((item.NFR || 0) <= 0 && (item.N || 0) > 0) {
    item.valueMeta.notes.push("NFR was not exposed separately by Elvebredd for this item, so it is left as 0/unknown.");
  }

  if ((item.MFR || 0) <= 0 && (item.M || 0) > 0) {
    item.valueMeta.notes.push("MFR was not exposed separately by Elvebredd for this item, so it is left as 0/unknown.");
  }

  return { key, item };
}

function findMatchingBracket(text, openIndex, openChar, closeChar) {
  let depth = 0;
  let inString = false;
  let quote = "";
  let escaped = false;

  for (let i = openIndex; i < text.length; i++) {
    const ch = text[i];

    if (inString) {
      if (escaped) escaped = false;
      else if (ch === "\\") escaped = true;
      else if (ch === quote) inString = false;
      continue;
    }

    if (ch === '"' || ch === "'") {
      inString = true;
      quote = ch;
      continue;
    }

    if (ch === openChar) depth++;
    else if (ch === closeChar) depth--;

    if (depth === 0) return i;
  }

  return -1;
}

function tryJsonParse(text) {
  try {
    return JSON.parse(text);
  } catch (_) {
    return null;
  }
}

function htmlDecodeMinimal(text) {
  return String(text || "")
    .replace(/&quot;/g, '"')
    .replace(/&#34;/g, '"')
    .replace(/&#x27;/g, "'")
    .replace(/&#39;/g, "'")
    .replace(/&amp;/g, "&")
    .replace(/&lt;/g, "<")
    .replace(/&gt;/g, ">");
}

function unescapeTextLayer(text) {
  let out = htmlDecodeMinimal(String(text || ""));

  for (let i = 0; i < 4; i++) {
    const parsed = tryJsonParse(`"${out.replace(/\\/g, "\\\\").replace(/"/g, '\\"')}"`);
    if (typeof parsed === "string" && parsed !== out) out = parsed;

    const manually = out
      .replace(/\\"/g, '"')
      .replace(/\\\//g, "/")
      .replace(/\\n/g, "\n")
      .replace(/\\r/g, "\r")
      .replace(/\\t/g, "\t")
      .replace(/\\u0026/g, "&");

    if (manually === out) break;
    out = manually;
  }

  return out;
}

function walk(value, onString, seen = new WeakSet()) {
  if (typeof value === "string") {
    onString(value);
    return;
  }

  if (!value || typeof value !== "object") return;
  if (seen.has(value)) return;
  seen.add(value);

  if (Array.isArray(value)) {
    for (const child of value) walk(child, onString, seen);
    return;
  }

  for (const child of Object.values(value)) walk(child, onString, seen);
}

function collectStringsFromNextFlight(html) {
  const strings = [];
  const needle = "self.__next_f.push";
  let index = 0;

  while (true) {
    const pushIndex = html.indexOf(needle, index);
    if (pushIndex === -1) break;

    const openIndex = html.indexOf("(", pushIndex);
    if (openIndex === -1) break;

    const closeIndex = findMatchingBracket(html, openIndex, "(", ")");
    if (closeIndex === -1) {
      index = pushIndex + needle.length;
      continue;
    }

    const rawArg = html.slice(openIndex + 1, closeIndex);
    const parsed = tryJsonParse(rawArg);

    if (parsed) {
      walk(parsed, s => strings.push(s));
    } else {
      strings.push(rawArg);
    }

    index = closeIndex + 1;
  }

  return strings;
}

function extractInitialPetsArraysFromText(text) {
  const arrays = [];
  const versions = new Set();

  const candidates = [String(text || ""), unescapeTextLayer(text)];

  for (const candidate of candidates) {
    if (!candidate || versions.has(candidate)) continue;
    versions.add(candidate);

    let index = 0;

    while (true) {
      const markerIndex = candidate.indexOf("initialPets", index);
      if (markerIndex === -1) break;

      const colonIndex = candidate.indexOf(":", markerIndex);
      const openIndex = candidate.indexOf("[", colonIndex === -1 ? markerIndex : colonIndex);

      if (openIndex !== -1) {
        const closeIndex = findMatchingBracket(candidate, openIndex, "[", "]");
        if (closeIndex !== -1) {
          const rawArray = candidate.slice(openIndex, closeIndex + 1);
          const parsed = tryJsonParse(rawArray) || tryJsonParse(unescapeTextLayer(rawArray));

          if (Array.isArray(parsed)) arrays.push(parsed);

          index = closeIndex + 1;
          continue;
        }
      }

      index = markerIndex + "initialPets".length;
    }
  }

  return arrays;
}

// Extract candidate item arrays from structured responses used by newer client-rendered pages.
// Only recognize item data with a name and a positive value, not unrelated JSON objects.
function normalizeNestedItem(raw) {
  if (!raw || typeof raw !== "object" || Array.isArray(raw)) return raw;
  const v = raw.values || raw.valuations;
  if (!v || typeof v !== "object" || Array.isArray(v)) return raw;

  const merged = { ...raw };
  for (const [age, prefix] of [["default", "rvalue"], ["regular", "rvalue"], ["neon", "nvalue"], ["mega", "mvalue"]]) {
    const values = v[age];
    if (!values || typeof values !== "object") continue;
    if (merged[prefix] === undefined) merged[prefix] = values.base ?? values.fly_ride ?? values.fr;
    for (const [suffix, keys] of [
      ["nopotion", ["nopotion", "np", "noPotion"]],
      ["fly", ["fly", "f"]],
      ["ride", ["ride", "r"]],
      ["fly ride", ["fly_ride", "fr", "flyRide"]]
    ]) {
      const value = keys.map(key => values[key]).find(value => toNumber(value) > 0);
      if (value !== undefined && merged[`${prefix} - ${suffix}`] === undefined) {
        merged[`${prefix} - ${suffix}`] = value;
      }
    }
  }
  return merged;
}

function extractStructuredItemArrays(text) {
  const parsed = tryJsonParse(String(text || "").trim());
  if (!parsed || typeof parsed !== "object") return [];
  const arrays = [];
  const seen = new WeakSet();
  let visited = 0;
  function visit(value, depth) {
    if (!value || typeof value !== "object" || depth > 16 || visited++ > 100000) return;
    if (seen.has(value)) return;
    seen.add(value);
    if (Array.isArray(value)) {
      const candidates = value.map(normalizeNestedItem).filter(value => convertElvebreddItem(value));
      if (candidates.length) arrays.push(candidates);
      // Walk only a few non-items to find nested arrays, not every pet value structure.
      if (candidates.length === 0) for (const entry of value) visit(entry, depth + 1);
      return;
    }
    const direct = normalizeNestedItem(value);
    if (convertElvebreddItem(direct)) {
      arrays.push([direct]);
      return;
    }
    for (const child of Object.values(value)) visit(child, depth + 1);
  }
  visit(parsed, 0);
  return arrays;
}

function cleanMergedNotes(item) {
  if (!item || !item.valueMeta || !Array.isArray(item.valueMeta.notes)) return;

  const notes = Array.from(new Set(item.valueMeta.notes));

  item.valueMeta.notes = notes.filter(note => {
    if ((item.NP || 0) > 0 && String(note).startsWith("NP was not exposed by Elvebredd")) {
      return false;
    }
    return true;
  });
}

function extractElvebreddItems(html) {
  const arrays = [];

  arrays.push(...extractStructuredItemArrays(html));

  arrays.push(...extractInitialPetsArraysFromText(html));

  const strings = collectStringsFromNextFlight(html);
  for (const str of strings) {
    arrays.push(...extractInitialPetsArraysFromText(str));
    arrays.push(...extractStructuredItemArrays(str));
  }

  const map = new Map();

  for (const arr of arrays) {
    for (const raw of arr) {
      const converted = convertElvebreddItem(raw);
      if (!converted) continue;

      const existing = map.get(converted.key);

      if (!existing) {
        map.set(converted.key, converted.item);
      } else {
        for (const variant of VARIANTS) {
          if ((existing[variant] || 0) <= 0 && (converted.item[variant] || 0) > 0) {
            existing[variant] = converted.item[variant];
            existing.valueMeta.source[variant] = converted.item.valueMeta.source[variant];
            existing.valueMeta.confidence[variant] = converted.item.valueMeta.confidence[variant];
            existing.valueMeta.originalRaw[variant] = converted.item.valueMeta.originalRaw[variant];
          }
        }

        existing.aliases = Array.from(new Set([...(existing.aliases || []), ...(converted.item.aliases || [])]));
        existing.valueMeta.notes = Array.from(new Set([...(existing.valueMeta.notes || []), ...(converted.item.valueMeta.notes || [])]));
        cleanMergedNotes(existing);
      }
    }
  }

  for (const item of map.values()) cleanMergedNotes(item);

  return map;
}

async function fetchPage(url) {
  const response = await fetch(url, {
    headers: {
      "User-Agent": "Mozilla/5.0 (compatible; XyneriaElvebreddUpdater/1.0; +https://github.com/)",
      "Accept": "text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8",
      "Accept-Language": "en-US,en;q=0.9",
      "Cache-Control": "no-cache"
    },
    redirect: "follow"
  });

  if (!response.ok) {
    throw new Error(`Failed to fetch ${url}: HTTP ${response.status} ${response.statusText}`);
  }

  return await response.text();
}

// Client-side fallback and safe network diagnostics for changes in Elvebredd's data loading.
// Diagnostics intentionally omit request bodies, cookies, authorization headers and query strings.
function safeResourceLabel(url) {
  try {
    const parsed = new URL(url);
    const segments = parsed.pathname.split("/").map(segment => {
      if (segment.length > 28 || /[a-f0-9]{16,}/i.test(segment) || /@/.test(segment)) return "[redacted]";
      return segment;
    });
    return `${parsed.hostname}${segments.join("/")}`.slice(0, 180);
  } catch (_) {
    return "[unavailable]";
  }
}

function summarizeJsonShape(text) {
  if (!text || text.length > 8 * 1024 * 1024) return null;
  try {
    const obj = JSON.parse(text);
    function shape(value) {
      if (Array.isArray(value)) {
        return { type: "array", length: value.length,
          firstKeys: value[0] && typeof value[0] === "object"
            ? Object.keys(value[0]).slice(0, 18) : [] };
      }
      if (value && typeof value === "object") {
        return { type: "object", keys: Object.keys(value).slice(0, 22),
          children: Object.fromEntries(Object.entries(value).slice(0, 12)
            .filter(([, child]) => child && typeof child === "object")
            .map(([key, child]) => [key, Array.isArray(child)
              ? { type: "array", length: child.length, firstKeys: child[0] && typeof child[0] === "object" ? Object.keys(child[0]).slice(0, 14) : [] }
              : { type: "object", keys: Object.keys(child).slice(0, 14) }])) };
      }
      return { type: typeof value };
    }
    return shape(obj);
  } catch (_) {
    return null;
  }
}

async function fetchWithBrowser(url) {
  const { chromium } = require("playwright");
  const browser = await chromium.launch({ headless: true, args: ["--no-sandbox"] });
  const map = new Map();
  const captured = [];
  const requests = [];
  const network = [];
  const failures = [];
  const pending = [];
  const errors = [];
  const jsonShapes = [];
  const observedOrigins = new Set();
  // Save public, first-party JavaScript chunks for offline inspection when the
  // site's serialized data changes. Never save page HTML, headers, cookies,
  // request bodies, or third-party scripts.
  const publicJSChunks = [];
  const publicJSLimitBytes = 24 * 1024 * 1024;
  let publicJSBytes = 0;
  let publicJSCount = 0;
  const publicJSFolder = "elvebredd_diagnostic_chunks";
  let pageState = null;

  function ingest(text, label) {
    if (!text) return;
    if (!/(initialPets|rvalue|nvalue|mvalue|"values"|\\"values\\"|"pets"|"items")/i.test(text)) return;
    const items = extractElvebreddItems(text);
    if (captured.length < 120) captured.push({ resource: label, parsedItems: items.size });
    for (const [key, item] of items) {
      const existing = map.get(key);
      if (!existing) { map.set(key, item); continue; }
      for (const variant of VARIANTS) {
        if ((existing[variant] || 0) <= 0 && item[variant] > 0) {
          existing[variant] = item[variant];
          existing.valueMeta.source[variant] = item.valueMeta.source[variant];
          existing.valueMeta.confidence[variant] = item.valueMeta.confidence[variant];
          existing.valueMeta.originalRaw[variant] = item.valueMeta.originalRaw[variant];
        }
      }
    }
  }

  try {
    const context = await browser.newContext({
      userAgent: "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36",
      locale: "en-US"
    });
    const page = await context.newPage();
    page.on("pageerror", error => errors.push(`Page error: ${String(error.message).slice(0, 180)}`));
    page.on("request", request => {
      if (requests.length < 350) {
        requests.push({ resource: safeResourceLabel(request.url()),
          type: request.resourceType(), method: request.method() });
      }
    });
    page.on("requestfailed", request => {
      if (failures.length < 60) failures.push({
        resource: safeResourceLabel(request.url()),
        type: request.resourceType(),
        reason: String(request.failure()?.errorText || "unknown").slice(0, 120)
      });
    });
    page.on("response", response => {
      const responseUrl = response.url();
      let host = "";
      try { host = new URL(responseUrl).hostname.toLowerCase(); } catch (_) { return; }
      observedOrigins.add(host);
      const type = (response.headers()["content-type"] || "").toLowerCase();
      const resourceType = response.request().resourceType();
      const resource = safeResourceLabel(responseUrl);
      const status = response.status();
      const sizeHint = Number(response.headers()["content-length"] || 0);
      if (network.length < 350) network.push({ resource, status, type: resourceType,
        contentType: type.split(";")[0], bytesAdvertised: sizeHint || undefined });
      if (sizeHint > 8 * 1024 * 1024) return;
      const isJson = /json|ndjson/.test(type);
      const isOfficial = host === "elvebredd.com" || host.endsWith(".elvebredd.com") || host === "elvebredd.net" || host.endsWith(".elvebredd.net");
      if (!isJson && !(isOfficial && /javascript|html|text\/plain/.test(type))) return;
      pending.push((async () => {
        try {
          const body = await response.body();
          if (body.length > 8 * 1024 * 1024) return;
          const text = body.toString("utf8");
          if (isJson && jsonShapes.length < 60) {
            jsonShapes.push({ resource, status, bytes: body.length,
              shape: summarizeJsonShape(text) });
          }
          ingest(text, resource);
          if (isOfficial && resourceType === "script" && /\.js$/i.test(resource)
              && body.length > 0 && body.length < 5 * 1024 * 1024
              && publicJSCount < 40 && publicJSBytes + body.length < publicJSLimitBytes) {
            // A fresh browser context ensures these are unauthenticated public files.
            const filename = `chunk-${String(++publicJSCount).padStart(3, "0")}.js`;
            try {
              await fs.mkdir(publicJSFolder, { recursive: true });
              await fs.writeFile(`${publicJSFolder}/${filename}`, body);
              publicJSBytes += body.length;
              publicJSChunks.push({ filename, resource, bytes: body.length,
                matchesOldKeys: /initialPets|rvalue|nvalue|mvalue/i.test(text) });
            } catch (e) {
              errors.push(`Could not save public script ${filename}: ${String(e.message).slice(0, 100)}`);
            }
          }
        } catch (e) {
          errors.push(`Could not inspect ${resource}: ${String(e.message).slice(0, 100)}`);
        }
      })());
    });

    await page.goto(url, { waitUntil: "domcontentloaded", timeout: 45000 });
    await page.waitForTimeout(BROWSER_WAIT_MS);
    ingest(await page.content(), "rendered HTML");
    pageState = { title: (await page.title()).slice(0, 120),
      url: safeResourceLabel(page.url()),
      visibleText: (await page.locator("body").innerText().catch(() => "")).slice(0, 380) };
    if (map.size < MIN_ITEMS) {
      for (const selector of [
        'button[aria-label*="Add" i]',
        'button:has(img[alt*="Add Pets" i])',
        '[role="button"]:has(img[alt*="Add Pets" i])'
      ]) {
        try {
          const button = page.locator(selector).first();
          if (await button.count() && await button.isVisible()) {
            await button.click({ timeout: 2500 });
            await page.waitForTimeout(4000);
            ingest(await page.content(), "opened item chooser");
            pageState.chooserVisibleText = (await page.locator("body").innerText().catch(() => "")).slice(0, 380);
            break;
          }
        } catch (e) { errors.push(`Picker interaction: ${String(e.message).slice(0, 120)}`); }
      }
    }
    await Promise.allSettled(pending);
    await context.close();
  } catch (error) {
    errors.push(`Browser: ${String(error.message).slice(0, 250)}`);
  } finally {
    await browser.close();
  }

  const diagnostic = {
    checkedAt: new Date().toISOString(),
    summary: { requests: requests.length, responses: network.length,
      inspectedResponses: captured.length, extractedItems: map.size,
      hosts: Array.from(observedOrigins).sort() },
    pageState,
    // Put likely first-party data calls ahead of ads, analytics, fonts and other assets.
    network: network.sort((a, b) => {
      const rank = x => (x.type === "fetch" || x.type === "xhr" ? 0 : x.status >= 400 ? 1 : x.type === "document" ? 2 : 3);
      return rank(a) - rank(b);
    }).slice(0, 220),
    requestFailures: failures,
    jsonResponseShapes: jsonShapes,
    publicJSChunks,
    parsedCandidates: captured,
    errors: errors.slice(0, 30)
  };
  try { await fs.writeFile(DIAGNOSTICS_FILE, JSON.stringify(diagnostic, null, 2) + "\n"); }
  catch (error) { console.warn(`Could not write diagnostics: ${error.message}`); }
  console.log(`Browser inspected ${network.length} responses on ${observedOrigins.size} hosts; found ${map.size} items.`);
  return map;
}

function categoryCounts(items) {
  const counts = {};

  for (const item of items) {
    const key = item.category || "unknown";
    counts[key] = (counts[key] || 0) + 1;
  }

  return Object.fromEntries(Object.entries(counts).sort(([a], [b]) => a.localeCompare(b)));
}

function countPositiveVariantCells(items) {
  let count = 0;

  for (const item of Object.values(items || {})) {
    for (const variant of VARIANTS) {
      if (toNumber(item && item[variant]) > 0) count++;
    }
  }

  return count;
}

function countNormalizedNonPetItems(items) {
  let count = 0;

  for (const item of Object.values(items || {})) {
    const notes = item && item.valueMeta && Array.isArray(item.valueMeta.notes)
      ? item.valueMeta.notes
      : [];

    if (notes.some(note => String(note).startsWith("NP copied from Elvebredd's regular rvalue for confirmed non-pet"))) {
      count++;
    }
  }

  return count;
}

async function readPreviousOutput() {
  try {
    const text = await fs.readFile(OUT_FILE, "utf8");
    if (!text.trim()) {
      throw new Error(`${OUT_FILE} exists but is empty.`);
    }

    const parsed = JSON.parse(text);
    if (!parsed || typeof parsed !== "object" || !parsed.items || typeof parsed.items !== "object") {
      throw new Error(`${OUT_FILE} exists but does not contain a valid items object.`);
    }

    return parsed;
  } catch (error) {
    if (error && error.code === "ENOENT") return null;
    throw new Error(`Refusing to replace the existing database because it could not be read safely: ${error.message}`);
  }
}

function validateRatio(name, value) {
  if (!Number.isFinite(value) || value <= 0 || value > 1) {
    throw new Error(`${name} must be a number greater than 0 and at most 1. Received: ${value}`);
  }
}

function validateCandidate(output, previousOutput) {
  if (!Number.isFinite(MIN_ITEMS) || MIN_ITEMS < 1) {
    throw new Error(`MIN_ITEMS must be a positive number. Received: ${MIN_ITEMS}`);
  }

  validateRatio("MIN_PREVIOUS_ITEM_RATIO", MIN_PREVIOUS_ITEM_RATIO);
  validateRatio("MIN_PREVIOUS_OVERLAP_RATIO", MIN_PREVIOUS_OVERLAP_RATIO);
  validateRatio("MIN_PREVIOUS_NONZERO_RATIO", MIN_PREVIOUS_NONZERO_RATIO);

  const items = output.items || {};
  const keys = Object.keys(items);

  if (keys.length < MIN_ITEMS) {
    throw new Error(`Only extracted ${keys.length} item(s). Expected at least ${MIN_ITEMS}. Elvebredd page format may have changed.`);
  }

  const shadow = items["shadow dragon"];
  if (!shadow) {
    throw new Error("Safety check failed: Shadow Dragon is missing from the generated database.");
  }

  const shadowHasRegularValue = ["NP", "F", "R", "FR"].some(variant => toNumber(shadow[variant]) > 0);
  if (!shadowHasRegularValue) {
    throw new Error("Safety check failed: Shadow Dragon has no positive regular value.");
  }

  for (const key of KNOWN_NON_PET_SENTINELS) {
    const item = items[key];
    if (!item) continue;

    if (toNumber(item.FR) > 0 && toNumber(item.NP) <= 0) {
      throw new Error(`Safety check failed: known non-pet '${item.displayName || key}' still has FR but no NP value.`);
    }
  }

  if (!previousOutput || !previousOutput.items || typeof previousOutput.items !== "object") {
    return;
  }

  const previousItems = previousOutput.items;
  const previousKeys = Object.keys(previousItems);
  const previousCount = previousKeys.length;
  const newCount = keys.length;

  if (previousCount > 0) {
    const itemRatio = newCount / previousCount;
    if (itemRatio < MIN_PREVIOUS_ITEM_RATIO) {
      throw new Error(
        `Safety check failed: item count dropped from ${previousCount} to ${newCount} ` +
        `(${(itemRatio * 100).toFixed(2)}% of previous; minimum ${(MIN_PREVIOUS_ITEM_RATIO * 100).toFixed(2)}%).`
      );
    }

    let overlap = 0;
    for (const key of previousKeys) {
      if (Object.prototype.hasOwnProperty.call(items, key)) overlap++;
    }

    const overlapRatio = overlap / previousCount;
    if (overlapRatio < MIN_PREVIOUS_OVERLAP_RATIO) {
      throw new Error(
        `Safety check failed: only ${overlap}/${previousCount} previous item keys remain ` +
        `(${(overlapRatio * 100).toFixed(2)}%; minimum ${(MIN_PREVIOUS_OVERLAP_RATIO * 100).toFixed(2)}%).`
      );
    }
  }

  const previousPositiveCells = countPositiveVariantCells(previousItems);
  const newPositiveCells = countPositiveVariantCells(items);

  if (previousPositiveCells > 0) {
    const nonzeroRatio = newPositiveCells / previousPositiveCells;
    if (nonzeroRatio < MIN_PREVIOUS_NONZERO_RATIO) {
      throw new Error(
        `Safety check failed: positive value cells dropped from ${previousPositiveCells} to ${newPositiveCells} ` +
        `(${(nonzeroRatio * 100).toFixed(2)}% of previous; minimum ${(MIN_PREVIOUS_NONZERO_RATIO * 100).toFixed(2)}%).`
      );
    }
  }
}

async function writeAtomically(path, text) {
  const tempPath = `${path}.tmp`;

  await fs.writeFile(tempPath, text, "utf8");

  try {
    await fs.rename(tempPath, path);
  } catch (error) {
    try {
      await fs.unlink(tempPath);
    } catch (_) {

    }
    throw error;
  }
}

async function main() {
  console.log(`Fetching Elvebredd values from ${ELVEBREDD_URL}`);



  const previousOutput = await readPreviousOutput();

  let itemMap = new Map();
  try {
    const html = await fetchPage(ELVEBREDD_URL);
    itemMap = extractElvebreddItems(html);
    console.log(`Direct response: extracted ${itemMap.size} items from ${html.length} bytes of HTML.`);
  } catch (error) {
    console.warn(`Direct request failed: ${error.message}`);
  }

  const lastCount = previousOutput ? Object.keys(previousOutput.items).length : 0;
  const expectedCount = Math.max(MIN_ITEMS, Math.ceil(lastCount * MIN_PREVIOUS_ITEM_RATIO));
  if (itemMap.size < expectedCount) {
    console.warn(`Trying browser fallback; direct extraction returned ${itemMap.size} item(s), need at least ${expectedCount}.`);
    const browserItems = await fetchWithBrowser(ELVEBREDD_URL);
    if (browserItems.size > itemMap.size) itemMap = browserItems;
  }
  const sortedEntries = Array.from(itemMap.entries()).sort(([a], [b]) => a.localeCompare(b));
  const items = Object.fromEntries(sortedEntries);

  const output = {
    version: 5,
    updatedAt: new Date().toISOString(),
    source: "elvebredd-initialPets-auto-generated",
    sourceUrl: ELVEBREDD_URL,
    itemCount: sortedEntries.length,
    valueScale: "elvebredd-display-values",
    variantKeys: {
      NP: "No Potion / Normal / Default no-potion value when exposed",
      F: "Regular Fly-only value when exposed",
      R: "Regular Ride-only value when exposed",
      FR: "Regular/default Fly Ride value from rvalue",
      N: "Neon value (plain, no fly/ride)",
      NF: "Neon Fly-only value when exposed",
      NR: "Neon Ride-only value when exposed",
      NFR: "Neon Fly Ride value from bare nvalue",
      M: "Mega value (plain, no fly/ride)",
      MF: "Mega Fly-only value when exposed",
      MR: "Mega Ride-only value when exposed",
      MFR: "Mega Fly Ride value from bare mvalue"
    },
    fieldMapping: {
      NP: "rvalue - nopotion",
      F: "rvalue - fly",
      R: "rvalue - ride",
      FR: "rvalue",
      N: "nvalue - nopotion",
      NF: "nvalue - fly",
      NR: "nvalue - ride",
      NFR: "nvalue (bare) / nvalue - fly ride / nvalue - fr",
      M: "mvalue - nopotion",
      MF: "mvalue - fly",
      MR: "mvalue - ride",
      MFR: "mvalue (bare) / mvalue - fly ride / mvalue - fr"
    },
    categoryItemCounts: categoryCounts(Object.values(items)),
    items
  };

  validateCandidate(output, previousOutput);

  const serialized = JSON.stringify(output, null, 2) + "\n";
  await writeAtomically(OUT_FILE, serialized);

  const normalizedNonPets = countNormalizedNonPetItems(items);

  console.log(`Wrote ${OUT_FILE} with ${sortedEntries.length} items.`);
  console.log(`Safely copied regular rvalue into NP for ${normalizedNonPets} confirmed non-pet item(s).`);

  const shadow = items["shadow dragon"];
  console.log(
    "Shadow Dragon check:",
    JSON.stringify({
      NP: shadow.NP,
      F: shadow.F,
      R: shadow.R,
      FR: shadow.FR,
      N: shadow.N,
      NFR: shadow.NFR,
      M: shadow.M,
      MFR: shadow.MFR
    })
  );

  for (const key of KNOWN_NON_PET_SENTINELS) {
    const item = items[key];
    if (!item) continue;

    console.log(
      `Known non-pet check (${item.displayName || key}):`,
      JSON.stringify({ NP: item.NP, FR: item.FR })
    );
  }
}

if (require.main === module) {
  main().catch(error => {
    console.error(error);
    process.exit(1);
  });
}

module.exports = { extractElvebreddItems, extractStructuredItemArrays, validateCandidate };

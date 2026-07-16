const fs = require("fs/promises");

const targets = {
  calculatorRsc: "https://amvgg.com/calculator?_rsc=19zvn",
  calculatorPage: "https://amvgg.com/calculator",
  petsPage: "https://amvgg.com/values/pets"
};

function extractInterestingLines(text) {
  const cleaned = String(text || "")
    .replace(/\\n/g, "\n")
    .replace(/\\u0026/g, "&")
    .replace(/\\u003c/g, "<")
    .replace(/\\u003e/g, ">")
    .replace(/[{}\[\],]/g, "\n");

  return cleaned
    .split(/\r?\n/)
    .map(line => line.trim())
    .filter(line => {
      if (line.length < 3 || line.length > 300) return false;

      return /shadow|bat dragon|frost|giraffe|owl|parrot|crow|evil|regular|neon|mega|fly|ride|fr|nfr|mfr|value|demand/i.test(line);
    })
    .slice(0, 500);
}

async function fetchTarget(name, url) {
  console.log(`Fetching ${name}: ${url}`);

  const response = await fetch(url, {
    headers: {
      "User-Agent": "xyneria-values-bridge/1.0",
      "Accept": "text/html,application/json,text/plain,*/*"
    }
  });

  const text = await response.text();

  return {
    name,
    url,
    ok: response.ok,
    status: response.status,
    contentType: response.headers.get("content-type"),
    length: text.length,
    preview: text.slice(0, 12000),
    interestingLines: extractInterestingLines(text)
  };
}

async function main() {
  const results = {};

  for (const [name, url] of Object.entries(targets)) {
    try {
      results[name] = await fetchTarget(name, url);
    } catch (error) {
      results[name] = {
        name,
        url,
        ok: false,
        error: String(error && error.stack ? error.stack : error)
      };
    }
  }

  const output = {
    generatedAt: new Date().toISOString(),
    note: "This file is only for reverse engineering AMVGG data. It is not the final values database.",
    results
  };

  await fs.mkdir("debug", { recursive: true });
  await fs.writeFile("debug/amvgg_probe.json", JSON.stringify(output, null, 2));

  console.log("Wrote debug/amvgg_probe.json");
}

main().catch(error => {
  console.error(error);
  process.exit(1);
});

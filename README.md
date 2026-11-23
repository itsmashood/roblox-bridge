# Roblox Bridge: AMVerse values updater

This repository keeps the original Roblox `.lua` scripts and the existing `values_elvebredd` JSON schema. The GitHub Actions updater now attempts to collect publicly displayed **Elvebredd** values from [AMVerse](https://amverse.co/values) **without an API key**.

**Status: source parser locally tested; a complete live GitHub Actions scrape has NOT yet been verified.** The script fails safely when it cannot collect enough items. No scraping workaround or CAPTCHA/403 bypass is included.

## GitHub Desktop installation

1. Extract this archive.
2. Open your cloned `roblox-bridge` repository folder in File Explorer.
3. Copy the **contents** of the extracted `roblox-bridge-main` folder into your clone, replacing existing files. **Do not copy the outer folder into the clone as a subfolder.**
4. In GitHub Desktop, review the changed files, commit, then click **Push origin**.
5. In GitHub → Actions, select **Update Roblox Values (AMVerse)** and choose **Run workflow** on `main`. **Start a fresh run, not “Re-run jobs” on an old one.**
6. On a failure, open the run's **Summary** and download `amverse-fetch-diagnostics`. The existing database remains unchanged.

## What gets updated

- Pets: `NP` ← AMVerse's Elvebredd **Regular** value; `N` ← **Neon**; `M` ← **Mega**.
- Non-pets: `NP` ← **Regular**; update legacy `FR` only if it previously matched `NP`.
- `F`, `R`, `FR` (for pets), `NF`, `NR`, `NFR`, `MF`, `MR`, `MFR` are **preserved**, not guessed. AMVerse's publicly visible values table does not supply those potion variants.
- Names are matched to existing database records. Unknown item names are reported but not inserted automatically without trustworthy IDs/category/variant metadata.
- Database writes are atomic and made only after item-count and coverage checks; partial scrapes will **fail and preserve the current DB**.

## Requirements and permission

AMVerse's Terms of Service require prior written permission for scraping, crawling or systematic extraction and separately restrict redistribution and commercial use. Permission to use an API key is not necessarily permission to scrape public pages. **Confirm the specific scraping and redistribution permission with the owner before running the automated workflow.** Do not commit an API key to GitHub. Ask the owner to rotate any key shown in screenshots.

## Testing

```bash
node --test test_updater.js
npm install --no-save --no-package-lock playwright
npx playwright install chromium
DRY_RUN=true node update_elvebredd_values.js
```

Run with `DRY_RUN=true` to test extraction without modifying the database. Environment controls: `MIN_MATCHED_ITEMS` (default 350), `MIN_PET_COVERAGE` (0.45), `MAX_SEARCH_QUERIES` (3800), `MAX_FETCH_MINUTES` (32). Do not lower safety thresholds merely to force a successful result.

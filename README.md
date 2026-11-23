# Roblox Bridge: Elvebredd values updater

This project maintains the original `values_elvebredd` database used by Roblox Bridge / Xyneria. The updater has been rebuilt using the value format and extraction approach from **[xjacksssss/elve-values-public](https://github.com/xjacksssss/elve-values-public)**, shared by its author for this project.

## Current update method (recommended)

- GitHub Actions reads `data/elve-values.json` published in **xjacksssss/elve-values-public** over HTTPS. **No AMVerse API key, Chrome, or Playwright is required.**
- The owner's dataset carries the current Elvebredd item IDs and **all 12 pet-value variants**, so the updater matches **IDs** rather than guessing from names.
- The repository's existing JSON format and Lua scripts are preserved.
- The workflow runs at **01:35 and 13:35 UTC**, shortly after the owner's scheduled 00:00/12:00 UTC snapshots. It can also be run manually.
- An update is refused if the source is stale, partial, has duplicate IDs, or fails the coverage checks. The previous `values_elvebredd` remains intact.
- New pets with a complete variant set can be inserted automatically; new non-pet items without a trustworthy category are reported but not added. Existing non-pet values use the source's regular `rvalue`, preserving the previous JSON layout.
- On a successful change, **only `values_elvebredd` is committed** by the workflow.

## Install with GitHub Desktop

1. Back up your current `roblox-bridge` folder (optional but recommended).
2. Download the complete ZIP, extract it, and open the `roblox-bridge-main` directory inside the archive.
3. Copy everything **inside** that folder into the local `roblox-bridge` clone, replacing existing files. Do **not** copy the `roblox-bridge-main` folder itself inside the repository.
4. Review the changes in GitHub Desktop, commit, then **Push origin**.
5. On GitHub, open **Actions → Update Elvebredd Values (Owner Snapshot)**, select `main`, and **Run workflow**. Start a **new** run rather than rerunning an old attempt.
6. If it fails, open the run's **Summary** and download the `elve-update-diagnostics` artifact. The existing DB is not overwritten on a failure.

## Optional direct scraper

The owner-shared Next.js scraper has been included at `scripts/scrape-elve.js`. The workflow **Manual Direct Elvebredd Scrape (Optional)** starts FlareSolverr, fetches `https://elvebredd.com/calculator`, extracts the Next.js flight payload, and then imports it into the *same* `values_elvebredd` schema. This workflow is **manual only**: the recommended scheduled workflow consumes the already-published snapshot and avoids extra traffic to the original site.

A direct scrape is not guaranteed to succeed; Cloudflare protection and site layouts can change. Do not repeatedly run the direct workflow if the site blocks it.

## Files

| Path | Purpose |
|---|---|
| `update_elvebredd_values.js` | Safe JSON import, ID matching, 12-variant conversion, data checks |
| `scripts/scrape-elve.js` | Owner-shared direct parser (optional) |
| `scripts/verify-db.js` | Validate complete output schema |
| `test_updater.js` | Local tests for field mapping and database safety |
| `.github/workflows/update-elvebredd-values.yml` | Scheduled snapshot-import workflow |
| `.github/workflows/direct-elve-scrape.yml` | Optional manual direct scrape workflow |
| `values_elvebredd` | Existing JSON database, initially kept unchanged |
| `spray.lua` | Existing Lua script, kept unchanged |
| `LICENSE` and `legal.md` | Existing repository usage restrictions |
| `NOTICE.txt` | Attribution for the owner's shared scraper |

## Optional local commands

```sh
node --test test_updater.js
node scripts/verify-db.js
DRY_RUN=true node update_elvebredd_values.js
```

To import a snapshot already saved to your computer instead of making a request:

```sh
INPUT_FILE=data/elve-values.json DRY_RUN=true node update_elvebredd_values.js
```

## Compatibility and important limitations

- Database `version`, item keys, metadata, existing aliases, and all 12 numeric value fields are preserved. The updater modifies values only when they are supplied and validated.
- Current DB contains **3,475** entries. The owner's snapshot checked on 23 November 2026 contained **3,517** rows and matched **3,473/3,475** existing records by ID (the two unmatched entries were blank-name placeholders `nan` and `None`). The owner's live source may change after that check.
- Existing items are not deleted when absent from a new snapshot. Invalid item names, unclassifiable new non-pets, and extreme individual price outliers are not blindly inserted.
- **The local unit tests do not prove that a future live fetch will succeed.** A new Actions run is the final end-to-end check.
- The owner shared their scraper for reuse; see `NOTICE.txt`. This doesn't transfer rights to Elvebredd or AMVerse brands, website content, or other third-party assets.

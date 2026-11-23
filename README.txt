Roblox Bridge — Elvebredd values (owner snapshot)

Follow README.md for full instructions.

Install: copy everything inside this ZIP's roblox-bridge-main folder into your
existing GitHub Desktop clone and replace existing files. Commit and push.

Then go to GitHub Actions > Update Elvebredd Values (Owner Snapshot) >
Run workflow > main. This scheduled job reads the public JSON snapshot from
xjacksssss/elve-values-public and preserves all 12 variants.

An optional manual workflow, Manual Direct Elvebredd Scrape (Optional), uses
the extraction code shared by xjacksssss. This is not needed for daily updates.

Any failure leaves the last good database unchanged; diagnostics are uploaded.

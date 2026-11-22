Elvebredd public JavaScript diagnostics (temporary inspection update)

The 22 November network diagnostics show that Chromium loads the calculator (200),
but the old initialPets / nested-JSON parser finds zero items.

This update saves only public first-party JavaScript files loaded into a fresh,
signed-out browser, along with the existing JSON diagnostics. It does not save
cookies, request bodies, headers, third-party scripts, or page HTML.

In GitHub repository itsmashood/roblox-bridge, on the main branch:
1. Replace update_elvebredd_values.js in the repository root.
2. Replace .github/workflows/update-elvebredd-values.yml.
3. Commit BOTH files to main.
4. Actions > Update Elvebredd Values > Run workflow > main > Run workflow.
   Do not use Re-run jobs on an older failed workflow.
5. Download the elvebredd-fetch-diagnostics artifact from the NEW run.

Send back the ZIP from that run so the public scripts can be inspected and
the extractor updated to the correct live data representation.

No change is made to the values_elvebredd output on an extraction failure.

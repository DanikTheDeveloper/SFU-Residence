# 19 — Photo folder contract and legacy transition

The **NEW OUTER** root only is authoritative. Old nested Markdown/docs/AGENTS are intentionally ignored, but old nested **game code/assets** are copied safely per migration guide.

Correct new photo structure: see `reference_photos/README.md`. Shared East and West are together in `East_West_Towers/`, and `Barbara_Pauline_Shadbolt/` combines all three North Towers into ONE directory. `Townhouses/` is one group. Dining Commons, Courtyard, Shell and Hamilton each have own folders. McTaggart-Cowan is kept separate to prevent a visually incorrect townhouse model. Context remains in `Terrain_and_Stairs/`, `Parking_and_Paths/`.

The optional `scripts/relocate_legacy_photos.py` is **copy-only**: dry run by default; `--apply` copies old flat category photographs to their new family folder without deleting sources; conflicts cause refusal. East/West originals are labeled via filename during relocation; if existing filenames ambiguous, inspector must manually determine identity. If old and new already exist, no overwrites; log and resolve by hand. Empty legacy directories might remain; ignore them rather than following their layout instructions. The migration script never accesses nested project's historic metadata.

Source photos of one North Tower may inform the *shared* facade architecture of another, but not its unique entry point or scale without per-instance evidence. Shared East/West photos must still be tagged to the actual building photographed. Record `building_id` + `family_id` where possible in `data/photo_manifest.csv`.

Legacy migration supports BOTH the earlier `North_Towers/Barbara_Rae_House`, `North_Towers/Pauline_Jewett_House`, `North_Towers/Shadbolt_House` paths and flat `North_Towers_Barbara_Rae`, etc. Migrate photos into `Barbara_Pauline_Shadbolt/`, prefixing the actual source building name. Dry-run first; originals are never removed. Do not copy new North photo files back into obsolete child folders.

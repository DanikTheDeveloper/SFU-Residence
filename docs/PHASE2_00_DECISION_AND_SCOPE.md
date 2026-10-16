# 00 — Strategy and scope: preserve, correct, pilot, repeat

## Diagnosis from user testing (observations, not inferred facts)
- Baseline geography, buildings' footprint placement, overall topology: **accepted**.
- Buildings are recognizable in silhouette but presently too box-like; many doors and color combinations are wrong.
- Flat ground contradicts significant persistent hillside grade between residence townhouse area and dining area, and throughout portions of precinct.
- Roads misclassified: at least one real parking area is represented as roads; most pedestrian circulation is plain concrete with no painted traffic lines. Distinguish perimeter vehicle road from concrete pedestrian routes and parking.
- Camera is wrong type; game must now be 100% first-person.
- Existing East/West Towers are relatively new and should not inherit appearance from older historic imagery; current photos take priority.

## Recommended production pipeline (not one-shot AI image generation)
1. Preserve XZ footprints, names, stable ID and base script references; branch/snapshot baseline.
2. Source a terrain model from official Burnaby contours/DEM, or use editable confidence-labelled anchors; make walkable ramps and terrain-following paving.
3. Correct circulation *semantics* (vehicle road / concrete paths / plaza / parking lot), then rebuild their surfaces/elevations and collision.
4. Set strict first-person camera; verify at human eye level. Architectural errors invisible from top-down become obvious at pedestrian height.
5. Pick ONE photographed **architectural family representative**, trace **architectural structure and measurements**, not copyright-restricted texture photographs: massing, material palette, level hierarchy, repetitive facade bay modules, window openings/frames, entrance/canopy and base.
6. Use same reviewed facade module library for subsequent family-based passes (plus per-instance entry/grade checks); do not copy stylistic details between unlike structures.
7. Re-run named vantage points and record verified inaccuracies. Stay playable at each checkpoint.

## Out of scope in this Phase 2 development scope (across usage reset windows)
All-building detailed photo-matching, interior access, photogrammetry capture, generated fake doors or decoration, NPCs, sexual/romance mechanics, dialogue, AI network/API UI. Keep the future project interface but not its implementation.

## Quality bar
One faithfully photo-matched architectural family, with real per-instance differences, is better than 19 colorful generic boxes. Photorealism depends on high-quality geometry, reliable photos, textures with permission, lighting and repeated reference checking; high polygon count alone cannot fix inaccurate facades.

## Building choice
Default pilot **the shared East/West Tower family**, using a well photographed East or West as representative; reuse the master for its matching partner only with verified common architecture and parameterized 7/8 storeys and unique doors. If this family lacks photos, select the best photographed family instead and document why. Do not spend another full pilot on its sibling. Other unmatched families stay at existing massing in this session.

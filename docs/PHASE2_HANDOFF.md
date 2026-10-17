# Phase 2 handoff — 2026-10-17

## Resume here
Canonical project: outer game/. Read git status and this handoff; do not recopy Phase 1 or redo reviewed photos. This iteration's verified commits: e642e99 Courtyard massing and 97c24d2 pavement. McTaggart details and pavement guard are the final verified checkpoint. Check latest git log for its commit.

Current final commands/logs: /tmp/photo-final-smoke.log and /tmp/photo-final-capture.log. Final capture completed; both final eye-level views inspected. Preservation/family/photo-index validators pass. Last full geometry regression: /tmp/courtyard-grade-verification.log, 180 physics checks / 333 route checkpoints / 376 terrain-ray parity checks. Later changes only affect rendering, not collisions. No unfinished geometry experiment is intentionally left in the scene.

Run `bash scripts/run_game.sh`. Existing interactive Godot process was left untouched; restart to see current work. Captures use the GTX1650 D3D12 OpenGL Compatibility device, with concurrent game load. No isolated FPS claim. Do not install dependencies or change renderer/engine.

## Completed this window
Courtyard now has highrise/lowrise/atrium height zones instead of an eleven-storey solid extrusion everywhere. Original footprint union preserved exactly; highest roof unchanged. East-end glazing, closed atrium entry and grade-following stems improve the handpicked-photo match. Three additional roof-ray checks validate configured zone heights, not surveyed dimensions. See PHASE2_COURTYARD_PHOTO_REVIEW.md.

Pavement has original mipmapped aggregate textures, grey townhouse paths and local warm/grey East pavers with pale borders. First close-up exposed z-fighting; shared world UVs and small ordered visual offsets fixed it. Final nearest-entrance guard excludes McTaggart from East's material area. Original centrelines, widths, parking polygons and terrain collision are intact. Extents, joint spacing/orientation and paver dimensions are estimates. See PHASE2_PAVEMENT_FINISHES.md.

McTaggart detail pass: bronze window aprons, thinner vertical envelope seams, pale closed entrance divisions and two canopy-light housings with subdued emissive faces, no realtime lights. Navigation label reduced. Official SFU level-2 plan reviewed; three stepped wings confirmed, exact pictured ground entrance unresolved. Existing mapped door and four-level height retained. See PHASE2_MCTAGGART_PHOTO_REVIEW.md.

All 46 photo files have individual review records; data/photo_review_coverage.json hashes them. Run `python3 scripts/validate_photo_reference_index.py` on resume to locate new or changed files. Photos remain reference-only; no third-party photo pixels are shipped as textures. PWL East identification is verified by signs; no supplied photo conclusively identifies West. One Hamilton image is mismatched. Duplicate views and design renders are marked in indexes.

## Critical interpretations to preserve
North gallery runs longitudinally under the long courtyard-facing wing, connecting PJH/BRH/SBH. User confirmed this. Never restore transverse tunnels. Parking-stair prototype archived at /home/danik/Backups/SFU-North-stair-prototype-20261016 requires location audit before reuse. Upper-floor plans do not prove ground passage/stair layouts.

Approved East/West master, FacadeKit, townhouse master, terrain smoothing/pads, first-person mouse fix and original 19-building coordinates must remain intact. Hamilton portico support spacing was collision-tested; don't narrow it. Shell has four total levels officially but three visible at photographed entry. Dining northern finish partly relies on design/construction references, not current as-built confirmation. Courtyard SFU eleven floors vs RJC twelve storeys is a documented conflict, not permission to alter global height.

## Next useful increments
1. Localize North parking stairs relative to corrected gallery using photos/site evidence; test traversable connections before accepting geometry.
2. Resolve McTaggart entrance connector location and exposed levels. Photos show a recessed/faceted connector between wings, not the current flat frontage. Do not hide this discrepancy with more decorative detail.
3. Courtyard: photo-supported roof terrace/small penthouse, forecourt paving and planting boundaries; avoid speculative placement. Current east capture (353,17) is inside boundary; old (361,17) was outside.
4. Shell entrance/exposed-level reconciliation, then current Dining as-built references and bounded landscape improvements. Finish and verify each increment before another.

Additional notes: user source files, FILE_MANIFEST.json, historic_maps and untracked reference metadata are preserved. Original nested game is retained; obsolete nested Markdown cleanup already completed outside the workspace. This window's 16 known one-off patch helpers and pre-consolidation status/handoff were backed up to /home/danik/Backups/SFU-photo-iteration-20261017. Earlier helper backup is /home/danik/Backups/SFU-iteration-helper-scripts-20261017.

Host reported 91% of the five-hour usage window consumed while finishing verification. Stop after saving current checkpoint; next user-started iteration resumes here. Five hours is a usage reset, not a development deadline. No automatic reset wait or resume is scheduled.

## New landscape iteration: vehicles
Replaced box cars with four CC0 Cosmo GLB models (coupe, mobil, jeep, van). Imported meshes are normalized to existing stalls and instanced by variant. Existing collision/route clearance preserved. License included in game/assets/vehicles/cosmo. Smoke /tmp/vehicles-smoke.log passed; GTX1650 --capture-parking completed and three views reviewed. Validators pass. Capture identified pale road-edge overlays inside parking; these now suppress within mapped parking and divider spacing was corrected. Final combined parking regression will verify those changes.

Online parking research found missing Residence Main Lot, OSM way32528160. Current way is Phase3 construction; version8 retains pre-construction parking tags. Awaiting/assuming full pre-construction lot per current request, not current construction. Official SFU rear-tower photograph confirms cars and deciduous planted edge; exact stalls/drainage/finished level unresolved. Next: add reversible mapped lot and local level grading, preserving all foundations.

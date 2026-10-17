# Phase 2 status — 2026-10-17

## Current iteration
- Reviewed/indexed all 46 supplied photo files. Per-building PHOTO_REVIEW.json records distinguish duplicates, renderings, uncertain identities and completed photographs. `python3 scripts/validate_photo_reference_index.py` reports new or changed photos without equating indexing with architectural accuracy.
- Courtyard Residence: corrected the erroneous uniform eleven-storey extrusion into highrise, three-storey lowrise and lower atrium. Original full footprint and tallest roof retained. Added glazed east end, photo-informed closed atrium entrance and grade-following foundations. Commit e642e99. Lowrise/atrium heights are estimates; SFU eleven-floor vs RJC twelve-storey terminology remains unresolved.
- Pavement: original textured concrete, fine grey townhouse paths and mixed grey/tan East entrance pavers. Shared UV origins and ordered visual offsets fix overlap flicker. All road/path/parking geometry and physics retained. Commit 97c24d2, followed by a nearest-entrance guard preventing East's finish leaking onto McTaggart's approach. Final segment counts are 196 concrete, 111 townhouse-grey, 1 East-paver and 90 vehicle.
- McTaggart: charcoal brick with pale narrow mortar retained; added bronze window aprons, vertical envelope seams, pale entrance/sidelight divisions and two canopy-light housings. Batched geometry, no additional realtime lights. Reduced oversized navigation lettering. Exact connector/entrance massing remains unresolved; this is a detail pass, not a completed reconstruction.

## Verification
Courtyard geometry: 180 physics checks, 333 pedestrian route checkpoints and 376 terrain-ray parity checks passed in /tmp/courtyard-grade-verification.log. Subsequent pavement/material/detail changes do not change physics. Smoke and GTX1650 Compatibility visual capture performed for each increment. Final smoke: /tmp/photo-final-smoke.log. Final capture: /tmp/photo-final-capture.log (completed; both final eye-level views inspected). Preservation/family validators pass: unchanged coordinates, terrain/pads, approved East/West master and facade kit, eight families / ten named instances / zero errors. Photo inventory: 46/46, zero findings.

Screenshots and reports are in game/docs. A separate user game remained running; capture FPS shares GPU load and is not an isolated performance benchmark. Restart the game to load changes.

## Preserved / earlier milestones
Godot 4.7.2 Standard, GDScript, Compatibility/OpenGL, Debian WSL2, GTX1650, strict first person. User-confirmed mouse fix unchanged. Approved East/West and townhouse architecture unchanged. No interiors, NPCs or API integration.

North Towers retain the corrected longitudinal courtyard-facing gallery through all three houses. Hamilton has its distinct grey exterior and north portico. Shell has concrete/brown panels, fins and terrain-contact stems. Dining distinguishes the original concrete wing and newer northern extension. See individual review documents for limitations rather than treating all buildings as photo-exact.

## Remaining priorities
North parking-stair localization; McTaggart connector and three-visible/four-total level reconciliation; Shell photo-door location and exposed levels; Courtyard roof terrace/penthouse, forecourt and planted-bed geometry; current as-built Dining finish. Landscape planting, curb/drain positions and actual pavement boundaries remain estimated. Preserve verified paths and building coordinates until new evidence supports changes.

Host reported 91% usage consumed during final verification. Finish current checkpoint and stop; resume from handoff next window.

## New landscape iteration: vehicles
Replaced box cars with four CC0 Cosmo GLB models (coupe, mobil, jeep, van). Imported meshes are normalized to existing stalls and instanced by variant. Existing collision/route clearance preserved. License included in game/assets/vehicles/cosmo. Smoke /tmp/vehicles-smoke.log passed; GTX1650 --capture-parking completed and three views reviewed. Validators pass. Capture identified pale road-edge overlays inside parking; these now suppress within mapped parking and divider spacing was corrected. Final combined parking regression will verify those changes.

Online parking research found missing Residence Main Lot, OSM way32528160. Current way is Phase3 construction; version8 retains pre-construction parking tags. Awaiting/assuming full pre-construction lot per current request, not current construction. Official SFU rear-tower photograph confirms cars and deciduous planted edge; exact stalls/drainage/finished level unresolved. Next: add reversible mapped lot and local level grading, preserving all foundations.

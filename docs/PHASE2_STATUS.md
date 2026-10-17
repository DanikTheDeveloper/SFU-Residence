# Phase 2 status — 2026-10-17

## Latest checkpoint: landscape iteration, 2026-10-17
This section supersedes historical resume instructions below. Completed: a1a46cd licensed cars; 3b8d207 level Residence Main Lot and mapped ground finishes; vegetation checkpoint follows these commits.

Added missing Residence Main Lot from its mapped pre-construction outline and levelled its core at estimated game Y=8.87m. Original terrain source, building pads and gallery preserved. User confirmed: restore the full pre-construction parking lot. This is the authoritative era target for future iterations. Exact elevation, stall arrangement, curb/drain and retaining geometry remain unverified.

Four CC0 Cosmo vehicle models replace dummy boxes. These are stylized, not photorealistic or surveyed vehicle makes. All 398 road/path segments have evidence records; 95 pedestrian segments use explicit mapped materials. Unknown finishes retain documented fallbacks. Photo-derived townhouse/East finishes remain.

Random campus-wide cone/sphere trees replaced with original branching leaf meshes constrained to mapped woodland and a photo-supported North rear edge: 25 broadleaf, 72 conifers, 59 sparse grass clumps within mapped grass. Positions, species mix and spacing are estimates; no individual tree survey was available. Rooftop garden excluded. GPU views parking_0 and parking_2 inspected: silhouettes improved, still sparse/stylized. More woodland/lawn eye-level review and density tuning are needed.

Verification: /tmp/main-parking-restricted-verification.log passes 184 checks / 341 route checkpoints / 376 terrain-ray parity checks, including North continuous gallery and new lot traverse. Later changes are visual only. /tmp/vegetation-smoke.log passes WORLD_READY. /tmp/vegetation-capture.log completes on GTX1650 Compatibility; final two parking views inspected. Preservation/family/photo validators pass, 46/46 photos. Concurrent user game prevents an isolated FPS claim. Restart with bash scripts/run_game.sh.

Next: exact parking stairs, curb/drain and retaining edges, building-side stall arrangement, planting silhouettes/grass coverage, then unresolved McTaggart connector, Shell entrance/exposed levels, Courtyard terrace/forecourt and Dining current as-built details. No buildings changed in this landscape iteration. Approved East/West, townhouses and fixed mouse preserved. See PHASE2_GROUND_PARKING_RESEARCH.md.

Actual account reading reached 90% consumed during final verification. Checkpoint saved; stop and resume on the next user request. Five hours is a usage reset, not a development deadline. One-off helper scripts backed up outside workspace at /home/danik/Backups/SFU-landscape-iteration-20261017; user files preserved.

## Historical checkpoint notes

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

Historical previous photo iteration: host reported 91% usage consumed during final verification. Finish current checkpoint and stop; resume from handoff next window.

## New landscape iteration: vehicles
Replaced box cars with four CC0 Cosmo GLB models (coupe, mobil, jeep, van). Imported meshes are normalized to existing stalls and instanced by variant. Existing collision/route clearance preserved. License included in game/assets/vehicles/cosmo. Smoke /tmp/vehicles-smoke.log passed; GTX1650 --capture-parking completed and three views reviewed. Validators pass. Capture identified pale road-edge overlays inside parking; these now suppress within mapped parking and divider spacing was corrected. Final combined parking regression will verify those changes.

Online parking research found missing Residence Main Lot, OSM way32528160. Current way is Phase3 construction; version8 retains pre-construction parking tags. User has now confirmed the full pre-construction lot as the reconstruction target. Official SFU rear-tower photograph confirms cars and deciduous planted edge; exact stalls/drainage/finished level unresolved. Next: add reversible mapped lot and local level grading, preserving all foundations.

## Verified ground/parking milestone (latest)
Added missing Residence Main Lot as a separate geographic layer, levelled its core at estimated 8.87m without changing source terrain or any building pads. First broad transition regressed gallery routes; restricted transition fixed it. 184 checks / 341 route checkpoints pass in /tmp/main-parking-restricted-verification.log. GTX1650 main-lot capture completed and views inspected. Applied explicit mapped surfaces to 95 pedestrian segments; all 398 segments indexed with evidence/unknown status. See PHASE2_GROUND_PARKING_RESEARCH.md for exact limits, source links and confirmed pre-construction target. Next: replace random cone/sphere vegetation with better geometry constrained to documented woodland/grass regions; no individually mapped tree survey exists.

# Phase 2 — active checkpoint, 2026-10-18

The current section supersedes historical camera failures and prior usage-stop notes below. User started a new usage window on October18 and explicitly confirmed the mouse now works. Preserve the existing Windows Raw Input adapter, primary-monitor/fullscreen behavior and host movement forwarding. Do not restart mouse troubleshooting absent a new reported failure.

Canonical project: outer game/, Godot4.7.2 Standard Linux/GDScript/Compatibility on Debian WSL2. Latest verified commit on resume:729bad2. Approved East/West and townhouse masters, original19 building coordinates, source terrain and preconstruction full Residence Main Lot remain protected.

Completed previous checkpoint: capped inner faces/reveals in the correct longitudinal North gallery; separate townhouse terrain-contact plinths and porch-foot extensions. Last full regression:184 physics checks,341 route points,0 failures. Worst townhouse contact views and North gallery eye-level view inspected on GTX1650. Porch approach grades remain unfinished.

Current work: Shell courtyard furnishings from the user's five local photos. Weathered timber screening and round concrete picnic tables with curved concrete seating; west-side placement is an estimate, not a measured site survey. Verified Shell checkpoint: /tmp/shell-courtyard-final-verification.log passes186 physics checks,348 route checkpoints including the new7-point fence-opening route,376 terrain-ray parity checks; preservation/family/photo validators pass. /tmp/shell-courtyard-final-capture.log completes on GTX1650 Compatibility; final shell_3 inspected at eye level. Tables stay clear of the existing route after relocation. Shell steps, annex and exact frontage grade remain unfinished. See PHASE2_SHELL_REVIEW.md. No building geometry changed in this increment.

Next priorities: Shell stairs/annex localization; McTaggart descending approach; Courtyard exterior colonnade and bridge toward West Mall; North gallery-to-parking stairs; East/West surrounding stairs and basketball court; Beedie Field refinements. Source details and uncertainties: PHASE2_SITE_WALK_CORRECTIONS.md. Beedie first pass verified: /tmp/beedie-verification.log passes191 physics checks and358 continuous route checkpoints (including10 through field gate/outfield),376 terrain-ray samples, preservation and family validators. Initial GTX1650 Compatibility capture complete; field_0 and field_3 visually inspected. Final GTX1650 Compatibility capture /tmp/beedie-final-capture.log completed after turf grain adjustment; field_1 inspected at eye level. The initial distinct linear noise pattern is removed. Runtime tests remain191 physics checks/358 route points/0 failures; only turf texture generation changed afterward. No isolated FPS claim; remaining details in PHASE2_BEEDIE_FIELD.md. Old Street View must not override current East/West, Courtyard, McTaggart or recent paving.

Continue sequential verified increments while access remains available. Five hours is the usage-reset window, not a development deadline. Update this section after each milestone; historical quota-stop messages below do not apply to this window.

## Earlier checkpoint history

## Latest checkpoint: landscape iteration, 2026-10-17
This section supersedes historical resume instructions below. Completed: a1a46cd licensed cars; 3b8d207 level Residence Main Lot and mapped ground finishes; vegetation checkpoint follows these commits.

Added missing Residence Main Lot from its mapped pre-construction outline and levelled its core at estimated game Y=8.87m. Original terrain source, building pads and gallery preserved. User confirmed: restore the full pre-construction parking lot. This is the authoritative era target for future iterations. Exact elevation, stall arrangement, curb/drain and retaining geometry remain unverified.

Four CC0 Cosmo vehicle models replace dummy boxes. These are stylized, not photorealistic or surveyed vehicle makes. All 398 road/path segments have evidence records; 95 pedestrian segments use explicit mapped materials. Unknown finishes retain documented fallbacks. Photo-derived townhouse/East finishes remain.

Random campus-wide cone/sphere trees replaced with original branching leaf meshes constrained to mapped woodland and a photo-supported North rear edge: 25 broadleaf, 72 conifers, 59 sparse grass clumps within mapped grass. Positions, species mix and spacing are estimates; no individual tree survey was available. Rooftop garden excluded. GPU views parking_0 and parking_2 inspected: silhouettes improved, still sparse/stylized. More woodland/lawn eye-level review and density tuning are needed.

Verification: /tmp/main-parking-restricted-verification.log passes 184 checks / 341 route checkpoints / 376 terrain-ray parity checks, including North continuous gallery and new lot traverse. Later changes are visual only. /tmp/vegetation-smoke.log passes WORLD_READY. /tmp/vegetation-capture.log completes on GTX1650 Compatibility; final two parking views inspected. Preservation/family/photo validators pass, 46/46 photos. Concurrent user game prevents an isolated FPS claim. Restart with bash scripts/run_game.sh.

Next: exact parking stairs, curb/drain and retaining edges, building-side stall arrangement, planting silhouettes/grass coverage, then unresolved McTaggart connector, Shell entrance/exposed levels, Courtyard terrace/forecourt and Dining current as-built details. No buildings changed in this landscape iteration. Approved East/West, townhouses and fixed mouse preserved. See PHASE2_GROUND_PARKING_RESEARCH.md.

Actual account reading reached 90% consumed during final verification. Checkpoint saved; stop and resume on the next user request. Five hours is a usage reset, not a development deadline. One-off helper scripts backed up outside workspace at /home/danik/Backups/SFU-landscape-iteration-20261017; user files preserved.

## Historical checkpoint notes

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

Historical previous photo iteration: host reported 91% of the five-hour usage window consumed while finishing verification. Stop after saving current checkpoint; next user-started iteration resumes here. Five hours is a usage reset, not a development deadline. No automatic reset wait or resume is scheduled.

## New landscape iteration: vehicles
Replaced box cars with four CC0 Cosmo GLB models (coupe, mobil, jeep, van). Imported meshes are normalized to existing stalls and instanced by variant. Existing collision/route clearance preserved. License included in game/assets/vehicles/cosmo. Smoke /tmp/vehicles-smoke.log passed; GTX1650 --capture-parking completed and three views reviewed. Validators pass. Capture identified pale road-edge overlays inside parking; these now suppress within mapped parking and divider spacing was corrected. Final combined parking regression will verify those changes.

Online parking research found missing Residence Main Lot, OSM way32528160. Current way is Phase3 construction; version8 retains pre-construction parking tags. User has now confirmed the full pre-construction lot as the reconstruction target. Official SFU rear-tower photograph confirms cars and deciduous planted edge; exact stalls/drainage/finished level unresolved. Next: add reversible mapped lot and local level grading, preserving all foundations.

## Verified ground/parking milestone (latest)
Added missing Residence Main Lot as a separate geographic layer, levelled its core at estimated 8.87m without changing source terrain or any building pads. First broad transition regressed gallery routes; restricted transition fixed it. 184 checks / 341 route checkpoints pass in /tmp/main-parking-restricted-verification.log. GTX1650 main-lot capture completed and views inspected. Applied explicit mapped surfaces to 95 pedestrian segments; all 398 segments indexed with evidence/unknown status. See PHASE2_GROUND_PARKING_RESEARCH.md for exact limits, source links and confirmed pre-construction target. Next: replace random cone/sphere vegetation with better geometry constrained to documented woodland/grass regions; no individually mapped tree survey exists.

## Active site-walk iteration — 2026-10-17
User's latest corrections are durable in PHASE2_SITE_WALK_CORRECTIONS.md. Camera physical capture reopened: Wayland alone was tested by user and still lets the pointer escape. Implemented a foreground-only Win32 raw-mouse helper using existing Windows Python plus localhost GDScript adapter; no engine/renderer change. Actual Windows-to-Linux connection QA passed. Physical multi-turn/Escape/Alt+Tab confirmation pending; see PHASE2_MOUSE_CAPTURE.md. Never equate synthetic yaw tests with physical capture success.
North gallery one-sided wall meshes now have 16cm inner faces and capped opening reveals. /tmp/gallery-closed-verification.log passes full 184 checks / 341 route checkpoints, including continuous North gallery. Visual inspection still pending. Next: finish camera physical validation and gallery captures, then terrain-contact audit / photo-supported site surrounds. Full user-confirmed pre-construction parking target retained.

Site-walk one-off patch helpers and review-only converted image archived outside active workspace at /home/danik/Backups/SFU-site-walk-20261017. Retained reusable input/contact diagnostic scripts. Final checkpoint follows926ab25; inspect git log for hash.

## Final user confirmation and next scope — 2026-10-17
User explicitly confirms: mouse now works. Preserve the Windows raw-input / immutable WSLg title fix and primary-monitor placement. Latest movement fix also forwards only W/A/S/D/Shift/Space while the game is active; no keyboard hook or key logging. HostMovementQA passes forward movement, right sprint, release stopping and one-shot jump. User's latest wording confirms mouse, not separately every movement key; retain physical WASD/Shift/jump check on next launch.

User authorizes careful visual inspection of Google Street View or similar. Do not scrape/extract protected imagery or ship its pixels. Date every reference and prefer recent official/user photos. Old Street View is explicitly obsolete for modern East/West Towers, McTaggart updates, Courtyard (absent in old imagery), and paving before East/West. Preserve correctly completed facade models. Use historical imagery only for features whose persistence is corroborated; never overwrite newer evidence with an old view.

Next modeling priority: Shell's immediate surroundings (photo-localized furniture, timber fence, stair landings), then McTaggart descending approach; Courtyard open exterior colonnade and West Mall-facing bridge; North gallery-to-parking stairs; East/West exterior stairs/basketball; Beedie Field. Complete one verified feature at a time. All remain pending except North wall closure and townhouse ground contact completed this iteration. Full pre-construction parking remains confirmed.

Actual host usage signal at final checkpoint: primary100%, ordinaryUsageAllowed=false, rate_limit_reached. Stop after saving tested files. No new modeling started after this signal. Next user-started iteration resumes with this note and PHASE2_SITE_WALK_CORRECTIONS.md, not earlier mouse-failure or usage-stop text.




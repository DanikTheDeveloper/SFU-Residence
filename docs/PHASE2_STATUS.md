# Phase 2 status — 2026-10-16

## Current North Towers correction
User confirmed the gallery runs LONGITUDINALLY under the long courtyard-facing wing, connecting Pauline Jewett, Barbara Rae and Shadbolt. The previous two north–south tunnels were incorrect and are superseded. The common North master now cuts an east–west ground gallery through all three existing footprints, retains a closed rear residential boundary, courtyard columns and overhead collision, and provides terrain-following paving and connecting canopy spans. No upper-floor building mass or registry coordinates were moved. Central recessed closed exterior doors follow the supplied courtyard photo. Width3.6m, clear height2.9m and connector roof spans/grades are estimated, not surveyed.

Verified:169 physics checks pass, including bidirectional traversal of each gallery, a continuous PJH→BRH→SBH route and reverse, rear-wall/column/ceiling collision and376/376 terrain-ray parity. All333 pre-existing continuous route checkpoints pass. Family validator8 families/10 named instances/0errors. Protected E/W master, FacadeKit,19-building registry, roads/site, terrain/pads and Phase1 rollback/archive validators pass. Final GPU capture completed on GTX1650/Compatibility at1280x720; views8 and12 inspected: courtyard doorway and longitudinal eye-level view. Performance is viewpoint-dependent; no universal60FPS claim.

The independent parking-stair prototype is disabled and archived at /home/danik/Backups/SFU-North-stair-prototype-20261016. Its exact connection to the corrected gallery requires a fresh placement audit; do not activate it based on the old transverse tunnel assumption.

## Preserved baseline
Godot4.7.2 Standard, GDScript, Compatibility/OpenGL, Debian13 WSL2, GTX1650. Camera native capture/separate yaw and pitch is user-confirmed fixed: full turns, no blinking. Do not change. East/West Towers and approved townhouses unchanged. Terrain source data, smoothing, thresholds and coordinates preserved. No interiors, NPCs or online AI.

## Next architecture
After final North visual checkpoint: Hamilton Hall from handpicked photos. Two photos show matching grey four-storey siding/window-bay architecture, one has readable Hamilton Hall sign. The third photo (1726522313260.jpg) depicts a different modern facade and must not drive Hamilton modeling without identification. Hamilton now has its own detailed exterior master (see latest milestone below). Dining and Shell remain distinct-photo modeling backlog; Courtyard lower wings unresolved; MCH renewed model exists. Paving/curbs/parking stair connections need continued evidence-backed refinement.

## Hamilton verified milestone
Distinct HamiltonExterior.gd and HamiltonPaving.gd now implemented from two matching handpicked photos and the official SFU north-oriented level2 plan. Grey stucco central block, light-grey siding, paired projecting window stacks, frames/transoms, fascia/gutters, stone base, closed glazed entry, broad north portico and original procedural grey/brown pavers with pale bands. Registry east anchor remains a secondary doorway. Central north entry position is plan/photo-informed; exact ground dimensions remain estimated (public PDF lacks ground plan).

Final173 physics checks pass (/tmp/hamilton-checkpoint-physics.log), all333 continuous route checkpoints pass (/tmp/hamilton-portico-routes.log), original geography/pads/E/W/FacadeKit/archive/family validators pass. Initial oversized portico placements failed routes and were corrected; latest supports sit within the apron clear of original routes. Final GTX1650 Compatibility capture completed (/tmp/hamilton-checkpoint-capture.log), hamilton_1/2/3 views inspected for facade, north entrance and first-person paving/door detail. See performance_hamilton.json for measured per-view performance, not a universal60FPS guarantee.

Next: Shell House handpicked-photo review and distinct facade, retaining floor-count uncertainty (photos show3 visible levels at entry, registry says4). Dining Commons distinct detailed model and North parking-stair placement/curved courtyard landscaping remain pending. Approved E/W, townhouses, mouse camera, terrain and original route data unchanged.

## Shell verified facade milestone
Distinct ShellExterior.gd implemented from5 individually inspected user photos: brown square-panel texture, dark narrow paired glazing, concrete floor bands, pale deep fins on top storey, closed entry and thin reddish canopy fascia.175 physics checks and333 continuous route checkpoints pass in /tmp/shell-verification.log; original registry, terrain/pads, E/W/FacadeKit and archive validators pass. GTX1650 Compatibility capture completed; shell_0/1/2 inspected for doorway and both long elevations.

Official SFU Facilities directory now corroborates4 TOTAL levels. Photos show3 visible levels at entry, so above-grade/basement exposure remains unresolved; retained4-level baseline is not claimed photo-exact. Mapped short-end entry remains provisional versus photo long-frontage doorway. Annex, breeze-block corner, fence/pergola, sign and picnic-table positions require a footprint/location audit. See PHASE2_SHELL_REVIEW.md and local PHOTO_REVIEW/ONLINE_REFERENCES indexes.

Next: Dining Commons source-era/footprint audit before modeling. Supplied photos depict older concrete/glass wing;2022 DIALOG expansion is distinct and gallery inspected so far contains interiors. Do not apply old-wing facade to the whole merged building. North parking-stair linkage and courtyard landscaping remain open.

2026-10-17 foundation follow-up: Shell grade stems close the visible gap below the lower facade band using existing terrain samples; foundation/pad and XZ unchanged.175 checks and333 route checkpoints pass in /tmp/shell-grade-verification.log. GTX1650 capture completed, entrance view inspected.

## Dining Commons verified checkpoint — 2026-10-17
Distinct old-wing / north-extension exterior implemented from individually reviewed local photos, architect information and credited construction/render references. See PHASE2_DINING_REVIEW.md. 177 checks and 333 route checkpoints pass after grade-stem correction in /tmp/dining-grade-verification.log. GTX1650 Compatibility capture completed; all four dining views inspected. Next: photo-based North apron paving and courtyard light geometry at existing estimated fixture locations. Do not treat design-render finishes as confirmed as-built.

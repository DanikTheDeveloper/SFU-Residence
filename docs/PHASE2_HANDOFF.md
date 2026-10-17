# Phase 2 handoff — 2026-10-17

## Latest verified checkpoint: local pavement finishes
Courtyard massing checkpoint e642e99 remains verified (180 physics checks / 333 route checkpoints). Pavement now distinguishes grey townhouse paths, warm/grey East entrance pavers and aggregate concrete. Original path/parking polygons, terrain and collisions are unchanged. Close-view inspection caught and corrected coplanar overlap: shared world UVs and ordered 45/50/55/65/75mm visual layers remove competing patterns without physics changes. These small offsets are render separation, not actual surveyed curb heights.

Smoke passed in /tmp/pavement-finish-smoke.log. Final GTX1650 Compatibility capture /tmp/pavement-final-capture.log and paving_0..2.png reviewed. Runtime reports 195 concrete, 111 townhouse-grey, 2 East-paver and 90 vehicle segments. Preservation and family validators pass. Exact material boundaries, joint orientation/spacing and apron extent are estimated. Master East/West and townhouse architecture unchanged.

Next: McTaggart window/entrance detail pass; connector massing/location still requires evidence. All 46 current local photo files have individual review records in data/photo_review_coverage.json.


## Resume here
Use outer game/ and current working tree. Verified commits: 1df28b3 Dining exterior, 55c709d paving/fixtures, 8d64ecf grass and capture artifacts. Latest material/index commit follows these. Earlier verified milestones: da90b52 North longitudinal gallery, 996cd31 Hamilton, 9935b61 Shell facade, 6f108df Shell grade stems.

Landscape checkpoint 55c709d:
- ResidencePavers.gd: original 256px mipmapped grey running-bond pavers, estimated 400x200mm scale, aligned to North courtyard apron. Gallery floor remains concrete.
- CourtyardLighting.gd: open-frame charcoal fixture from user PWL 1025. Replaces generic fixture shapes at existing estimated positions near EAT/WET; no claim of surveyed light coordinates.
- NorthTowerPassage.gd and ResidenceWorld.gd integrate these; north capture adds close-up views 13/14.
- Four local landscape photos individually reviewed; PHOTO_REVIEW.json and PHASE2_LANDSCAPE_PHOTO_REVIEW.md record evidence and limits.

Landscape verification passed: 177 checks and 333 routes in /tmp/landscape-photo-verification.log. North views 13/14 inspected; final reduced-contrast pavers inspected in landscape_0.png using --capture-landscape. Next: original subtle grass texture while preserving terrain/collision. All prior building/route checks remain valid.

## Critical interpretation
North gallery runs along the long courtyard-facing wing through all three houses. The user explicitly confirmed this. Do not restore the superseded transverse tunnels or infer ground layout from upper-floor plans. Parking stair prototype is archived at /home/danik/Backups/SFU-North-stair-prototype-20261016 and requires corrected-gallery location audit before reuse.

Hamilton north entrance is photo/upper-plan-informed, exact ground dimensions estimated. Preserve wide portico supports at their tested positions; earlier supports blocked routes. Exclude mismatched local image 1726522313260.jpg pending identification.

Shell has four total levels per SFU, but photos show three exposed levels at entry. Long-frontage photo door vs old short-end route anchor remains unresolved. Dining north finish uses 2021 design intent and construction photos; no current as-built confirmation. See building reviews and PHASE2_PHOTO_REFINEMENT_BACKLOG.md.

## Preserve and operate
Godot 4.7.2 Standard/GDScript/Compatibility, Debian WSL2, GTX1650, strict first person. User confirmed mouse works. Do not alter approved East/West or townhouse masters, FacadeKit, original geographic data, pads or terrain smoothing. No dependencies to install. Original nested game retained; obsolete nested Markdown already backed up outside project and removed.

Use bash scripts/run_game.sh; restart needed to see changes in an already running game. A separate interactive Godot process was running throughout captures; leave user session alone. FPS reports are concurrent-load observations, not isolated benchmarks.

All edits are local. User reference photos, FILE_MANIFEST.json, historic_maps and untracked metadata must be preserved. 27 known one-off patch scripts were backed up byte-for-byte to /home/danik/Backups/SFU-iteration-helper-scripts-20261017 and removed from scripts/. Unknown files were preserved.

Continue useful evidence-backed work while usage permits. Five hours is a usage reset, not a deadline. Save status/handoff after each verified milestone; stop only on actual low-usage signal or user instruction.

## Verified grass material increment
GroundMaterials.gd adds a subtle original mipmapped grass colour texture to the existing terrain mesh. No vertex, normal, height, collision or pad changes. This is generic surface detail consistent with planted-site references, not a surveyed species or planting map. Smoke passed in /tmp/ground-material-smoke.log; /tmp/ground-material-capture.log completed and both landscape views inspected; preservation/family validators passed. McTaggart per-photo index is now complete; Courtyard per-photo index still needs the same review. Prioritize North stair localization, then McTaggart entry/connector massing and Shell grade/door uncertainty. Keep all surveyed/confirmed geometry distinctions explicit.

## Verified McTaggart material follow-up
Six supplied images indexed; design rendering and duplicate distinguished. Corrected mortar contrast and brick scale from completed photographs. Geometry unchanged. Smoke passed in /tmp/mctaggart-material-smoke.log. GTX1650 Compatibility capture completed in /tmp/mctaggart-material-capture.log; both views inspected, including close-up mortar/brick scale. Preservation and family validators pass. Entrance/connector massing still needs a separate photo/plan correction; this checkpoint only corrects material.

## Previous iteration usage-window handoff (historical)
Host reported 93% of the five-hour allowance used. Finished the current material correction and saved verified work; no further changes started. Next iteration: read this handoff, inspect git status, and continue the prioritized photo backlog. Do not redo completed Dining or landscape work.

## Verified new iteration: Courtyard massing
Latest resume baseline d9f9dc5. Five Courtyard photos individually reviewed and indexed. Correcting erroneous uniform eleven-storey extrusion into highrise / three-storey lowrise / lower atrium while preserving the full original outline and tallest roof height. See PHASE2_COURTYARD_PHOTO_REVIEW.md. Final /tmp/courtyard-grade-verification.log: 180 checks and 333 route checkpoints pass. GPU views inspected. Photo index coverage now 46/46 files, including individually reviewed Courtyard, East/West and Townhouse files; exact duplicates and uncertain identities recorded. Next: local paving variants and textured paths, keeping all geometry and approved architecture intact.


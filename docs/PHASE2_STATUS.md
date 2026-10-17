# Phase 2 status — 2026-10-17

## Latest verified checkpoint: local pavement finishes
Courtyard massing checkpoint e642e99 remains verified (180 physics checks / 333 route checkpoints). Pavement now distinguishes grey townhouse paths, warm/grey East entrance pavers and aggregate concrete. Original path/parking polygons, terrain and collisions are unchanged. Close-view inspection caught and corrected coplanar overlap: shared world UVs and ordered 45/50/55/65/75mm visual layers remove competing patterns without physics changes. These small offsets are render separation, not actual surveyed curb heights.

Smoke passed in /tmp/pavement-finish-smoke.log. Final GTX1650 Compatibility capture /tmp/pavement-final-capture.log and paving_0..2.png reviewed. Runtime reports 195 concrete, 111 townhouse-grey, 2 East-paver and 90 vehicle segments. Preservation and family validators pass. Exact material boundaries, joint orientation/spacing and apron extent are estimated. Master East/West and townhouse architecture unchanged.

Next: McTaggart window/entrance detail pass; connector massing/location still requires evidence. All 46 current local photo files have individual review records in data/photo_review_coverage.json.


## Current runnable checkpoint
Commits 1df28b3 (Dining Commons) and 55c709d (landscape paving/fixtures), following North gallery, Hamilton and Shell milestones. Godot 4.7.2 Standard, GDScript, Compatibility/OpenGL, Debian WSL2 retained. First-person mouse fix remains unchanged and was confirmed working by the user.

## Verified progress
- North Towers: shared model with the user's corrected LONGITUDINAL courtyard-side gallery connecting Pauline Jewett, Barbara Rae and Shadbolt. Previous transverse-tunnel assumptions are obsolete. Recessed closed doors, columns, rear boundary and overhead collision; connectors are estimated.
- Hamilton: distinct grey four-level exterior, paired window projections, north portico and procedural paver apron. Two matching handpicked photos and north-oriented SFU floor plan used; one mismatching photo excluded.
- Shell: distinct concrete/brown-panel exterior, paired narrow windows, top-storey fins and grade-following foundation stems. Official source confirms four total levels; visible three-level exposure at entrance remains unresolved.
- Dining: original concrete south wing distinguished from northern 2022 extension; curtain wall, screens, clerestory, overhangs and grade stems. User photos cover old wing; new finish partly based on credited design rendering, not verified as-built.
- Approved East/West and townhouse masters, original 19-building coordinates, terrain/pads, roads and parking geometry remain unchanged. No interiors/NPCs/API.

## Latest completed verification
/tmp/dining-grade-verification.log: 177 checks, 333 route checkpoints and preservation validators passed. Family validator: eight families, ten named instances, zero errors. GTX1650 Compatibility captures completed; all four Dining eye-level views inspected. Screenshots and performance reports live under game/docs.

A separate interactive game was already running during captures; measured FPS shares its GPU load. Do not claim isolated performance or guaranteed 60 FPS.

## Verified landscape increment
Photo-based North courtyard pavers and open-frame courtyard light geometry at existing estimated positions. 177 checks and 333 routes passed in /tmp/landscape-photo-verification.log. GPU capture completed and North views 13/14 inspected; final reduced-contrast paver capture inspected via --capture-landscape (landscape_0.png). Next: subtle original grass surface material, with unchanged terrain geometry.

## Remaining work
See PHASE2_PHOTO_REFINEMENT_BACKLOG.md and individual HAMILTON/SHELL/DINING/LANDSCAPE review documents. Priorities: exact North parking-stair/longitudinal-gallery relationship, planted-bed boundaries and terrain transitions, Shell entrance/above-grade exposure, as-built Dining exterior, further Courtyard/McTaggart entry detail. Photograph material evidence does not establish measured locations.

## Verified grass material increment
GroundMaterials.gd adds a subtle original mipmapped grass colour texture to the existing terrain mesh. No vertex, normal, height, collision or pad changes. This is generic surface detail consistent with planted-site references, not a surveyed species or planting map. Smoke passed in /tmp/ground-material-smoke.log. GTX1650 capture completed; both landscape views inspected. Terrain/preservation and family validators pass.

## Verified McTaggart material follow-up
Six supplied images indexed; design rendering and duplicate distinguished. Corrected mortar contrast and brick scale from completed photographs. Geometry unchanged. Smoke passed in /tmp/mctaggart-material-smoke.log. GTX1650 Compatibility capture completed in /tmp/mctaggart-material-capture.log; both views inspected, including close-up mortar/brick scale. Preservation and family validators pass. Entrance/connector massing still needs a separate photo/plan correction; this checkpoint only corrects material.

## Previous iteration usage-window handoff (historical)
Host reported 93% of the five-hour allowance used. Finished the current material correction and saved verified work; no further changes started. Next iteration: read this handoff, inspect git status, and continue the prioritized photo backlog. Do not redo completed Dining or landscape work.

## Verified new iteration: Courtyard massing
Latest resume baseline d9f9dc5. Five Courtyard photos individually reviewed and indexed. Correcting erroneous uniform eleven-storey extrusion into highrise / three-storey lowrise / lower atrium while preserving the full original outline and tallest roof height. See PHASE2_COURTYARD_PHOTO_REVIEW.md. Final /tmp/courtyard-grade-verification.log: 180 checks and 333 route checkpoints pass. GPU views inspected. Photo index coverage now 46/46 files, including individually reviewed Courtyard, East/West and Townhouse files; exact duplicates and uncertain identities recorded. Next: local paving variants and textured paths, keeping all geometry and approved architecture intact.


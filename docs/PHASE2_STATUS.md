# Phase 2 status — 2026-10-17

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

## Usage-window handoff
Host reported 93% of the five-hour allowance used. Finished the current material correction and saved verified work; no further changes started. Next iteration: read this handoff, inspect git status, and continue the prioritized photo backlog. Do not redo completed Dining or landscape work.

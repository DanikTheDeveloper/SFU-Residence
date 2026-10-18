# Phase 2 status — 2026-10-18

## Current verified state
Canonical project is outer game/. Godot4.7.2 Standard Linux, GDScript, OpenGL Compatibility, Debian WSL2 and GTX1650 remain unchanged. Mouse is user-confirmed working; retain the Windows Raw Input adapter, fullscreen/primary-monitor placement and host movement forwarding. No new camera changes this iteration.

-2d0ca64: Shell courtyard furniture. Weathered timber fence, three original round concrete picnic sets with curved seats, and narrow concrete walk. Existing passage left open. First table placement blocked a real regression route; relocated it and all routes now pass. Photo forms verified; exact west-frontage placement/count/dimensions remain estimated. Shell building geometry unchanged.
-560b2cf: Beedie Field. Original OSM outline retained, local reversible level-surface grading, turf/infield/warning-track, fence/backstop, six unlit pole assemblies, approximate open shelters and scoreboard. Original terrain sources and building pads unchanged. Study boundary extended only around field so it is not cut off. This is a playable first pass, not a completed surveyed sports facility.
-Courtyard research: three additional DIALOG completed-project photographs inspected and indexed. Court-facing undercroft, tall eastern portico and eastern entrance are distinct arrangements. Implementation remains pending; exact next increment in PHASE2_COURTYARD_PHOTO_REVIEW.md.

## Verification
Final geometry regression /tmp/beedie-verification.log:191 physics checks,358 continuous route checkpoints,376 terrain-ray parity samples, zero failures. Includes original routes, Shell fence opening and Beedie gate/outfield. Preservation validator confirms unchanged19-building XZ, original site/routes, approved East/West master/FacadeKit/pads and source contour grid. Architectural family validator:8 families,10 named instances,0 errors. Photo inventory46/46 indexed,0 findings; does not establish fidelity or reuse rights.

GPU capture /tmp/shell-courtyard-final-capture.log completed; final shell_3 inspected. /tmp/beedie-final-capture.log completed after a turf-noise-only adjustment; field_0/field_3 initial and field_1 final inspected. Device log confirms GTX1650 through D3D12/OpenGL Compatibility. Captures are not an isolated performance benchmark; visual quality remains simplified. Screenshots in game/docs/screenshots.

## Remaining work
1. Courtyard actual open ground level/columns/closed inner boundary and bridge toward West Mall; reconcile the differently sized exterior spaces before carving geometry.
2. North longitudinal gallery is correct and closed inner wall faces were repaired previously; photo-localized exits/stairs to parking still missing.
3. Shell stairs/landings, annex/pergola, trees, actual entry placement and three visible vs four total levels still unresolved.
4. McTaggart descending approach/connector, East/West surrounding stairs and confirmed basketball placement.
5. Beedie sunken dugouts, bleachers/bullpens/batting cage, precise pole/scoreboard locations and finished elevations; current fixtures are estimates.
6. Further photo-grounded paving/curbs/drains/retaining features; townhouse approach grades; denser realistic planting where supported.

All approved East/West and townhouse architecture preserved. Full preconstruction Residence Main Lot remains the user-selected target. No interiors, NPCs, conversations or API integration.

Host usage read87% consumed near final handoff; this is a usage reset window, not a five-hour coding deadline. Resume on the next user request; no automatic continuation is scheduled. Historical status/handoff backups outside workspace: /home/danik/Backups/SFU-site-iteration-20261018 (initial and before-final copies). Specific earlier evidence remains in the other PHASE2 documents.

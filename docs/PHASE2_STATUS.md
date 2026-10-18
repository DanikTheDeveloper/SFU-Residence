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

## User follow-up: THREE residence-adjacent fields — 2026-10-18
User confirms there are three distinct fields behind West/East/McTaggart; Beedie alone is incomplete. Source preparation completed within user-reported remaining7% allowance; no runtime geometry changed.

Official SFU Recreation https://www.sfu.ca/recreation/info/facilities.html identifies Field4 as artificial turf for soccer/lacrosse (two coaches booths, lighting,360 seats), Field2 as grass for rugby/soccer, Beedie as softball. Cross-checked SFU Athletics facilities page https://athletics.sfu.ca/sports/2014/8/8/ATH_0808144723.aspx?id=90 . Existing precinct.osm contains all three adjacent mapped venues. Terry Fox Field is a different venue farther east; do not substitute it for Field2.

scripts/prepare_residence_fields.py writes data/site_sources/residence_fields_projected.json, with original source IDs/tags, projected polygons, bounds, licensing and implementation status. Projection regression matches the existing Beedie coordinates exactly.
-Field4 playing surface: OSM32528090, X-59.569..75.245,Z65.583..156.018. Outer facility OSM1091325198: X-80.895..77.733,Z57.832..158.875. These overlap and are ONE field, not two.
-Field2: OSM32528091, X138.738..273.958,Z159.298..257.972. Extends beyond current rendered terrain Z240 AND playable boundary; must expand sampled terrain/render/collision coverage deliberately. Do not clamp elevations outside the old grid or clip/relocate the field.
-Beedie: OSM32528092, already implemented first pass; preserve it.

Next field increment: audit Field4 against the current anonymous green quadrilateral in ResidenceWorld.build_ground ([-66,74],[55,100],[40,160],[-80,137]); replace that placeholder with the mapped field rather than layering duplicate turf. Also audit spawn[35,80], paths, boundary and level grading before placing goals/fences. Obtain current specific field photos; preserve surrounding approved buildings. Then extend geographic/terrain coverage for Field2, with collision and traversal checks. Neither missing field has been implemented yet.

All repeated user remarks remain active: mouse now works and must be preserved; Shell timber seating/fence/stairs/terraces (fence/concrete picnic seating partial, timber benches not yet verified); McTaggart descending approach; Courtyard open supported ground level and bridge toward West Mall; North gallery direction correct, wall backsides fixed previously but parking stairs pending; East/West exterior stairs and basketball court while preserving facades; three sports fields; townhouse ground contact improved but approach grades pending; continuing paving/curb/retaining/landscape research. Old Street View cannot override current East/West, McTaggart, Courtyard or newer paving. No request was dropped.

Current runtime remains verified checkpoint560b2cf:191 physics checks/358 route points; this source/documentation follow-up needs no repeated runtime test. Resume this expanded backlog on next user-started window; prior stop wording does not mean work is finished.

## Verified Field4 checkpoint — 2026-10-18, new usage window
This section supersedes the earlier stop instruction and statement that Field4 is missing. Field4 now replaces the anonymous turf patch with its mapped outline, level local grade, soccer lines and goals. Approved building models and input unchanged. Official field photographs inspected and URL-only indexed in Sports_Fields/ONLINE_REFERENCES.json; see PHASE2_RESIDENCE_FIELDS.md for uncertainty.

Verification: /tmp/field4-boundary-verification.log physics199/199 and terrain parity376/376. Final route-only rerun /tmp/field4-route-final.log passes372/372 checkpoints including14 Field4 approach/pitch points; prior failure was a too-long timed test segment, now subdivided without changing its path. Runtime/family/photo validators pass. GPU capture /tmp/field4-boundary-capture.log completed on GTX1650 Compatibility; eye-level field4_0 and final aerial field4_2 inspected. Capture reports19fps/429draws under concurrent testing, not an isolated benchmark; performance remains a concern.

Next: integrate prepared Field2.gd, field2.json, field2_grade.json and field2_terrain_extension.json. They are currently untracked preparation, not runtime-active. User clarified eastern Field2 beside McTaggart; separate Field4 behind towers. Preserve official rugby/soccer description and photo-confirmed H goals; American football yard lines unconfirmed. Extend render grid to Z280, union boundary, and test seam/collision/traversal. Then resume Courtyard portico and the full retained site backlog above. No earlier user remarks were dropped.

## Verified Field2 checkpoint — 2026-10-18
Field2 is now runtime-active; all THREE residence-adjacent fields exist. OSM32528091 footprint preserved. Original natural-grass material and two photo-supported H-goal assemblies; goal dimensions/positions remain estimated. User's eastern-location clarification retained; official venue description rugby/soccer differs from user's football/second-Beedie naming. No unsupported yard-number markings.

Terrain extends from Z240 to Z280 using7520 appended samples from original licensed contours, with separate3952-sample local grade at estimated0.52m. Original terrain_grid and pads remain unchanged. Rendering/collision and study boundary cover the entire field. /tmp/field2-verification.log:215 physics checks,385 route points,376 existing terrain parity samples,0 failures. Includes level/collision/boundary samples beyondZ240, seam continuity and13-point approach/pitch route. Preservation validation passes.

/tmp/field2-capture.log completed on GTX1650 Compatibility. field2_0 eye-level and field2_2 aerial visually inspected. Three fields correctly distinct and no clipped ground. Site-limit hedge is still an artificial boundary; forest-edge planting/precise field surroundings remain missing. Capture means59fps looking across empty field,18fps facing campus,17fps aerial at1280x720 medium during regression; these are diagnostic samples, not isolated benchmarks. Large campus views need optimization.

Next: Courtyard eastern tall portico, then inner-court undercroft/West Mall bridge, North parking stairs and remaining Shell/McTaggart/East-West hardscape from existing backlog. Approved towers, all buildingXZ, mouse and stack preserved. Source extension generator: python3 scripts/build_field2_grade.py . Capture: bash scripts/run_game.sh -- --capture-field2 .

# Phase 2 status — 2026-10-18

## Latest verified state
Canonical project: outer game/. Godot4.7.2 Standard Linux, GDScript, Compatibility/OpenGL, Debian WSL2 and GTX1650 preserved. Mouse is user-confirmed working; Windows Raw Input, forwarded movement, fullscreen and primary-monitor behavior unchanged. Original19-building XZ, approved East/West facade master/FacadeKit, building pads, source elevations and original routes remain unchanged.

### Completed in this usage window
-681cade: Field4 replaces the anonymous green placeholder with the mapped playing surface, separate reversible level grading, soccer lines and two goals. Official SFU photo inspected. Estimated finished level -1.52m; fixture dimensions/locations provisional.14-point field traversal passes.
-92d2543: eastern Field2 added beside McTaggart. Mapped polygon, natural-grass material and photo-confirmed H-shaped goals. Terrain appended fromZ240 toZ280 using original licensed contours; source grid untouched. Estimated finished level0.52m. Collision/boundary coverage and13-point approach/extended-ground traversal pass. All THREE residence-adjacent fields now exist.
-Courtyard eastern portico: shallow open exterior under the glazed highrise end, tall concrete piers, closed soffit, recessed opaque glazing, upper-level rail/walkway indication, ceiling fins and grey pavers. Original full upper footprint/roof heights retained. This is the eastern tall portico only; the lower inner-court gallery and West Mall bridge remain pending. Depth3.4m, height6.2m and pier spacing are estimates from DIALOG0058, not measured plans.

User calls eastern Field2 the second part of Beedie/football field. Official SFU calls it Field2 and lists rugby/soccer. Identity/location confirmed; American football yard markings unconfirmed and not invented. Field4 is the separate field behind the towers. References: reference_photos/Sports_Fields/ONLINE_REFERENCES.json and PHASE2_RESIDENCE_FIELDS.md.

## Verification
/tmp/courtyard-portico-verification.log:218 physics checks and376 original terrain-ray parity samples pass. Final /tmp/courtyard-portico-route-final.log:389 continuous route checkpoints pass, including all original routes, parking, Shell, Beedie, Field4, Field2 and4-point Courtyard portico entry/crossing/exit. Final paving/capture additions are visual only; final route run also confirms successful scene load. Final route log copied to game/docs/phase2_tests/routes.log.

Runtime preservation,8-family/10-instance and46-photo inventory validators pass. Photo index validation does not establish fidelity or reuse rights. No dependency installed.

GPU captures on GTX1650/D3D12 OpenGL Compatibility completed: field4,field2 and courtyard. Inspected field4 eye-level/aerial, field2 eye-level/aerial, courtyard eastern approach and final courtyard_4 under-portico view. Last capture /tmp/courtyard-portico-final-capture.log. Large campus views remain roughly17–20fps under concurrent testing; simple field/portico views can approach60fps. Not an isolated benchmark; optimization remains needed. Game/docs contains screenshots and per-view measurements.

## Retained completed work
Shell photo-derived weathered fence, round concrete picnic furniture and narrow walk (2d0ca64); Beedie softball first pass with local grade/access/backstop/fence/shelters (560b2cf); North longitudinal gallery direction and wall-backside repair; townhouse ground-contact plinths; full preconstruction Main Lot leveling and CC0 cars. Preserve these, original nested rollback, user photos and all input work.

## Remaining user-requested work
1. Courtyard lower inner-court supported gallery, bridge toward West Mall, paved forecourt/curb/retaining transitions. The current grass slope outside the new portico is visibly too crude. Do not hollow the entire building or apply the tall portico height everywhere.
2. North gallery exits/stairs toward parking, photo-localized. PWL1001 shows Shadbolt courtyard-facing stairs; it is not proof of the rear parking connection. Gallery direction remains correct; inner faces repaired previously.
3. Shell stairs/landings, terrace/pergola/annex, trees, entry localization, three visible vs four total levels. Current fence/concrete picnic seating is partial; timber benches not yet verified.
4. McTaggart descending approach/connector; East/West surrounding stairs and confirmed basketball placement. Do not remodel approved tower exteriors.
5. Sports fields: accurate approaches, forest edges, actual perimeter fences, Field4 booths/stands/lighting/scoreboard placement; Beedie sunken dugouts, bleachers, bullpens and batting cage. Study-limit hedge remains an artificial boundary. Finished levels/fixture positions need stronger evidence.
6. Further photo-grounded concrete/pavers/curbs/drains/retaining walls, townhouse approach grades and more realistic planting. Existing townhouse architecture/contact fixes retained.
7. Performance in broad campus views; avoid degrading GTX1650 Compatibility support or changing approved buildings merely to reduce detail.

Old Street View cannot override current East/West, modern McTaggart, Courtyard or newer paving. All local selected photos remain priority; URL-only additional references carry provenance and uncertainty. No interiors/NPCs/conversations/API integration.

Host usage read85% consumed before final verification/handoff. Current safe operation completed; next user-started usage window should resume from HANDOFF. Five hours is quota reset, never a coding deadline. No automatic reset wait/resume. Previous long status/handoff archived outside project at /home/danik/Backups/SFU-site-iteration-20261018/fields-portico-pre-consolidation.

# Phase 2 handoff — 2026-10-18

## Resume here
Read git status/log and this file. Canonical project outer game/. Last implementation checkpoints:2d0ca64 (Shell courtyard) and560b2cf (Beedie Field). Later documentation checkpoint adds Courtyard evidence and this handoff. Do not recopy Phase1, redo completed photo indexing or reopen mouse troubleshooting without a new failure.

User explicitly confirmed mouse works. Preserve current Windows Raw Input helper and host key forwarding, default fullscreen/Windows-primary monitor, escape/focus-loss release. Same Linux Godot4.7.2 Standard/GDScript/Compatibility stack; no dependency installation. Physical testing of all six forwarded keys was not separately confirmed by the user, but HostMovementQA passed previously.

## Next concrete development increment
Courtyard exterior portico/undercroft. Read the final2026-10-18 section of PHASE2_COURTYARD_PHOTO_REVIEW.md and the three new URL records in reference_photos/Courtyard_Residence/ONLINE_REFERENCES.json. Visually inspected DIALOG images0027,0058,0063 establish different court-facing and street-facing covered spaces; do not apply one guessed gallery height to the entire building.

Start with the photo-supported eastern portico under the glazed highrise end. Inspect CourtyardExterior.gd shell/facade generation: it currently closes ground floors, with separate highrise/lowrise/atrium zones. Preserve outer footprint, highest roof, all original coordinates and residential closure. A shallow exterior cut requires matching shell, lower facade, return-wall and collision changes, capped recesses, piers and soffit. Test new exterior traversal, inner closed wall, overhead collision and all existing routes. Validate against an eye-level east capture before extending to the courtyard-facing undercroft. User says bridge faces West Mall; do not place it toward the courtyard. Existing generic canopy is not evidence of an actual bridge object.

Further priorities: North gallery parking stairs; McTaggart descending approach; Shell annex/pergola/stairs/trees and grade exposure; East/West site stairs and basketball court; more hardscape and planting. See PHASE2_SITE_WALK_CORRECTIONS.md for full user request. Never remodel approved East/West merely to match old Street View. Modern Courtyard was absent in older imagery; McTaggart and paving also changed.

## What changed this iteration
ShellCourtyard.gd adds photo-derived fence and concrete round tables/curved seats, plus a narrow walk. Form based on user1773695185556.jpg and Shell.jpg; western placement, dimensions, count and spacing are estimated. A table initially blocked original route250,100 and was relocated; unchanged original route subsequently passes. Narrow east-west path remains open through a wide screen gap. Shell facade/roof/pads untouched. Exact entry and exposed floor count remain unresolved. See PHASE2_SHELL_REVIEW.md.

BeedieField.gd uses OSM way32528092 outline, official SFU Athletics description and historical Jasper Chan panorama uploaded2012. Adds original turf, infield, warning-track, screen/backstop, six static lighting poles, approximate open-sided shelters and simplified scoreboard. Baseline/pitch distances and fixture positions are modeling assumptions, not surveyed values. Dugouts are not yet correctly sunken; bleachers, bullpens, batting cage, concession, actual approach paving and detailed surroundings remain missing.

scripts/build_beedie_grade.py writes a separate1997-sample reversible layer, target0.48m median of existing terrain. Flat playing surface,3m collar,14m smooth blend; building4m exclusion plus protection ramp. Original terrain_grid unchanged. Runtime study boundary unions original outline with field8m buffer; no field clipping/moving. Source projected file intentionally remains an unmodified pre-implementation record; runtime game/data/beedie_field.json says implemented. See PHASE2_BEEDIE_FIELD.md.

## Verified state and commands
/tmp/beedie-verification.log passes191 physics checks,358 route checkpoints,376 terrain-ray parity samples,0 failures. All original routes pass, plus Shell7-point opening route and Beedie10-point gate/outfield route. Runtime/family validators pass, unchanged approved architecture and original geographic records. Last later edit changes turf noise only.

/tmp/shell-courtyard-final-capture.log and /tmp/beedie-final-capture.log complete on GTX1650 Compatibility. Inspected final shell_3 and field_1, plus initial field_0/field_3. Headless import is not visual fidelity proof. No isolated FPS claim. Field fence uses simplified square grid; site boundary hedge remains a study-limit artifact outside outfield.

Run interactively: bash scripts/run_game.sh . Restart an older game process to see changes. Focused capture: bash scripts/run_game.sh -- --capture-field (4views), or --capture-shell (5views). Full regression when geometry changes: bash scripts/verify_game.sh . Validators: python3 scripts/validate_runtime_data.py ; python3 scripts/validate_families.py ; python3 scripts/validate_photo_reference_index.py . Do not repeat full regression for documentation-only changes.

## Preservation and source handling
Mouse, approved East/West master/FacadeKit and pads, shared townhouse master, North longitudinal passage direction, original19building XZ and source elevations protected. Full preconstruction parking lot explicitly user-approved. Original nested game remains rollback; obsolete nested Markdown cleanup was completed earlier. No NPCs/interiors/API integration.

46local photos individually indexed; no copyrighted photo pixels shipped. Shell Street View visually inspected only (June2015,2011 alternative); used for orientation caveat, not modern reconstruction truth. Official Shell plan link redirected to CAS and was not bypassed. Additional Courtyard/Beedie images retained as URL metadata only.

Untracked user/source files preserved: FILE_MANIFEST.json, vehicle source zip and Zone.Identifier, historic_maps/, reference folder .gitkeep files and reference_photos/README.md. HostMovementQA.gd.uid was generated by import and can be committed with that existing script. One-off metadata helpers archived outside workspace at /home/danik/Backups/SFU-site-iteration-20261018. Original and pre-final consolidated status/handoff copies are also there.

Latest host usage reading87% consumed while preparing final checkpoint. Stop here for this window; next user-started iteration revokes this stop instruction. Five hours is quota reset, never a development deadline. No automatic reset wait/resume configured.

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

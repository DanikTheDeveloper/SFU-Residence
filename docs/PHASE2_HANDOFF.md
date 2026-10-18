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

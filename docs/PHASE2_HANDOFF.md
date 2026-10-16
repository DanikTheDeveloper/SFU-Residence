# Phase 2 current handoff — 2026-10-16

## Resume here
Current working tree has verified camera/townhouse/Courtyard refinements beyond9def9f1; save checkpoint before further geometry edits. Read PHASE2_STATUS.md and PHASE2_TOWNHOUSE_DETAIL_PLAN.md. Do not restart migration or recopy nested game.

Camera is user-confirmed: “Full turns work; no blinking.” Native capture and separate yaw/pitch replace rejected manual warping. Preserve this implementation.144 checks and all333 walking checkpoints pass in /tmp/sfu-townhouse-checkpoint.log; screenshots from /tmp/sfu-townhouse-checkpoint-capture.log inspected. Detailed townhouse frontage is view_7.png. Old pointer_qa.json tests the REJECTED warp version; do not use it to claim current native capture verification. Current evidence is automated checks plus explicit human feedback.

## Immediate next work
Continue townhouse exterior detail from user-selected images: angled bay side glazing, balcony side bars, masonry texture and porch-post ground contact/collisions. Keep each change independently verified. No East/West changes. Exact unit layout and lower common annex need plan-to-world mapping; do not label current approximate modules fully surveyed.

## Research already completed — do not repeat
All7 user townhouse images inspected. Official PDFs for all9 blocks located and ground pages visually reviewed. Chilcotin upper pages show common annex absent above ground. Temporary PDF/render copies in Windows Temp/sfu-townhouse-plan-review; not redistributed. Persistent observations/URLs in data/townhouse_plan_observations.json and online_reference_index.json. Page-left/right are not compass coordinates. Plan labels01-99 conflict with webpage96 total. Common rooms are numbered but laundry function not explicitly labelled.

New Hamilton1638917139878.jpg has readable sign, plus1726522334676.jpg confirms four-storey siding/window composition. North Photo-03-1024x672.jpg shows open ground-level passage/columns;1790722544125.jpg shows glazed stair/lounges and concrete framing. Detailed deferred tasks in townhouse plan document. User requests building-by-building work over many iterations, townhouse detail first this run.

## Safeguards
East/West master and FacadeKit hashes in data/east_west_preservation.json must remain unchanged. Original registry/routes/site exact equality is tested. Terrain source+iteration1 baseline retained; rebuild build_terrain.py THEN smooth_terrain.py. Rejected3m pad margin caused QUE/QUA obstruction; accepted margin.35m plus threshold pins. External obsolete-doc backup /home/danik/Backups/SFU-Residence-Phase1-docs-20261016, manifest verifies29 records. Nested original runtime retained.

## Commands
bash scripts/run_game.sh
bash scripts/verify_game.sh
python3 scripts/validate_families.py
bash scripts/run_game.sh -- --capture

No dependency installation. Automatic captures disable player controls and move cameras; labeled accordingly. Use normal launch to test input. Remaining generic landscape/stairs, three distinct building models, Courtyard wing heights and fine site grading are not complete. No interiors/NPC/API.

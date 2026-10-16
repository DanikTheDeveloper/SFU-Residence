# Phase 2 current handoff — 2026-10-16

## Resume here
Townhouse/camera/Courtyard checkpoint is2af9346. Current North milestone adds153 passing physics checks including three passage traversals and all333 continuous route checkpoints. Read PHASE2_STATUS.md and PHASE2_TOWNHOUSE_DETAIL_PLAN.md. Do not restart migration or recopy nested game.

Camera is user-confirmed: “Full turns work; no blinking.” Native capture and separate yaw/pitch replace rejected manual warping. Preserve this implementation.144 checks and all333 walking checkpoints pass in /tmp/sfu-townhouse-checkpoint.log; screenshots from /tmp/sfu-townhouse-checkpoint-capture.log inspected. Detailed townhouse frontage is view_7.png. Old pointer_qa.json tests the REJECTED warp version; do not use it to claim current native capture verification. Current evidence is automated checks plus explicit human feedback.

## Immediate next work
User now accepts townhouse appearance and requests Barbara/Pauline/Shadbolt next. Preserve current townhouse visuals; incomplete common annex/unit mapping stays deferred. Read PHASE2_NORTH_TOWER_REVIEW.md. Continue North stair-core facade/glazing and entrance photo study, then refine estimated passage location. Current helper cuts real exterior collision openings and adds side walls/soffit; no interiors. Do not touch East/West or user-confirmed camera. Final eye-level captures completed and reviewed, including view8 with concrete paving.


## Research already completed — do not repeat
All7 user townhouse images inspected. Official PDFs for all9 blocks located and ground pages visually reviewed. Chilcotin upper pages show common annex absent above ground. Temporary PDF/render copies in Windows Temp/sfu-townhouse-plan-review; not redistributed. Persistent observations/URLs in data/townhouse_plan_observations.json and online_reference_index.json. Page-left/right are not compass coordinates. Plan labels01-99 conflict with webpage96 total. Common rooms are numbered but laundry function not explicitly labelled.

New Hamilton1638917139878.jpg has readable sign, plus1726522334676.jpg confirms four-storey siding/window composition. North Photo-03-1024x672.jpg shows open ground-level passage/columns;1790722544125.jpg shows glazed stair/lounges and concrete framing. Detailed remaining townhouse tasks are saved in townhouse plan document. Latest user steering prioritizes North after accepting townhouse appearance.

## Safeguards
East/West master and FacadeKit hashes in data/east_west_preservation.json must remain unchanged. Original registry/routes/site exact equality is tested. Terrain source+iteration1 baseline retained; rebuild build_terrain.py THEN smooth_terrain.py. Rejected3m pad margin caused QUE/QUA obstruction; accepted margin.35m plus threshold pins. External obsolete-doc backup /home/danik/Backups/SFU-Residence-Phase1-docs-20261016, manifest verifies29 records. Nested original runtime retained.

## Commands
bash scripts/run_game.sh
bash scripts/verify_game.sh
python3 scripts/validate_families.py
bash scripts/run_game.sh -- --capture

No dependency installation. Automatic captures disable player controls and move cameras; labeled accordingly. Use normal launch to test input. Remaining generic landscape/stairs, three distinct building models, Courtyard wing heights and fine site grading are not complete. No interiors/NPC/API.

Latest actual usage snapshot84% five-hour/91% weekly: finish this safe checkpoint and stop. Resume only on user instruction.

North checkpoint visual QA: final GUI launch/capture completed without script errors; view4 facade and view8 through-passage inspected. Concrete paving follows terrain without collision changes. Full physics153/153 and route333/333 passed before the final cosmetic paving addition; final renderer launch validates that addition. No claim of fully photo-matched North architecture: columned undercroft, stair-core treatment and entrance detail remain in PHASE2_NORTH_TOWER_REVIEW.md.

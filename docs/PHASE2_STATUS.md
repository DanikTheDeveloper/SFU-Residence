# Phase 2 status — 2026-10-16, current verified checkpoint

## Locked stack and safeguards
Outer game/ is canonical. Godot4.7.2 Standard, GDScript, Compatibility, Debian WSL2, GTX1650. No engine/renderer changes or installed dependencies. Original19 footprints, roads and site JSON preserved exactly. Original nested runtime remains rollback;29 obsolete nested Markdown files externally backed up, hash-verified and removed.

## Camera — confirmed by user
Removed manual WSL pointer warping after user reported blinking. Native captured relative mouse motion, yaw-only pivot and pitch-only camera now support full turns without mixed-axis feedback. Accumulated-event tests explicitly flush queued input.144 runtime checks pass, including full turns and upright camera at pitch limits. User tested latest gameplay and replied: “Full turns work; no blinking.” Keep this input implementation stable.

## Terrain — verified
160 constrained diffusion passes, no vertical scaling; original source/datum/pad heights retained. All19 threshold levels pinned. Smooth ground normals. All333 continuous route checkpoints and376 terrain/collision parity samples pass. Townhouse95th-percentile sampled slope reduced46.1% to22.2%. Broad hillside retained. Exact civil grades/retaining walls still provisional.

## Architecture — verified current state
- East/West: user-approved facade master and shared material kit unchanged; hashes protected. Do not remodel/recolor.
- North: shared facade now has broader concrete panels, projecting lounge glazing and actual open exterior passages with side-wall/soffit collision.153 physics checks and333 route checkpoints pass. Dimensions and per-building passage positions remain estimated; see PHASE2_NORTH_TOWER_REVIEW.md.
- Townhouses: shared blue-siding house modules with individual red doors, paired mirrored porches, white posts/eaves, masonry base, projected middle windows and upper balconies. Removed obsolete generic block entrance/canopy. Smoke,144 runtime checks,333 route checkpoints and human-eye-level captures pass. Detailed frontage: game/docs/screenshots/view_7.png. Exact11-unit positioning and low common annexes still unresolved in world coordinates.
- McTaggart-Cowan: distinct renewed-envelope model, verified contractor reference; charcoal brick, bronze windows and grey fascia/connector. Geometric details estimated.
- Courtyard: distinct ribbed precast facade, architect reference; eleven-floor uniform massing remains a known mismatch with lower wings. Final entrance cleared of repeated facade piers; verified launch/capture.
- Hamilton: new photo has readable Hamilton Hall sign, resolving prior identity doubt. Detailed model pending.

## Research and next work
Prioritize user photos. All nine official townhouse ground-floor drawings visually reviewed; Chilcotin upper floors also reviewed with existing bundled Poppler. Plans show11 numbered houses per block, common-room end variants and paired porches; current SFU webpage total96 conflicts with plan numbering01-99. Do not invent operational count. All source URLs, observations and limitations saved in data/townhouse_plan_observations.json, data/online_reference_index.json and PHASE2_TOWNHOUSE_DETAIL_PLAN.md. User photos are reference-only and not shipped as textures.

User accepts current townhouses and requests North next. Preserve townhouse appearance. Next: North stair-core material/glazing and evidence-backed entrance detail, then refine passage placement. Later: townhouse common-annex mapping, Hamilton unique model and remaining buildings. No interiors/NPC/API code.

Run: bash scripts/run_game.sh. Full check: bash scripts/verify_game.sh. Automatic capture windows are labeled controls-disabled; use normal launcher for gameplay. Capture performance is viewpoint/resolution dependent, not a formal benchmark.

Latest actual account snapshot:84% five-hour and91% weekly used. Finish current verified checkpoint and hand off; do not predict reset duration or automatically resume.

North checkpoint visual QA: final GUI launch/capture completed without script errors; view4 facade and view8 through-passage inspected. Concrete paving follows terrain without collision changes. Full physics153/153 and route333/333 passed before the final cosmetic paving addition; final renderer launch validates that addition. No claim of fully photo-matched North architecture: columned undercroft, stair-core treatment and entrance detail remain in PHASE2_NORTH_TOWER_REVIEW.md.

## North courtyard correction — latest continuation
All9 user photos reviewed, SBH sign positively identified, per-photo reference index saved. Replaced estimated narrow side-wing tunnel with photo-supported broad central columned undercroft; added white lower window panels, glazed lounge returns, screened stair-core ends, North-only subtle concrete texture and framed double entrances. Exact dimensions/end handedness still estimated.156 physics checks pass;333 routes passed after opening relocation. E/W and original registry/pads protected. See PHASE2_NORTH_TOWER_REVIEW.md for current limitations and next work. Visual capture completed on Compatibility GTX1650; view8 undercroft and view9 entrance reviewed. Cosmetic panel-depth/fin corrections included. Previous instruction to pause at91% was superseded by user's explicit continuation; do not interpret old usage snapshots as current quota.

Next research finding: official Level2 plans show central lounge projection and projecting stair end west for BRH/SBH, east for PJH. Current end-lounge approximation must be corrected next; keep ground undercroft layout explicitly estimated because Level1 is absent. Sources saved in North ONLINE_REFERENCES.json. Latest actual quota snapshot13% five-hour/2% weekly used confirms reset; prior91% does not apply.

# Consolidated exterior completion audit — 2026-10-18

Latest user instruction: work through all deferred remarks; preserve accepted geography, approved East/West and townhouse architecture, exact Godot/GDScript/Compatibility/WSL2 stack, working first-person mouse. This audit reconciles historical notes with current code; old pending wording is not proof something remains undone. Check off only after implementation and verification. See individual photo-review documents for evidence, uncertainty and licensing.

| Item | Actual baseline / remaining action | State |
|---|---|---|
| Mouse, infinite rotation, fullscreen primary monitor | User confirmed working; preserve host adapter and movement forwarding | Preserve |
| Phase1 promotion / obsolete Markdown cleanup | Already completed, rollback and external backups retained | Complete |
| Terrain smoothness / original hillside | Source-based smoothing and local grades implemented; refine abrupt forecourts and approaches without global flattening | Partial |
| Field4 black walk-in shelter | User confirmed long end shelter and front fence. Enterable shelter/apron/front fence implemented; dimensions remain estimates. 221 physics/394 routes passed in157317b | Verified first pass |
| Field4 realism | Sideline concrete, fence, light poles and shelters added in157317b. Seating, secondary markings, fixture precision and tree edge still incomplete | Partial |
| Field2 realism | Mapped grass/H goals; strengthen photo match, surroundings and approaches; American-yard markings unconfirmed | Partial |
| Beedie realism | Outline/infield/backstop first pass; sunken dugouts, benches/bleachers, bullpen, batting cage, fixture/track geometry | Partial |
| North longitudinal gallery | Closed connector prisms and grounded piers added;12 joint rays and six joint views supplement prior rear-wall checks.266 physics/463 routes pass. Exact connector architecture remains estimated; no residential void reproduced in inspected views | Supported continuous gallery; photo detail partial |
| North to Dining Commons | Two-flight stair plus guarded upper turn now connects to mapped west door10785299803. Ascent/descent13/13 and landing turn11/11 passed; eye-level inspected. Dimensions/finish estimated | Verified first pass |
| North gallery to parking | Mapped OSM1159793611 stair with rails/landings added; descent/return13/13 passed and eye-level reviewed. Width/count estimated; separate from Dining and courtyard photo | Verified first pass |
| North surrounding details | Red service doors, roof/fins, curved beds, pavers, drains, stairs/rails, door/sign localization | Partial |
| Courtyard east portico | Implemented and traversable; eastern forecourt now locally graded and paved with curbs/tree pits,434-route checkpoint passed; road-edge transition still unfinished | Partial |
| Courtyard inner gallery | Lower court-facing recess, piers, soffit fins, closed rear glazing, grey pavers added; physical entry/crossing/exit passed. Dimensions estimated | Verified first pass |
| Courtyard West Mall bridge | South-facing glazed exterior link now tied to mapped West Mall parkade edge; inspected/physics passed. Exact attachment and far-end support provisional; full parkade unmodeled | Verified first pass |
| Courtyard landscape/upper details | Eastern pavers/curbs/four young trees added; road tie-in, lowrise terrace/penthouse and precise entrance mapping remain | Partial |
| Shell surrounds | North timber screen/concrete tables retained; glazed annex/sloped roof/timber pergola added from Shell.jpg with11point walk test. Photo-based blue emergency-phone/light added and eye-level inspected. Exact surrounding stairs/grade/trees still pending | Partial |
| Shell grade/entry | Mapped main entry6925149272 implemented on long west frontage with asphalt approach;7point route passed. Four total vs three visible floors and corner screen remain unresolved | Partial |
| McTaggart approach | User confirms west connector closer to East Tower. Fitted photo entry, descending stair/rails,52-sample local grade, boulders/planting and route tie-in;284 physics/506 routes pass. Exact curved lobby and three-visible/four-total floor conflict remain | Verified estimated approach |
| East/West site | Approved facades frozen. Two adjacent hoops, three terraces, mapped switchback ramp/stairs, picnic tables and lower descent now implemented;279 physics/495 routes pass. Exact finishes, orientation and heights estimated; user topology confirmed | Verified provisional landscape |
| Townhouse contact | Foundation/porch footings implemented; refine approach grades; preserve approved family | Partial |
| Townhouse plan differences |11-house door mapping/common-room annex and laundry attachments not implemented; block identity needed | Deferred evidence |
| Hamilton | Distinct model implemented; secondary east door, exact portico geometry and ground plan remain uncertain | Partial |
| Dining architecture | Old/new distinct wings implemented; current as-built finish, roof steps/joint, screens/service doors need comparison | Partial |
| Parking | Full preconstruction lot grade and CC0 cars implemented; verify curb/aisle/vegetation/perimeter realism | Partial |
| General outdoor materials | Concrete/pavers/asphalt overrides implemented; drainage channels, retaining walls, transitions still incomplete | Partial |
| Vegetation | Added331 batched context trees in mapped sports woodland, field/path buffers, coarse distant foliage. Species/spacing estimated; realism still incomplete | Partial |
| Performance | GTX1650 Compatibility runs; broad views slow, prior captures may share GPU with another game instance | Measure/optimize |

Source audit: all docs/*.md searched for pending/remaining/unresolved/unknown/next markers; read latest HANDOFF plus SITE_WALK_CORRECTIONS, PHOTO_REFINEMENT_BACKLOG, NORTH_PLAN_AUDIT, LANDSCAPE_PHOTO_REVIEW, DINING_REVIEW and relevant runtime modules. Historical plans/floor-count conflicts remain uncertainties rather than authorization to replace approved models. No interiors, NPCs, online API or unrelated gameplay.

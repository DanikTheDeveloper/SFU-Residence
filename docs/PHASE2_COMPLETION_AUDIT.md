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
| North longitudinal gallery | Correct under long courtyard wing; repeat eye-level inside-wall/corner audit, no exposed building voids | Recheck |
| North to Dining Commons | Two-flight stair added from Shadbolt gallery toward Dining west wall; ascent/descent13/13 passed. Dimensions estimated; exact upper door/landing tie-in pending | Verified first pass |
| North gallery to parking | Mapped OSM1159793611 stair with rails/landings added; descent/return13/13 passed and eye-level reviewed. Width/count estimated; separate from Dining and courtyard photo | Verified first pass |
| North surrounding details | Red service doors, roof/fins, curved beds, pavers, drains, stairs/rails, door/sign localization | Partial |
| Courtyard east portico | Implemented and traversable; forecourt remains crude grassy slope | Partial |
| Courtyard inner gallery | Lower court-facing recess, piers, soffit fins, closed rear glazing, grey pavers added; physical entry/crossing/exit passed. Dimensions estimated | Verified first pass |
| Courtyard West Mall bridge | User-confirmed direction; exact tie-in/grade not yet located; no existing dedicated bridge to merely move | Pending |
| Courtyard landscape/upper details | Paved plaza/curbs/planters/trees, lowrise terrace/penthouse and precise entrance mapping | Pending |
| Shell surrounds | Timber fence/concrete round tables implemented; timber seating if confirmed, stairs/landings, pergola/annex/trees | Partial |
| Shell grade/entry | Four total vs three visible floors, entry along long frontage, corner screen localization | Unresolved |
| McTaggart approach | User confirms Dining-facing approach. Current pad flattened the approach (~0.1m rise over28m); photo requires entry/grade correction before a plausible descending stair | Grade conflict; pending |
| East/West site | Approved facades frozen; verify external stairs and basketball court between towers, current paving | Pending |
| Townhouse contact | Foundation/porch footings implemented; refine approach grades; preserve approved family | Partial |
| Townhouse plan differences |11-house door mapping/common-room annex and laundry attachments not implemented; block identity needed | Deferred evidence |
| Hamilton | Distinct model implemented; secondary east door, exact portico geometry and ground plan remain uncertain | Partial |
| Dining architecture | Old/new distinct wings implemented; current as-built finish, roof steps/joint, screens/service doors need comparison | Partial |
| Parking | Full preconstruction lot grade and CC0 cars implemented; verify curb/aisle/vegetation/perimeter realism | Partial |
| General outdoor materials | Concrete/pavers/asphalt overrides implemented; drainage channels, retaining walls, transitions still incomplete | Partial |
| Vegetation | Added331 batched context trees in mapped sports woodland, field/path buffers, coarse distant foliage. Species/spacing estimated; realism still incomplete | Partial |
| Performance | GTX1650 Compatibility runs; broad views slow, prior captures may share GPU with another game instance | Measure/optimize |

Source audit: all docs/*.md searched for pending/remaining/unresolved/unknown/next markers; read latest HANDOFF plus SITE_WALK_CORRECTIONS, PHOTO_REFINEMENT_BACKLOG, NORTH_PLAN_AUDIT, LANDSCAPE_PHOTO_REVIEW, DINING_REVIEW and relevant runtime modules. Historical plans/floor-count conflicts remain uncertainties rather than authorization to replace approved models. No interiors, NPCs, online API or unrelated gameplay.

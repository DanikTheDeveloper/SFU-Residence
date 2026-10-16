# 11 — Objective visual review and screenshot registry

## Camera matching
For each comparison: record `camera_position_xyz`, `pitch_yaw`, `field_of_view`, `time_of_day/lighting`, building visible, facing facade, photo ID and known uncertainty. Baseline camera positions can be saved as in-game editor-only debug waypoints; camera itself in gameplay stays first person.

Minimum named QA views:
- At townhouse area looking toward dining route (slope visibility).
- Mid-slope looking uphill and downhill along concrete walkway.
- Parking area wide shot (it must clearly be an area, not parallel roads).
- Perimeter road showing only justified markings.
- Entrance-front, corner oblique and side elevation for pilot building.
- Ground-floor threshold: door location, connection with graded pavement.

## Rating dimensions (0—not reviewed, 1—wrong, 2—approximate, 3—matches available evidence)
| Dimension | Score | Evidence | Blocking issue |
|---|---|---|---|
| Footprint/identity |  | baseline/layout | Preserve accepted alignment |
| Relative grade |  | legal DEM/contour or user photo | Flat = blocking |
| Walkable terrain/collision |  | manual path walkthrough | Collision clipping = blocking |
| Path material/markings |  | known SFU reference | Lines on unmarked concrete = blocking |
| Parking lot shape |  | map/photo + entrance | Road-only = blocking |
| Pilot silhouette/floors |  | current photos + SFU | Wrong East/West era = blocking |
| Pilot facade colors/roof |  | image filename | Unknown if no photo |
| Pilot entrance orientation |  | image filename | Unknown if no photo |
| Pilot windows/geometry depth |  | image filename | Floating squares = poor |
| First-person camera |  | GUI test | Third-person = blocking |
| Performance |  | FPS on WSLg | Never guessed |

Source confidence and scores are independent. Do not raise score from 1 to 3 merely because a screenshot looks attractive. Mark a claim VERIFIED only when source evidence supports it; `PHOTO_OBSERVED`, `OFFICIAL`, `USER_REPORTED`, `APPROXIMATE`, `UNKNOWN` labels recommended.

## Shared archetype QA (additional mandatory gate)
- Open same `ModernTowerExterior` master resource from BOTH East and West instances, confirm an authorized master edit changes both, while independent parameter `floor_count` stays East=7 and West=8. Report computed `roof_top_world_y` and actual `foundation_world_y` for EACH and compare their difference with current roofline photography/terrain data; do not force artificial equality.
- For North Towers and townhouse later sessions, verify each maps to its ONE family resource and unique entrance/foundation override; no extra or duplicate building instances.
- Confirm user photos and screenshot scores are bound to specific building IDs rather than transferred automatically from siblings.
- Record family scene file path and instance override data in handoff.

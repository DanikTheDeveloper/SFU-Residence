# 21 — East/West roofline alignment: geography vs floor count

## User goals (do not discard)
- East and West look like the SAME modern architecture: one reusable model master.
- User reports both roof edges appear aligned in world space while foundations are on different grade elevations.
- User recalls West sits on higher ground and has one fewer floor than East.

## Conflict: preserve source distinctions
Official SFU records explicitly list East Tower = **7 storeys** and West Tower = **8 storeys**. See:
- https://www.sfu.ca/students/residences/housing-options/east-west-towers.html
- https://www.sfu.ca/students/residences/moving-in/insurance.html

The user's 'West one fewer' recollection conflicts with these records. Do **NOT** quietly change the source-confirmed model to East 8/West 7. Also don't dismiss the user's roof-alignment observation; treat it as a design target to verify against current photos/terrain measurements. Floor totals, local podium geometry, above-grade height and absolute roof height are different concepts.

If storey heights, roof trim and podium treatment were equal, roofs aligned in world Y would mathematically imply the *shorter* 7-storey East base is **higher** than the taller 8-storey West base by ~one storey. This is a conditional calculation, not a surveyed claim about which tower actually stands uphill. Site data and photo angles may reveal a different apparent alignment or storey-height configuration.

## Model / measurement pipeline
1. Retain the already accepted Phase1 world XZ footprints, orientation and stable IDs.
2. Locate/legal-check local city DEM/contour or user-provided site elevation information; measure foundation/entrance platform Y for EACH tower in ONE consistent vertical datum. Do not invent a grade direction.
3. Derive the model's roof-top *relative to its own base* from the actual storey/podium design. A simple decomposition `roof_y = foundation_y + sum(level_heights) + roof/parapet_offset` is valid; avoid double-counting amenity/podium floors.
4. Log `East_foundation_y`, `West_foundation_y`, `East_roof_world_y`, `West_roof_world_y`, `roof_delta_m = East_roof_world_y - West_roof_world_y`, `elevation_data_source`, `roofline_photo_ids`, `confidence`. UNKNOWN is an acceptable value until checked.
5. Compare viewpoints showing both towers and top edges. Perspective may make nonaligned real-world roofs look aligned; use camera matching or measured vertical data for a stronger conclusion.
6. Parametrize `foundation_world_y`, storey heights/podium, per-floor geometry, shared roof trim, and any justified local variants. If actual measured data show roofs align, represent it without stretching floors or floating foundations. If measurements contradict a visual assumption, document the discrepancy and ask user to resolve it.
7. Use per-tower instance parameters but a shared `ModernTowerExterior` source. Fix door sides only from identified photos, not inferred from the roof alignment.

## Minimum QA
- Exactly ONE modern tower master is referenced by BOTH East and West instances.
- East 7 / West 8 according to SFU official documents unless user later supplies stronger documentation proving a different configuration.
- Different local building foundations are allowed and do not disturb Phase1 XZ placement.
- Printed/logged world roof Y and ground Y values for each instance; roof delta is not assumed to equal 0 from a vague image angle.
- No equal-base hack, arbitrary global building offset, inverted floor count, or artificial hill slope to make the screenshot pretty.
- North Towers remain a separate shared 8-storey family and ALL photos live in `Barbara_Pauline_Shadbolt/`.

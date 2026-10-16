# 18 — Architectural families: model ONCE, instance MANY

## Why this phase has a different unit of work
User reports modern East and West Towers have substantially the same facade style, the three North Towers resemble each other, and the townhouse buildings use a repeated design. The canonical task is a high-quality **archetype master** then individual placed **instances**, NOT a hand-crafted mesh built from scratch for each tower or townhouse. Do not infer that modern East/West Towers and older North Towers share the same archetype merely because both are towers.

| Reusable family | Photo source | Scene master | Existing game instances | Mandatory differences |
|---|---|---|---|---|
| `modern_east_west` | `East_West_Towers/` | `ModernTowerExterior` | East, West | East 7 floors; West 8 (SFU). User reports globally aligned roofs; measure separate foundation Y and roof Y rather than assuming a common base |
| `north_towers` | `Barbara_Pauline_Shadbolt/` | `NorthTowerExterior` | Barbara Rae, Pauline Jewett, Shadbolt | separate building labels, access doors, orientation, grade, verified variant exceptions |
| `townhouses` | `Townhouses/` | `TownhouseBlockExterior` | actual Phase1 townhouse buildings (SFU historically nine blocks) | different world transforms, terrain, path and possible facade/roof variants |
| `dining_commons` | `Dining_Commons/` | unique | 1 | not a tower or townhouse |
| `courtyard_residence` | `Courtyard_Residence/` | unique | 1 | not a tower or townhouse |
| `shell_house` | `Shell_House/` | unique | 1 | not a townhouse |
| `hamilton_hall` | `Hamilton_Hall/` | unique | 1 | not a townhouse |
| `mctaggart_cowan_hall` | `McTaggart_Cowan_Hall/` | unique | 1 | distinct residence; not treated as a townhouse |

## Architecture implementation, adapted to EXISTING Phase1 code
1. Audit existing scene generator, IDs, transforms and building inventory. Do not duplicate objects or restart the map. Record each existing object's `stable_id`, XZ footprint, rotY, dimensions, entrance path and platform Y in `data/architecture_instances.csv` copied from the template. Do not manufacture identifiers except an internal consistent adapter mapping.
2. Implement a small common `FacadeKit` library for windows/recesses/mullions/doors/roof/parapet/podium walls/architectural bands/real material layers. **Do not just create more cubes**. Use reusable meshes and material resources. Compatibility OpenGL, GDScript only.
3. Implement a master archetype per visually repeated family, e.g. `ModernTowerExterior.tscn` and `ModernTowerExterior.gd` with explicit typed inputs `floor_count`, `storey_height`, `podium_levels`, `width`, `depth`, `facade_bay_count`, `wall_material`, `trim_material`, `entrance_side`, `entrance_offset`, `orientation`, `roof_variant`, `foundation_elevation`, `photo_verified_exception_flags`.
4. First fully refine ONE **representative instance** from photos, e.g. East. After validating the **shared architectural features**, apply the shared scene to West **only if** West matches the shared design. Recompute floors/height (7/8), actual scaled footprint and unique entrances; when West photos are missing use shared elements provisionally but mark entrance/color differences UNKNOWN. Never paste East entrance to West as if verified.
5. For North Towers, build ONE NorthTower archetype in a later pass, then apply to all three with per-building overrides. The official SFU building inventory lists 8 floors each; photos for individual buildings validate signage, doors, unique ground-floor conditions. All three buildings share ONE photo folder; label images by building ID. Do not call modern East/West and North one family.
6. For townhouses, derive ONE townhouse block shell from adequate photographs. Map onto each existing townhouse *block* by the actual existing Phase1 building identity. Don't instantiate one prefab at every apartment/door unless that is how the original building topology works. Record and preserve all terrain/footing and access differences. Repeat window geometry via instancing; allow parameterized roof and bay variations if shown.
7. Unique buildings: separate scenes/models each, with the same generic window/material library where appropriate. Shared generic materials are not proof of identical design.

## Reuse boundaries
- Shared = photo-supported structural language, recurring bay modules, verified material system, roofline language when observed.
- Instance override = 3D transform, exact footprint/height/floors, entry face/offset, ground-floor layout, access height, signage, special windows, facade variants and atypical roof sections.
- Do NOT normalize one tower's 8 floors down to 7, mirror a doorway accidentally, turn parking into building pads or flatten terrain for reusable prefab convenience.
- For high performance on GTX 1650 use texture/material reuse, conservative transparent surfaces, multi-mesh only when appropriate, and LOD/culling as practical. Verify Compatibility renderer behavior.
- Exported family/instance manifest should be machine-readable and editable without applying new template to all unrelated buildings.

## Acceptance tests / proof of actual reuse
1. One source asset/path per repeated archetype: building instances reference it; not copied individual scene geometry. Shared architecture changes propagate when master changes.
2. East and West both exist, retain geographic XZ, **correct distinct heights 7/8 floors** and **per-building door positions**. North Towers remain their *different* family.
3. Three North Towers' names and transforms stable; per-instance difference controls exist. Townhouses mapped only to original blocks.
4. Photo evidence uses actual `building_id`, not merely a family ID for features known to vary. Prototype supports missing photos without false VERIFIED claims.
5. Build can run before/after, Godot Compatibility respected, first-person and sloped terrain unbroken.

## Roof height invariants (modern tower family)
- Keep `floor_count` separately parameterized (East 7, West 8 from SFU).
- For every instance calculate `roof_world_y = foundation_world_y + actual_podium_height_m + upper_storeys_height_m + measured_roof_geometry_offset_m`, with care not to double-count floors. This is an illustrative decomposition; use the actual Godot builder's full level geometry.
- Compare the **world-space** roofline rather than forcing a common local tower `height`. The user observed matching roofs; validate against photos and measured/estimated terrain. No arbitrary Y hack or forced 1-floor terrain step.
- With equal full storey heights and common roof design, 7-floor East must sit about one storey **higher** than 8-floor West if the roofs truly align; this contradicts the user's recalled West-higher direction, which stays a documented question.
- Do not invent a measured foundation difference from those numbers; actual podium/ground-floor heights can differ. See `PHASE2_21_ROOFLINE_GRADE_AND_SOURCE_CONFLICT.md`.

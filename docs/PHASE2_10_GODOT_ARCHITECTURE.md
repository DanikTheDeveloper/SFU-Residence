# 10 — Surgical Godot implementation, not a total rewrite

## Preserve and extend the existing game
Inspect actual GDScript/tscn/data files in canonical `./game`. Keep their stable IDs and world XZ coordinates. Create an **appearance override** dictionary per building ID, architecture family IDs, parameterized instance data and a material registry; prioritize a new `TerrainController`/terrain mesh supplier and `SurfaceLayer` semantic categorization over rewriting all generators.

Suggested separation (adapt to existing architecture; do not blindly generate duplicates):
```
game/
  project.godot
  scenes/Main.tscn
  scenes/Player.tscn
  scripts/PlayerController.gd               # modify existing for FPS
  scripts/TerrainController.gd               # sample_height(x,z), collision mesh
  scripts/SurfaceController.gd               # semantic paths/parking/plazas
  scripts/FacadeKit.gd                       # shared geometry/material system
  scenes/architecture/ModernTowerExterior.tscn  # one master for East + West
  scenes/architecture/NorthTowerExterior.tscn   # later one master for north trio
  scenes/architecture/TownhouseBlockExterior.tscn # later shared across townhouse blocks
  data/building_appearance.json              # overrides with evidence IDs
  data/terrain_anchors.json                  # actual or provisional Y anchors
  data/surface_polygons.json                 # semantic circulation geometry
  docs/STATUS.md
```

Use exact scene paths actually present, not blindly the names above. Only introduce modules when it simplifies maintainability. Build geometry once and use shared meshes/materials. Procedural terrain and collision should share identical sampled height data. Rigid building footings on sloped terrain need pads/retaining walls, not pivot-only y-offset leaving door afloat.

## Coordinate invariants
- Store `origin`, `world_scale`, `north_vector`, rotation/flip and spatial extent in status.
- `X/Z` geometry is accepted: preserve world-space positions of significant anchors except verified corrections.
- If everything is positioned relative to a single root transform, don't apply world-space meters twice when migrating.
- A building altitude is its entrance/pad elevation; height of facade above foundation remains independent.
- `sample_height()` must match terrain visual mesh and physics collision; tests can check anchor-level y consistency.
- Roads/parking transform classification not location; keep continuity with old access connectors.

## Godot guardrails
- Godot 4.7.2 Linux Standard, GDScript, Compatibility. `project.godot` has `renderer/rendering_method="gl_compatibility"`; no `.cs`/`.csproj` and no forced Forward+.
- Use `Camera3D`, `CharacterBody3D`, `StaticBody3D`, collision shapes, reusable mesh resources. Avoid unnecessary imported addons and external texture dependencies. No first-person ↔ third-person switch.
- Source photos may be outside game root and not shipped unless rights documented; generated internal original materials are OK.
- Do not encode API keys or future AI provider in settings now. Reserve a future optional `DialogueProvider` integration point but none implemented.

## Small regression tests
1. Opens editor headlessly without parse errors (NOT visual proof).
2. GUI game starts, player spawns grounded, on main route, correct first person, no missing scene references.
3. Stable XZ building centroid comparison from before vs after export as feasible.
4. Walk from parking to townhouses to dining area; no unwalkable cliffs or submerged roads.
5. Reopen scene/save and repeat to detect runtime-only or import-only geometry.

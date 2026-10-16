# 15 — Godot 4.7.2 Standard + Compatibility Renderer implementation recipe

## Hard requirements
- Linux `Godot 4.7.2.stable`, **non-.NET**.
- Godot built-in GDScript only; don't generate a `.csproj`, `.sln`, C# scripts, NuGet packages or Mono dependencies.
- Select renderer **Compatibility** in the project. Prefer procedural low-poly forms with authored facades over imported giant scene assets.

## Required `game/project.godot` settings
Godot should generate the project in its normal format; **ensure at least**:
```ini
config_version=5

[application]
config/name="SFU Residences 3D"
run/main_scene="res://scenes/Main.tscn"

[rendering]
renderer/rendering_method="gl_compatibility"
renderer/rendering_method.mobile="gl_compatibility"
```
Godot 4.7.2 may write additional compatibility/driver keys depending on editor preferences and detected platform; that is acceptable. This sample is a minimal configuration pattern; validate with an actual engine run. Godot CLI can force `--rendering-method gl_compatibility` for debugging but settings must be correct without that flag.

## Recommended structure (Codex generates it)
```
game/
  project.godot
  scenes/Main.tscn
  scenes/Player.tscn
  scripts/PlayerController.gd
  scripts/ResidenceWorld.gd
  scripts/BuildingFactory.gd
  scripts/TerrainFactory.gd
  scripts/GeoTransform.gd
  scripts/HUD.gd
  data/buildings.json
  data/roads.json
  assets/materials/   # optional original materials only
  docs/STATUS.md
  docs/RESEARCH_LOG.md
  docs/ASSUMPTIONS.md
  docs/BUILDING_CHECKLIST.md
  docs/ATTRIBUTION.md
  docs/NEXT_STEPS.md
```
Godot `.tscn` scenes and procedural Geometry must survive a clean open/import with no editor-only plugin. Use `CharacterBody3D`, `SpringArm3D`/camera, `StaticBody3D` with collisions for buildings, `CollisionShape3D` for ground, and `WorldEnvironment` with Compatibility-friendly settings.

## Performance design
- GTX 1650 has several board configurations. Do not claim exact VRAM or guaranteed FPS without measuring in this WSLg configuration.
- Geometry budgets: prioritize footprint placement, distinctive silhouettes/facade colors. Batch or multimesh repetitive features judiciously; not hundreds of unique materials per window. Start with 512px–1K reusable textures (or pure materials), few transparent objects, small shadowed-light count, disable costly postprocessing.
- Keep buildings/vegetation in modular scenes with view-distance/culling hooks; use collision approximations and instance repeated props. Avoid heavy terrain plugins, GI, PBR tricks that require Forward+/Vulkan, proprietary FBX plugins, external terrain APIs.
- Height axis +Y, east +X, north -Z. One unit = one metre. Explicit coordinate origin and adjustable terrain elevations for SFU hillside (do not assume the entire precinct is flat).
- Controls: WASD move, mouse look, Shift run, Space jump (if appropriate), Esc release mouse. Add reset-spawn and debug building IDs for QA.

## Run commands from package root in Debian
```bash
# Linux binary search: godot / godot4 / custom GODOT_BIN
bash scripts/wsl_diagnostics.sh
bash scripts/smoke_test.sh

# When GUI/WSLg available, if binary resolves as godot:
godot --path game --rendering-method gl_compatibility
# For editor:
godot --path game --editor --rendering-method gl_compatibility
```
Do not interpret a successful headless import as proof of real camera behavior, facades, hardware acceleration or lighting.

## Godot 4.7.2 API discipline
Use documentation of the exact engine version. Avoid blindly copying Godot 3.x API names, hardcoded deprecated shader hints, or high-end renderer-only features. If parser reports an error, fix and run headless import again before further visual work.

Official references:
- https://docs.godotengine.org/en/stable/tutorials/rendering/renderers.html
- https://docs.godotengine.org/en/stable/tutorials/editor/command_line_tutorial.html
- https://godotengine.org/download/archive/4.7.2-stable/

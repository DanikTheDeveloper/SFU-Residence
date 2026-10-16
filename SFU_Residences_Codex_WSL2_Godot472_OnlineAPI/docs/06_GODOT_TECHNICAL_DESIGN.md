# 06 — Godot architecture, inputs, future-proof interfaces

## Recommended structure (adapt to reality)
```
game/
  project.godot
  README.md
  scenes/
    main.tscn
    player/player.tscn
    buildings/*.tscn
    environment/*.tscn
  scripts/
    player_controller.gd
    world_loader.gd
    building_factory.gd
    polygon_extruder.gd
    quality_settings.gd
    location_debug.gd
  data/
    building_manifest.json
    roads_and_paths.json
    source_provenance.json
    terrain.json
  assets/
    materials/
    meshes/
    textures/
  docs/
    RESEARCH_LOG.md
    ASSUMPTIONS.md
    STATUS.md
    NEXT_STEPS.md
    BUILDING_CHECKLIST.md
    ATTRIBUTION.md
```
A data-driven script + reusable `.tscn` can replace `.glb` for exteriors. Do NOT require Blender to run the game. Optional source generator scripts are appropriate.

## Input and player feel
Third-person chase camera by default, optional first-person toggle only if quick. Controls: WASD movement, mouse look, Shift sprint, Space jump, Esc cursor release, R respawn, optional M show small named debug map and Tab show/hide building labels. Sensitivity configurable, pitch limits, proper walking orientation. Gravity and slope handling. No wall clipping/camera penetrating buildings. Provide Help overlay.

## Game-world hierarchy
`Main`: WorldEnvironment, DirectionalLight3D, Ground, RoadsPaths, ResidenceBuildings (individual distinct nodes), Props/Vegetation, Player, CanvasLayer/HUD. Building collision stable and collider shapes aligned with actual mesh. Keep building material style and source metadata external to controller.

## Stable metadata interface (avoid speculative systems)
Store unique building ID/name, centroid, polygon points, height, height_provenance, generation tags, facade style, source license, and optional `npc_spawn_anchors: []`. **No actual NPCs created.** When the future implementation happens, another scene can iterate buildings and registered outdoor footpath anchors to create agents safely and cheaply.

## Performance tiers (GTX 1650 assumption)
- Initial target: 1080p with scalable settings; aim 45–60 FPS in exterior exploration on a typical desktop, **not a performance guarantee**. Profile on actual PC later.
- Quality LOW: fewer trees, low shadows, reduced draw distance, no screen-space expensive effects.
- MEDIUM: reasonable 1k facade textures, shadow resolution/culling and moderate vegetation.
- HIGH: modest foliage/shadows for stronger GPUs; do not make high mode necessary for visual accuracy.
- First priority VRAM for renderer. Online dialogue will use a remote API, so reserve GPU capacity for rendering; measure actual performance using the profiler.
- Scene streaming can be introduced later, not needed for a fairly small precinct if mesh/poly budgets are sensible.

## Tests and resilience
- `godot --headless --path game --editor --quit` (exact executable platform-dependent) checks imports/parser. For some versions choose `godot4` or installed executable; log which was used.
- Do a real game run if local graphical environment is available; use automated smoke script if headless process exit requires timeout. Check no missing scripts, undefined input actions, missing textures, or error spam.
- Build tests for coordinate transform (sign and scale), polygon triangulation, duplicate IDs, empty footprints, spawn on ground, building collision coverage, and all P0 named structures.
- In a clean clone, open the scene offline without accessing URLs or secrets.

## Binding 2026-10-15 WSL2 renderer/version override
Godot 4.7.2 Linux x86_64 **Standard**, **not .NET**; Debian under WSL2; GDScript; Compatibility renderer `gl_compatibility` (OpenGL3). Godot project must explicitly set renderer as specified in `docs/15_GODOT_COMPATIBILITY_RECIPE.md`. Never use Forward+ as a temporary shortcut. Avoid SDFGI, VoxelGI, SSIL/SSAO-dependent visual designs, compute shaders, GPU particle requirements, Vulkan-only materials, or Godot .NET packages.

Do not assume WSLg GPU performance based on GPU model alone: check renderer with Mesa `glxinfo -B` and benchmark the project on the user's system. See docs 13 and 16.

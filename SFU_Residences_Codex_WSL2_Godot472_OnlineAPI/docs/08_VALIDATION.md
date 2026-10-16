# 08 — Acceptance tests / definition of done

## Mandatory automated/manual verification
- [ ] `game/project.godot` exists, with main scene path set.
- [ ] Project loads in Godot 4 (verified when Godot is installed, otherwise explicitly unverified).
- [ ] Player appears on traversable ground and can move in 3D with mouse-look.
- [ ] Buildings block movement, roads/paths are traversable, player cannot enter building interiors.
- [ ] Every P0 building in `03_BUILDING_REGISTER.md` exists as a named world object, including **all nine townhouses**, East/West and Courtyard.
- [ ] Building story proportions are internally consistent; Courtyard ~11, East 7, West 8, older low rises ~3–4; North Towers floor discrepancy logged and resolved/estimated with evidence.
- [ ] Every important building has at least walls, differentiated windows/facade, roof and recognizable massing. No identical bare cube placeholder as *final* quality.
- [ ] Direct path connection across west townhouses, Hamilton, North Towers, MCH, East/West/Courtyard, Dining Commons, Shell House.
- [ ] Terrain/roads/buildings don't visibly float or intersect in obvious ways; neither player nor camera clips geometry regularly.
- [ ] No external network dependency at runtime; only locally packaged game assets are required.
- [ ] No unlicensed Google/SFU/Street View data included as mesh, texture, extracted screenshot or reconstructive tracing; license/provenance stated.
- [ ] No NPC/dialogue/API-key/relationship code implemented this time.
- [ ] Standalone dev README explains setup, run, controls, visual caveats, project layout.
- [ ] Documentation covers test results, sources, known gaps, FPS only when measured, and prioritized next improvements.

## Three manually inspectable walkthroughs
1. Spawn by Residence Lane; travel west to Hamilton Hall and named townhouses without any invisible walls.
2. Travel east to distinct East/West towers and Courtyard, then to the Dining Commons.
3. Turn south toward McTaggart/Cowan and southern lane/field edge, then loop back north.

## Quantitative sanity checks (use geodata where actually available)
- Every unique building ID present exactly once (unless a building deliberately has multiple sub-mesh components under one ID).
- No unexpected footprint 0 m², negative heights, reversed axes or thousand-kilometre offsets.
- No duplicate OSM source IDs assigned to unrelated buildings.
- Building heights based on levels are tagged `estimated_height_from_official_floor_count` unless explicit source height exists.
- Path traversal: at least 3 loops through grounds; gap checks and spawn-point ground test.

## Performance
Baseline target 1080p medium 45–60 FPS on GTX 1650-class machine; this is aspirational, NOT tested unless measured on equivalent actual hardware. Log resolution, graphics tier, GPU VRAM, CPU, scene draw calls and FPS where measurement is available. Provide LOW config for safer deployment.

## Grading guide
Layout/completeness 40%, silhouette/facades 30%, movement/world feel 15%, technical robustness 10%, documentation/provenance 5%. This intentionally weights **resemblance** above over-engineering systems not asked for.

## Mandatory WSL2 acceptance gates
1. Debian WSL2 environment actually inspected (not assumed); report `scripts/wsl_diagnostics.sh` output excluding private information.
2. `game/project.godot` explicitly sets Compatibility renderer, GDScript-only. No `.csproj`, C# sources, .NET requirement or Vulkan-only effects.
3. Linux **Standard** Godot 4.7.2 binary is used. If unavailable, tell the user honestly and give install steps; run static tests and label headless/GUI checks separately.
4. Run `bash scripts/smoke_test.sh` after game exists, save output in project docs; headless import + project quit + parser errors triaged.
5. If GUI works: start the actual scene via WSLg, inspect 3+ views and the renderer; if not, explicitly log NOT VISUALLY TESTED.
6. `glxinfo -B` renderer is recorded as GPU-backed or `llvmpipe`/unknown, and actual WSL performance not fabricated.
7. No key settings, HTTP calls or NPCs in initial build. No arbitrary internet access at runtime.

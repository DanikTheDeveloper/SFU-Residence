# Verified handoff — 2026-10-15

**Playable exterior prototype delivered.** All 19 required buildings and all nine
townhouses exist as named, collision-bearing 3D structures. This is a geographically
anchored, stylized reconstruction with explicitly estimated architectural detail;
it is not a photorealistic or surveyed 2026 as-built replica.

## Environment preserved

- Debian GNU/Linux 13 under WSL2; workspace stays on Debian's native filesystem.
- Existing `/usr/local/bin/godot`: `4.7.2.stable.official.ed1daf0bf`, Linux Standard.
- GDScript only; project explicitly selects `gl_compatibility` for desktop/mobile.
- Python, Git, curl and unzip were already installed. No tools were installed.
- Optional `jq`, `glxinfo` and Blender are absent. `glxinfo -B` was attempted and
  unavailable; it was not silently replaced with an assumed GPU result.
- Initial GUI launch reported Mesa **llvmpipe**, and rendered at roughly 5–9 FPS.
- Tested per-process launch using `/usr/lib/wsl/lib`, `GALLIUM_DRIVER=d3d12` and
  `MESA_D3D12_DEFAULT_ADAPTER_NAME=NVIDIA` reported **OpenGL 4.6, Compatibility,
  D3D12 (NVIDIA GeForce GTX 1650)**. `scripts/run_game.sh` applies these settings
  for its process only. No Windows/WSL driver changes or engine reinstall occurred.
- Driver reports that V-Sync mode changes are unsupported. This warning is retained
  in logs; it did not prevent launch/rendering.

## Delivered functionality

19 original procedural exterior models from named OSM polygons; windows, bands,
roofs, closed doors/canopies, plain name signs; 398 road/path segments, three parking
areas; terrain collision and gentle estimated grade; landscaping and props; original
third-person player with movement, sprint/jump, camera collision, respawn, help,
location display, remappable Godot Input Map, map, teleport cycling and graphics tiers.

Modular roots: Ground, Paths, Buildings, Vegetation, Props, Player, Lighting and UI.
Raw OSM and the adapted database are included with ODbL notice. No runtime network
access, NPCs, interiors, conversation systems or API credential handling.

## Verified results

| Check | Actual result / evidence |
|---|---|
| Supplied pack validator | PASS; `test_pack.log` |
| Supplied smoke test at initial/playable/architecture/final milestones | PASS after fixes; `test_initial.log`, `test_playable.log`, `test_architecture.log`, `test_final.log` |
| Stricter smoke/error scan | PASS; `scripts/verify_game.sh` catches parser failures even when engine exits zero |
| Geometry/coordinates/IDs | PASS: 19 unique source ways, nine townhouses, sane areas/heights, axis signs and metre scale; `test_geometry.log` |
| Player/physics | **86/86 PASS**: every anchor outside walls, ground hits, stable standing, all significant facade edges, 4.13 m walk sample, faster sprint, jump/landing, mouse look, wall blocking, spring-arm retraction, fall recovery; `verification.json` |
| Walkable connectivity | All 33,268 free cells connected on a 2 m clearance grid |
| Full controller walking loops | **3/3 PASS, 333/333 checkpoints**; actual CharacterBody3D movement with injected input, no teleport between loop checkpoints; `test_routes.log`, `routes_verification.json` |
| Clean-cache import and launch | PASS in a temporary independent copy without `.godot`; `test_clean.log` |
| Actual WSLg graphics | PASS with OpenGL Compatibility and observed GTX 1650 D3D12 device; `test_gui.log` |
| Actual WSLg automated physics | 86/86 PASS again with a real rendered window; `test_gui_physics.log` |
| Visual inspection | Rendered west/east/courtyard views, precinct overview and third-person spawn inspected; `screenshots/` |
| Human keyboard/mouse walkthrough | NOT performed; movement tests were automated engine input, not a human usability assessment |
| Windows export / 1080p benchmark | NOT performed; outside this session's release scope |

Three route loops cover: western townhouses/Hamilton; North Towers/Dining/Courtyard/
Shell/East; East/McTaggart/Hamilton. The generated routes are QA routes across safe
exterior ground, not claims about designated real-world pedestrian itineraries.

## Measured graphics sample

At 1280×720, medium (shadows, vegetation, 2× MSAA), after 50 warm-up frames, each of
three fixed views was sampled for 90 frames. Last recorded means: **34.9, 43.2 and
71.7 FPS**, with **241, 179 and 87 draw calls**. 95th-percentile frame times:
33.8, 27.6 and 17.0 ms. See `performance.json` for exact observations. This is a short
view-dependent sample, not a sustained 1080p benchmark or a guaranteed 45–60 FPS.
The third-person capture displayed 43 FPS. Low mode removes shadows, vegetation and
MSAA; it has not received a separate formal benchmark.

## Remaining issues and priorities

1. All facades are modular approximations. Obtain permissioned contemporary images
   and measured elevations before claiming accurate bay counts, cladding allocation
   or townhouse roofs.
2. Courtyard uses its full OSM outline at the 11-floor maximum. Its stepped volumes
   need refinement; Dining Commons' architect says 3 levels versus OSM's 2.
3. Terrain and entrance locations are estimates; real stairs/retaining walls and
   surveyed grades are not reconstructed. OSM may lag 2026 construction changes.
4. Improve sustained 1080p performance; current capture results are view-dependent.
   Hardware selection requires the supplied per-process launcher on this WSL setup.
5. Trees, lamps and parked cars are decorative; their placement is estimated and
   most do not block the player. Detailed roof equipment and custom landscape plans
   are not modeled. Hedges are an authored study boundary, not a real property fence.

See NEXT_STEPS for ten ordered improvements and BUILDING_CHECKLIST for per-building
provenance. Keep playability and the fixed stack while refining accuracy.

## Execution-plan gates

The prescribed sequence was followed: environment/read-through → runnable scene →
licensed footprints/paths → complete movement and collision → differentiated exterior
families → landscaping/performance → verification/handoff. Initial Overpass failures
were resolved through the direct OSM API. Tests caught parser type inference, five
anchors on facade edges, and the headless pointer-capture test limitation; all were
corrected before final validation. The five-hour limit was a maximum budget, not a
claim that five hours of work elapsed.

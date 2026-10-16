# SFU Burnaby Residences — playable exterior study

A complete 19-building, walkable **stylized prototype** in Godot **4.7.2 Linux
Standard**, **GDScript**, **Compatibility / OpenGL3**. Footprints and street/path
centre lines come from cached OpenStreetMap data. Facade details, height in metres,
terrain, entrances and landscape dressing are approximations, not a surveyed replica.

## Launch in Debian WSL2

From a Debian terminal:

```bash
cd '/home/danik/GitHub/SFU Residence/SFU_Residences_Codex_WSL2_Godot472_OnlineAPI'
bash scripts/run_game.sh
```

The launcher uses the existing `godot` and applies only per-process WSLg library /
D3D12 adapter settings. This was tested with NVIDIA GeForce GTX 1650. It changes no
system configuration. Set `GODOT_BIN` if your Linux binary has a different path.

```bash
bash scripts/run_game.sh --editor   # editor, same stack
# Direct engine launch is also valid, but selected llvmpipe on this machine:
godot --path game
```

No installation, network connection, API key, Blender, .NET or addons are required.
Open `game/project.godot` in the installed Linux editor. This is a Linux development
project, not a tested Windows export. Use the WSL filesystem location above.

## Controls

| Control | Action |
|---|---|
| WASD / mouse | Walk / third-person look |
| Shift / Space | Run / jump |
| Esc / left click | Release pointer / resume control |
| R | Return to the open Residence Lane starting area |
| M | North-oriented precinct overview; press again to walk |
| Tab | Building name labels |
| N | Visit next of 19 outdoor building approaches |
| F1 | Help |
| F2 | Medium / low graphics (low disables shadows, trees and MSAA) |
| `[` / `]` | Decrease / increase mouse sensitivity |
| Window close / Alt+F4 | Exit |

Actions are stored in **Project Settings → Input Map** and can be remapped there.
The control guide describes defaults. Buildings are solid exterior shells; all doors
are closed. The player is the only character. Hedges delineate the playable precinct.

## What's built

- All 19 named OSM footprints, including all nine townhouses, the three North
  Towers, East/West, Courtyard, Hamilton, McTaggart-Cowan, Shell and Dining Commons.
- Concave footprint extrusion, roofs, collision, modular facade windows, material
  bands, doors/canopies and signs; brick/copper-inspired modern towers, precast-style
  Courtyard, concrete halls and siding-style townhouses.
- 398 road/path segments (379 OSM segments plus 19 estimated entrance connectors),
  three parking polygons, a gently graded terrain, southern field context, vegetation,
  lamps, benches, planters, parking markings and simple cars.
- Third-person capsule controller, collision-aware spring arm, walking animation,
  location HUD, overview, labels, reset, quality and sensitivity controls.
- Procedural original assets and MultiMesh facade/landscape batching. Fully offline
  runtime, with stable building metadata/outdoor anchors for future extension only.

## Verification

From the package root:

```bash
python3 scripts/validate_pack.py
python3 scripts/validate_world.py
bash scripts/verify_game.sh
python3 scripts/clean_import_test.py
# Controller-driven full precinct loops (fixed simulation step, headless):
godot --headless --fixed-fps 60 --path game -- --verify --routes
# Actual WSLg rendered captures and short performance samples:
bash scripts/run_game.sh -- --capture
```

The supplied `scripts/smoke_test.sh` was run at milestones. `verify_game.sh` adds
error-log checking because Godot can exit zero despite a script parser error.
See [STATUS](docs/STATUS.md) for actual results and [screenshots](docs/screenshots/)
for rendered views. Headless checks and GUI rendering evidence are reported separately.

## Editing and data

- `data/buildings.json`: stable IDs, raw-derived polygons, heights, facade palette,
  sources and confidence, estimated entrance and outdoor approach.
- `data/roads.json`, `site.json`: centre lines, widths, parking and playable boundary.
- `scripts/ResidenceWorld.gd`: composition, lighting and overview; `BuildingFactory.gd`:
  exterior generation; `Geometry.gd`: meshing; `PlayerController.gd`: movement;
  `SiteDetails.gd`: props; `HUD.gd`: interface.
- `scenes/Main.tscn` and `Player.tscn`: editable Godot scene entry points.
- `../scripts/import_site.py`: offline regeneration from cached OSM and the package's
  seed register. **Regeneration replaces data tuning**; commit custom edits first.
- `../scripts/fetch_osm.py`: uses cache by default; `--refresh` explicitly downloads
  a replacement. Review new source geometry before regenerating.

See [building checklist](docs/BUILDING_CHECKLIST.md), [assumptions](docs/ASSUMPTIONS.md),
[research](docs/RESEARCH_LOG.md), [attribution](docs/ATTRIBUTION.md) and
[next steps](docs/NEXT_STEPS.md). The OSM-derived database is provided under ODbL 1.0.
No third-party reference photographs or Google imagery are included in the game.

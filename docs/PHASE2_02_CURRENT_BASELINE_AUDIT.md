# 02 — Baseline audit before the first modification

Within the first 20–30 min, walk the existing scene, take screenshots at consistent locations and note these unknowns. Do not guess them from package source; user tested locally.

| Component | Audit evidence | Expected adjustment |
|---|---|---|
| XZ buildings | Screenshot + source data/centroids | PRESERVE unless demonstrably wrong |
| Y heights | Are paths/footings uniformly Y=0? | Terrain/surface model |
| Camera | Existing controller and actual view | FIRST PERSON only |
| East/West Tower | IDs/names/floor counts/door side, shared modern family | Source-verified geometry; different per-instance entrances |
| Townhouse→Dining path | Actual elevation/collisions | Slope, transitions, stairs if present |
| Parking area | Current road objects | Polygon lot, stall geometry only if observed |
| Pedestrian paths | Markings, rough widths, material | Unmarked concrete/pavers |
| Perimeter road | Markings only where verified | Asphalt/vehicle lanes |
| Performance | `glxinfo -B`, Godot renderer, FPS in scene | Baseline not prediction |

Run `python3 scripts/audit_game.py --root .` for a structural text inventory, then inspect actual scenes and gameplay visually. Regex inventory cannot prove color, door placement or geometry, so mark manual observations separately.

Maintain `docs/PHASE2_STATUS.md` with: `Baseline main scene`, `Godot --version`, `GPU renderer`, `Start command`, `Known defects`, `Chosen pilot`, `Sources/photos present`, `First-person verified`, `Outstanding blockers`. Photograph-based errors stay open until measured against labeled images.

Snap/revert early: do not simultaneously rewrite all building factories, terrain factories and player scripts. Preserve stable `building_id`, source metadata and node paths where possible. Verify at the beginning, after terrain, after path correction and at handoff.

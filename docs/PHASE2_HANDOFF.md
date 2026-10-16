# Phase 2 rolling handoff — iteration 1

Last verified: migrated Phase 1 outer game, supplied smoke passed, 86 physics checks passed, GUI GTX1650 Compatibility launch passed (2026-10-16).

Debian root: `/home/danik/GitHub/SFU Residence`; run `bash scripts/run_game.sh`. Main: `game/scenes/Main.tscn`. Rollback: `SFU_Residences_Codex_WSL2_Godot472_OnlineAPI/game` (runtime unchanged).

Obsolete nested instructions removed after validation, external backup and SHA256 verification. Backup `/home/danik/Backups/SFU-Residence-Phase1-docs-20261016`; exact inventory `docs/PHASE1_ARCHIVE.json`. Remaining legal/source records are historical evidence, not instructions.

In-progress: fixed 1.68m first-person camera replaces SpringArm/avatar. Gameplay overview toggle removed. Next command: `bash scripts/smoke_test.sh`, then `godot --headless --path game -- --verify`, then GUI capture. Review camera and input tests before checkpointing.

Then acquire licensed Burnaby contours and integrate terrain/collision/foundations preserving XZ; semantic surfaces/parking; photo-informed shared facade families. User photos exist; rights/identity not yet reviewed. No actual usage warning; continue useful work.

## Verified first-person milestone
Fixed 1.68m eye camera, no visible avatar or gameplay overview switch. Smoke passed; physics 87/87 passed. GUI capture inspected: first-person view confirmed, GTX1650 Compatibility. Screenshots in game/docs/screenshots; runtime tests in game/docs/verification.json. Manual physical mouse interaction remains unverified; synthetic look and movement tested. Next: licensed contour acquisition and terrain.

## Terrain checkpoint
Terrain is integrated and passes smoke / 87 physics checks; GUI captures inspected. game/data/terrain_grid.json is derived from cached City contours, with estimated modern pads. scripts/build_terrain.py rebuilds offline; scripts/fetch_contours.py caches full source. TerrainController.gd interpolates the rendered triangle diagonal. Geometry.polygon clips pavement to those triangles. Original 19 XZ footprints unchanged. Continuous route test running: /tmp/sfu-terrain-routes.log. Next inspect that log, fix any grade traversal failures, then semantic surfaces.

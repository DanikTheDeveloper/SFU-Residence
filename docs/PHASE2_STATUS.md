# Phase 2 — iteration 1, 2026-10-16

Canonical root: `/home/danik/GitHub/SFU Residence`; game: `game/project.godot`; main scene: `res://scenes/Main.tscn`.

## Verified checkpoint: migration and obsolete-instruction cleanup
- Promoted existing game without caches or overwriting nested rollback game.
- Supplied outer smoke test passed; unchanged baseline physics verification: 86/86 passed.
- GUI confirmed Godot 4.7.2 Standard, Compatibility, Mesa D3D12 NVIDIA GeForce GTX 1650. Unsupported VSync changes reported. Debian 13 / WSL2; glxinfo absent. Nothing installed.
- 29 obsolete nested Markdown files backed up externally with SHA256 verification, then deleted. Inventory: `docs/PHASE1_ARCHIVE.json`; backup: `/home/danik/Backups/SFU-Residence-Phase1-docs-20261016`.
- Nested runtime and legal/source records retained. Outer Phase 2 instructions alone are authoritative.
- Geography unchanged: origin 49.28035, -122.92769; metres; +X east, -Z north; 19 buildings, 398 route segments.

Current task: strict first person (implementation awaiting validation). Terrain remains Phase 1 estimated plane; surfaces/architecture remain approximations. Photos present, not inspected yet. Roofline conflict unresolved; East 7 / West 8 preserved.

Run: `bash scripts/run_game.sh`. Test: `bash scripts/smoke_test.sh`, then `godot --headless --path game -- --verify`.
No actual usage warning received. Five-hour interval is usage reset, not deadline.

## Verified first-person milestone
Fixed 1.68m eye camera, no visible avatar or gameplay overview switch. Smoke passed; physics 87/87 passed. GUI capture inspected: first-person view confirmed, GTX1650 Compatibility. Screenshots in game/docs/screenshots; runtime tests in game/docs/verification.json. Manual physical mouse interaction remains unverified; synthetic look and movement tested. Next: licensed contour acquisition and terrain.

## Verified contour terrain milestone
2,412 City of Burnaby 2014 contour features cached completely. Runtime 2m terrain grid, identical visual/physics triangle sampling, flat provisional building pads and terrain-clipped pavement. Smoke and 87 physics checks passed; GUI screenshots inspected. Continuous route test running. Roofline and modern grades remain provisional because source predates construction; see PHASE2_TERRAIN_EVIDENCE.md. First-person migration commit: f320f02. Next: route validation, semantic surfaces, modern family.

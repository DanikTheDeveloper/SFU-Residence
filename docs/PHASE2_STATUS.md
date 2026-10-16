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

## Verified surfaces and modern family milestone
SurfaceController preserves route/parking XZ, makes internal Residence Lane unmarked concrete, and removes all unsupported road centerlines. ModernTowerExterior.gd is one shared East/West master using FacadeKit.gd recessed glazing, mullions, cladding/spandrels, clerestory, curtain-wall bays and parapets. EAT photo identity confirmed by entrance signage in three supplied photos; WET transfer remains provisional. Bay widths/door orientation not surveyed. Smoke passed; 94/94 runtime checks passed, including 376 terrain/collision samples and live shared-master parameter changes propagating to both towers while retaining 7/8 floors. GUI captures inspected. Local foundations EAT=5.276, WET=1.547; roof tops EAT=27.196, WET=26.567m (difference 0.629m, NOT forced). Continuous first route passes 150/150; other loops still running. Next: inspect full routes, capture eye-level QA viewpoints, refine North family.

## Verified North family / parking / traversal checkpoint
NorthTowerExterior.gd now drives all three North Towers with independent 8-floor data, concrete fins and pale mullions; identity-specific door locations remain approximate. ParkingLot.gd lays out 83 estimated stalls aligned to the three mapped polygon areas; parked-car collisions avoid mapped circulation. 106 runtime checks pass, including family propagation. All three accelerated continuous walks now pass 333/333 checkpoints. A real Godot polygon-ray degeneracy at (-216.3434,62) caused a false boundary reset; replaced only the precinct boundary check with deterministic horizontal crossings and added inside/outside regressions. bash scripts/verify_game.sh passes smoke, physics, routes and data/backup invariants. GUI North and parking captures inspected. Next: shared townhouse master (new script not integrated yet), then unique-building evidence and visual/performance polish.

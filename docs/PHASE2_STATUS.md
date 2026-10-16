# Phase 2 status — iteration 2, 2026-10-16

Canonical project: `game/project.godot`. Godot 4.7.2 Standard, GDScript, Compatibility, Debian WSL2. No dependencies installed. GUI renderer verified as Mesa D3D12 NVIDIA GTX 1650.

## Completed and verified
- Migration and mandatory cleanup: 29 obsolete nested Markdown documents backed up outside the project with SHA256 verification and removed. Original nested Godot runtime retained. Inventory: `docs/PHASE1_ARCHIVE.json`.
- Original 19 building footprints, IDs, roads and site coordinates preserved exactly.
- Strict first person, 1.68m eye height; no third-person or gameplay overview toggle.
- Complete 2,412-feature City of Burnaby contour cache, 2m terrain mesh and matching collision; provisional foundations preserve the hillside. See `PHASE2_TERRAIN_EVIDENCE.md`.
- Shared East/West master, shared North master, and nine shared townhouse blocks. Townhouses include pitched roofs, siding, recessed frames, projected window bays and balcony details. Exact townhouse block identity and repeated bay placement remain approximate.
- Concrete pedestrian surfaces, three mapped parking polygons with 83 estimated stalls, parked-car collision clearances, and fixed precinct boundary containment.
- Townhouse details: smoke, 134 physics checks and 333 continuous-route checkpoints passed before iteration 2 camera changes.

## Iteration 2 work
- Mouse input moved to `_input`; unrestricted yaw, bounded pitch, physical relative motion. WSLg confined hidden pointer recenters to avoid screen-edge capture limits. Event-dispatch tests cross 360 degrees both ways. Native X11 test recorded 8.095 radians of rotation (over a full turn). Human physical-mouse feel still needs user confirmation.
- Terrain: constrained diffusion from immutable `data/terrain_sources/iteration1_grid.json`, adjustable `data/terrain_smoothing.json`, smooth ground normals. Source heights, datum, foundation metadata and broad hillside preserved; no vertical exaggeration multiplier.
- Initial filtered checkpoint passes smoke, 137 physics checks, all 333 route checkpoints and data/backup invariants. Eye-level townhouse and modern-courtyard screenshots inspected.
- Final threshold refinement passed smoke, 137 physics checks and all 333 route checkpoints. All 19 entrance samples equal their existing foundation pad levels; durable validator covers these contacts.
- East/West appearance protected by `data/east_west_preservation.json` hashes of the approved facade master and shared kit, plus original pad metadata. No remodel or recolor.

## Remaining work
- Terrain/camera/townhouse checkpoint saved as `730cc77`; final eye-level captures inspected.
- McTaggart-Cowan distinct 2025 renewed-envelope master implemented: charcoal procedural brick, bronze window surrounds, pale metal fascia, glazed connector and framed entrance. URL-only contractor provenance saved in `data/online_reference_index.json` and corresponding photo folder. Smoke, 140 physics checks and all333 route checkpoints pass; final entrance cleanup rechecked with140 checks and GUI capture. Bay/connector dimensions and four-storey uniform massing remain approximate.
- Next: Courtyard distinct facade from architect gallery, then remaining unique buildings and environmental polish.
- Hamilton supplied image identity remains uncertain; Dining photos depict older hall, insufficient for 2022 expansion. Courtyard and Shell need further specific reference work.
- Terrain 2014 predates redevelopment; modern pad levels and absolute vertical datum unresolved. Retaining walls/stairs and exact landscape grading still approximate. No unverified elevations presented as survey measurements.
- Performance varies by viewpoint; prior eye-level captures roughly 24–73 FPS. Repeat uncontended capture after final terrain work; no formal GTX1650 benchmark claim.

Run: `bash scripts/run_game.sh`. Full regression: `bash scripts/verify_game.sh`; family metadata: `python3 scripts/validate_families.py`.
No actual low-usage warning received. Continue useful exterior work; five-hour interval is a usage reset, not a deadline.

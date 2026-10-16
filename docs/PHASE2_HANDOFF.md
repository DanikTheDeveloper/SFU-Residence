# Phase 2 rolling handoff — iteration 2

Read `PHASE2_STATUS.md` for current verified scope. Outer `game/` is canonical; preserve nested rollback game and user photos.

Last committed checkpoint: `6c36512` (North family, parking, boundary fix). Working tree also contains verified shared townhouse details, mouse changes and terrain smoothing. Do not discard these or recopy the nested game.

## Immediate next operation
Final terrain threshold tests passed: smoke, 137 physics checks, all 333 route checkpoints, geographic/backup/protected-tower invariants. All 19 entrance contact levels match their pad heights; validator now checks all four surrounding corners. Final GUI capture is running at `/tmp/sfu-smoothed-final-capture.log`. Inspect captures, commit, continue McTaggart-Cowan.

Current terrain script: `scripts/smooth_terrain.py`, 160 passes, relaxation .65, pad margin .35m, explicit entrance corner pins. Rejected 3m margin caused steep QUE/QUA transition; do not restore. Immutable pre-smoothing grid: `data/terrain_sources/iteration1_grid.json`. No vertical scaling; all original foundation heights retained. To rebuild: `python3 scripts/build_terrain.py` then `python3 scripts/smooth_terrain.py` then full verification.

## Mouse fix
`PlayerController.gd` processes look in `_input`, only clamps pitch, uses screen-relative motion and WSLg recentering. Native X11 synthetic test helper `scripts/test_pointer_x11.py` targets only the named `--pointer-qa` window; latest saved result `game/docs/pointer_qa.json` shows >360 degrees. Headless dispatcher tests turn both ways. Physical mouse behavior is not manually verified. Avoid claiming exact pixel gain from host synthetic events.

## Architecture and references
User explicitly approves current East/West appearance: preserve `ModernTowerExterior.gd` and `FacadeKit.gd` hashes, colors, windows and entrances. North and townhouse families already implemented and tested. Next unique target: McTaggart-Cowan, verified in contractor gallery https://www.scottconstructiongroup.com/our-projects/mctaggart-cowan-hall-residences-envelope-renewal/ (August 2025 renewal). Browser screenshot matches local photo: charcoal brick, bronze tall narrow window frames, pale grey fascia, glazed entrance connector, descending steps. Save URL/provenance records; no image reuse permission established.

Hamilton local image identity unresolved. Dining local images may predate the 2022 expansion. Research official/architect sources, do not copy a generic tower onto unique buildings.

## Durable safeguards
External obsolete-document backup: `/home/danik/Backups/SFU-Residence-Phase1-docs-20261016`; manifest verifies 29 files. Original XZ registry/routes/site match nested baseline exactly. All19 building IDs retained. No NPCs/interiors/API.

Temporary one-shot scripts from integration are untracked; remove only known agent-created scratch files after checkpoint. User `reference_photos/`, `historic_maps/`, FILE_MANIFEST.json and unknown assets must remain.

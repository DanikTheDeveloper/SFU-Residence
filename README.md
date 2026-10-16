# SFU Residences — Phase 2, architectural-family refinement (OUTER ROOT)

## Change from prior Phase 2 ZIP
This is an **updated replacement overlay** for the same Phase 2 plan, not a new game. It corrects duplicated building work: a modern tower archetype for East + West; a separate North Tower archetype for Barbara Rae + Pauline Jewett + Shadbolt; one townhouse block archetype for all existing townhouse buildings. Distinct standalone building families remain distinct. User photographs now have reorganized folders. All earlier terrain/parking/first-person requirements remain.

## Install this ZIP
Extract its CONTENTS into your OUTER project folder containing the existing nested Phase1 game package. This ZIP has NO wrapper folder, NO replacement generated game, NO real photo files. If a previous Phase2 ZIP was unpacked into the outer folder, replace its Phase2 instruction/template files with these updated files but **never overwrite project game content, non-template data, your photos or user-modified status logs without reviewing differences**. To protect work already done, this archive contains only `docs/PHASE2_STATUS.template.md` and `docs/PHASE2_HANDOFF.template.md`: do not replace the live status/handoff files; initialize from a template only if they are absent.. This ZIP contains fresh `.template.csv` files only. Verify `pwd` is your outer working directory. Avoid unzipping into the old nested folder.

Expected layout:
```
outer/                       <-- open THIS folder in Codex
  AGENTS.md                  <-- latest instructions, authoritative
  CODEX_TASK_PROMPT.md
  docs/PHASE2_*.md
  data/architecture_families.json
  data/architecture_instances.template.csv
  scripts/promote_game.py
  scripts/relocate_legacy_photos.py
  reference_photos/
    East_West_Towers/        <-- ONE shared photo folder, clearly label East vs West
    Townhouses/              <-- one folder for all townhouse blocks
    Hamilton_Hall/
    Barbara_Pauline_Shadbolt/  <-- one folder for all three North Towers
    Courtyard_Residence/
    Shell_House/
    Dining_Commons/
    McTaggart_Cowan_Hall/
    Parking_and_Paths/
    Terrain_and_Stairs/
  game/project.godot         <-- canonical game, created by safe promotion if absent
  OldNestedPackage/         <-- untouched original Phase1, game/ + obsolete MDs
```

The existing Phase1 game geometry should NOT be replaced by the ZIP. No user photos are bundled. Original `North_Towers/{Barbara_Rae_House,Pauline_Jewett_House,Shadbolt_House}/` and `North_Towers_*` photo folders from earlier Phase 2 versions may remain on disk. Copy their photographs safely into `Barbara_Pauline_Shadbolt/` with `scripts/relocate_legacy_photos.py` (dry-run first) without deleting originals. Ignore the old folder layout after migration. If these old directories are EMPTY, you can leave them; Codex uses only the new layout.

## First run in Debian WSL2
```
cd ~/projects/YOUR_OUTER_DIRECTORY
python3 scripts/validate_phase2.py
python3 scripts/validate_families.py
python3 scripts/promote_game.py --root .           # dry-run; skip if game already canonical
python3 scripts/promote_game.py --root . --apply   # ONLY if game/ absent and source is correct
python3 scripts/photo_inventory.py --root .
bash scripts/check_wsl.sh
```
If you previously stored photos in old directories: `python3 scripts/relocate_legacy_photos.py --root .` dry-run, then `--apply` when happy. Tool does not overwrite or delete. `glxinfo -B` verifies hardware rendering; installing glxinfo alone doesn't guarantee hardware acceleration.

## Core docs
- `AGENTS.md` and `CODEX_TASK_PROMPT.md`: binding new task scope.
- `docs/PHASE2_18_SHARED_ARCHETYPE_PIPELINE.md`: how to implement reusable master scenes and per-building overrides.
- `docs/PHASE2_19_PHOTO_FOLDERS_AND_MIGRATION.md`: location and optional safe copy.
- `docs/PHASE2_20_FAMILY_SESSION_WORKFLOW.md`: priority-based architecture refinement across **five-hour Codex usage reset windows**, not 300 minutes of coding.
- `docs/PHASE2_22_USAGE_WINDOW_ITERATIONS.md`: maximize useful work per allowance, frequent durable checkpoints and safe resumption (no guessed quota).
- Existing `docs/PHASE2_03`, `_04`, `_07`, `_12` cover slope, surface types, first-person camera, WSL2 OpenGL.

**Constraints:** Godot 4.7.2 Standard Linux + GDScript + Compatibility renderer on Debian/WSL2. The real photo matching, game edits and model comparisons must occur inside Codex on the existing project; this package can't magically supply geometry from inaccessible local game assets. Future NPCs and online OpenAI API are strictly out of scope.

## Roofline/grade source discrepancy
You reported that East/West roofs line up, and that West sits higher but has one fewer floor. SFU officially documents **East 7 / West 8**, so the latter count/direction conflicts with records. The project keeps the official counts as sourced defaults, treats the aligned roofs as a photo-checkable target, and makes foundation Y/roof-top Y editable and separately auditable. With otherwise equal per-floor heights, matching roof heights would imply the 7-floor East building starts higher, not the 8-floor West. Do not override real grade to manufacture this relation. See `docs/PHASE2_21_ROOFLINE_GRADE_AND_SOURCE_CONFLICT.md`.

# Phase 2 handoff — 2026-10-17

## Resume here
Use outer game/ and current working tree. Latest committed milestone: 1df28b3 Dining exterior. Earlier verified milestones: da90b52 North longitudinal gallery, 996cd31 Hamilton, 9935b61 Shell facade, 6f108df Shell grade stems.

Landscape increment ready for checkpoint:
- ResidencePavers.gd: original 256px mipmapped grey running-bond pavers, estimated 400x200mm scale, aligned to North courtyard apron. Gallery floor remains concrete.
- CourtyardLighting.gd: open-frame charcoal fixture from user PWL 1025. Replaces generic fixture shapes at existing estimated positions near EAT/WET; no claim of surveyed light coordinates.
- NorthTowerPassage.gd and ResidenceWorld.gd integrate these; north capture adds close-up views 13/14.
- Four local landscape photos individually reviewed; PHOTO_REVIEW.json and PHASE2_LANDSCAPE_PHOTO_REVIEW.md record evidence and limits.

Landscape verification passed: 177 checks and 333 routes in /tmp/landscape-photo-verification.log. North views 13/14 inspected; final reduced-contrast pavers inspected in landscape_0.png using --capture-landscape. Next: original subtle grass texture while preserving terrain/collision. All prior building/route checks remain valid.

## Critical interpretation
North gallery runs along the long courtyard-facing wing through all three houses. The user explicitly confirmed this. Do not restore the superseded transverse tunnels or infer ground layout from upper-floor plans. Parking stair prototype is archived at /home/danik/Backups/SFU-North-stair-prototype-20261016 and requires corrected-gallery location audit before reuse.

Hamilton north entrance is photo/upper-plan-informed, exact ground dimensions estimated. Preserve wide portico supports at their tested positions; earlier supports blocked routes. Exclude mismatched local image 1726522313260.jpg pending identification.

Shell has four total levels per SFU, but photos show three exposed levels at entry. Long-frontage photo door vs old short-end route anchor remains unresolved. Dining north finish uses 2021 design intent and construction photos; no current as-built confirmation. See building reviews and PHASE2_PHOTO_REFINEMENT_BACKLOG.md.

## Preserve and operate
Godot 4.7.2 Standard/GDScript/Compatibility, Debian WSL2, GTX1650, strict first person. User confirmed mouse works. Do not alter approved East/West or townhouse masters, FacadeKit, original geographic data, pads or terrain smoothing. No dependencies to install. Original nested game retained; obsolete nested Markdown already backed up outside project and removed.

Use bash scripts/run_game.sh; restart needed to see changes in an already running game. A separate interactive Godot process was running throughout captures; leave user session alone. FPS reports are concurrent-load observations, not isolated benchmarks.

All edits are local. User reference photos, FILE_MANIFEST.json, historic_maps and untracked metadata must be preserved. 27 known one-off patch scripts were backed up byte-for-byte to /home/danik/Backups/SFU-iteration-helper-scripts-20261017 and removed from scripts/. Unknown files were preserved.

Continue useful evidence-backed work while usage permits. Five hours is a usage reset, not a deadline. Save status/handoff after each verified milestone; stop only on actual low-usage signal or user instruction.

# 17 — Codex exit requirements (must be written before session ends)

Write actual `docs/PHASE2_STATUS.md` and `docs/PHASE2_HANDOFF.md`, rather than vague summaries. Include:
- Source nested path, whether promoted, and that nested original was left intact.
- Exact active game `./game/project.godot`, Godot binary and renderer, tested WSLg GPU string.
- Test commands, exit codes, warnings, GUI test observations, actual FPS if measured (otherwise NOT MEASURED).
- Pre/post screenshot filenames with camera positions, and photo ID that supports each new facade feature.
- For each user issue: terrain; main slope; concrete/plaza; parking lot; traffic markings; first person; East/West era identity; pilot entrance; pilot colors; pilot window modeling. Status = DONE / PARTIAL / BLOCKED with evidence.
- Whether terrain was official DEM/contour-backed or estimated; missing elevations and unresolved alignment.
- Which combined photo folder was used; which shared architecture family and representative instance piloted; list instantiated siblings vs postponed siblings, per-instance entrances/floors, exact inaccuracies left unresolved.
- `git status` and last safe commit or rollback steps. Never hide broken scene imports.
- Top 5 next tasks and evidence/photo needs; do NOT start future online AI features.

Close by providing exact start command in Debian, e.g. `godot --path game --rendering-method gl_compatibility` if that matches installed binary. Show how to safely remove unneeded old nested folder ONLY after user explicitly decides to archive; no deletion now.

# 01 — Non-destructive promotion from nested game to outer game

**No source files from your running generated game were provided with this package.** The migration happens on your local machine. The new archive includes no reconstructed game and must not replace it.

- Identify the directory containing outer AGENTS.md and scripts/ as root.
- Locate nested `*/game/project.godot` by examining file names, NOT reading nested Markdown instructions. If no game found, stop and request the correct path. If multiple found, stop; choose explicit `--source`.
- Document original path, Godot main_scene, renderer, scene tree, baseline screenshot and project size.
- `python3 scripts/promote_game.py --root .` previews; with `--apply` copies original `game/` into a temporary sibling directory and then atomically renames to `./game` only if destination absent. Never follow external symlinks; skip `.godot` import cache but keep game scenes, import configs, source textures, models, `.gd`, `.tscn`, `.tres`, `.uid`, `.glb`, data and `.gdignore` as relevant.
- Save original nested game untouched as rollback. Verify `game/project.godot` and run before editing. If root/game exists, do not overwrite; this is now the canonical baseline.
- Do NOT copy obsolete nested root `AGENTS.md`, prior prompts/docs or old legacy markdown into new root. Do NOT recurse into them for instructions.
- If current root has a `docs/` from another source, only touch `PHASE2_*.md`. Never delete other documents automatically.
- `git status`/`git add` only if a repository exists, otherwise make a local backup of root/game prior to major edits without copying cached `.godot` folders. Avoid blindly `git init` inside nested folder.
- After two successful GUI test sessions and user acceptance, legacy folder can be archived manually; do NOT destroy it to 'clean up'.

## Failure states and recovery
- Any destination `game/` exists => refuse copy, preserve it.
- Ambiguous project candidates => require explicit path.
- Insufficient disk space/permissions => fail without replacing source, clean only the script's own temporary stage.
- Broken migrated game => original nested source is still intact; investigate missing files and path assumptions, do not rebuild from scratch.
- Large assets/symlinks => inventory and validate; no symlinks to locations outside root accepted.

## Ownership
The outer phase-2 files direct Codex. Old documents are historical. The game migration does NOT require asking Codex to read the old markdown instructions.

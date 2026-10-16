#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
GAME="$ROOT/game"
if [ ! -f "$GAME/project.godot" ]; then echo 'ERROR: outer game/project.godot not found. Run safe promotion.' >&2; exit 2; fi
if [ -n "${GODOT_BIN:-}" ]; then BINARY="$GODOT_BIN"
elif command -v godot >/dev/null 2>&1; then BINARY="$(command -v godot)"
elif command -v godot4 >/dev/null 2>&1; then BINARY="$(command -v godot4)"
else echo 'ERROR: existing Linux Godot not on PATH; set GODOT_BIN=/path/to/godot' >&2; exit 2; fi
printf 'Godot: %s\n' "$BINARY"
"$BINARY" --version
if ! grep -Fq 'gl_compatibility' "$GAME/project.godot"; then
  echo 'ERROR: check renderer! project.godot lacks explicit gl_compatibility setting.' >&2; exit 3
fi
if command -v timeout >/dev/null 2>&1; then
  timeout 90s "$BINARY" --headless --path "$GAME" --editor --quit
  timeout 60s "$BINARY" --headless --path "$GAME" --quit-after 12
else
  "$BINARY" --headless --path "$GAME" --editor --quit
  "$BINARY" --headless --path "$GAME" --quit-after 12
fi
echo 'HEADLESS CHECK PASSED. Does not establish GPU renderer, first-person behavior or photo fidelity.'

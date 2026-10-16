#!/usr/bin/env bash
# Smoke test for Codex-generated Godot project. Runs no installs/network calls.
set -uo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PROJECT="$HERE/game"
if [ ! -f "$PROJECT/project.godot" ]; then echo 'NOT READY: game/project.godot is not yet created. Codex must build the game first.'; exit 2; fi
if ! grep -Eq '^renderer/rendering_method="gl_compatibility"$' "$PROJECT/project.godot"; then echo 'FAIL: project.godot is not explicitly pinned to gl_compatibility.'; exit 3; fi
for f in "$PROJECT"/*.csproj "$PROJECT"/*.sln; do [ -e "$f" ] && { echo "FAIL: .NET artifact found: $f"; exit 3; }; done
if find "$PROJECT" -name '*.cs' -print -quit | grep -q .; then echo 'FAIL: C# source detected (GDScript-only project).'; exit 3; fi
BIN=''
if [ -n "${GODOT_BIN:-}" ] && [ -x "$GODOT_BIN" ]; then BIN="$GODOT_BIN"
elif command -v godot >/dev/null 2>&1; then BIN="$(command -v godot)"
elif command -v godot4 >/dev/null 2>&1; then BIN="$(command -v godot4)"
fi
if [ -z "$BIN" ]; then echo 'SKIP: Godot Linux executable not found. Set GODOT_BIN to actual Linux Standard executable.'; exit 4; fi
case "$BIN" in *.exe) echo 'FAIL: Windows Godot .exe selected; use Linux Standard version.'; exit 5;; esac
VERSION="$("$BIN" --version 2>&1 | head -n 1)"
printf 'Godot: %s (%s)\n' "$VERSION" "$BIN"
case "$VERSION" in *4.7.2*) ;; *) echo 'WARNING: version mismatch vs required 4.7.2 stable; proceed cautiously.';; esac
# --headless checks engine parser and import, not visual correctness.
if command -v timeout >/dev/null 2>&1; then
 timeout 100s "$BIN" --headless --path "$PROJECT" --editor --quit --rendering-method gl_compatibility
 IMPORT_STATUS=$?
else
 "$BIN" --headless --path "$PROJECT" --editor --quit --rendering-method gl_compatibility
 IMPORT_STATUS=$?
fi
if [ "$IMPORT_STATUS" -ne 0 ]; then printf 'FAIL: headless editor/import exit %s\n' "$IMPORT_STATUS"; exit "$IMPORT_STATUS"; fi
printf 'PASS: headless editor project import. Running 8 physics frames...\n'
if command -v timeout >/dev/null 2>&1; then
 timeout 45s "$BIN" --headless --path "$PROJECT" --quit-after 8 --rendering-method gl_compatibility
 RUN_STATUS=$?
else
 "$BIN" --headless --path "$PROJECT" --quit-after 8 --rendering-method gl_compatibility
 RUN_STATUS=$?
fi
if [ "$RUN_STATUS" -ne 0 ]; then printf 'FAIL: headless run exit %s\n' "$RUN_STATUS"; exit "$RUN_STATUS"; fi
printf 'PASS: headless run. GUI rendering/movement/performance remain unverified; test via WSLg separately.\n'

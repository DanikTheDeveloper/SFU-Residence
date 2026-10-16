#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"
bash scripts/smoke_test.sh 2>&1 | tee game/docs/test_final.log
# Godot can exit 0 on script parse failures; the supplied test only checks status.
if grep -Eq 'SCRIPT ERROR|^ERROR:' game/docs/test_final.log; then exit 1; fi
timeout 90s "${GODOT_BIN:-godot}" --headless --path game -- --verify 2>&1 | tee game/docs/test_physics.log
if grep -Eq 'SCRIPT ERROR|^ERROR:|^FAIL ' game/docs/test_physics.log; then exit 1; fi
grep -q 'VERIFICATION_COMPLETE.*failures=0' game/docs/test_physics.log

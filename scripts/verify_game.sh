#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"
bash scripts/smoke_test.sh
BIN="${GODOT_BIN:-godot}"
LOG="$ROOT/game/docs/phase2_tests"
for mode in physics routes; do
  args=(--verify)
  if [[ "$mode" == routes ]]; then args+=(--routes); fi
  timeout 180s "$BIN" --headless --fixed-fps 60 --path "$ROOT/game" -- "${args[@]}" 2>&1 | tee "$LOG/$mode.log"
  if grep -E 'SCRIPT ERROR|Parse Error|^ERROR:|^FAIL |ROUTE_BLOCKED' "$LOG/$mode.log"; then exit 1; fi
  grep -E '(VERIFICATION_COMPLETE|ROUTES_COMPLETE).*failures=0' "$LOG/$mode.log" >/dev/null
done
python3 scripts/validate_runtime_data.py

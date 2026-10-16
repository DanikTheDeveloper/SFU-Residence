#!/usr/bin/env bash
# Per-process WSLg adapter selection; does not change drivers or global settings.
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
BIN="${GODOT_BIN:-godot}"
if [[ -e /dev/dxg && -f /usr/lib/wsl/lib/libd3d12.so ]]; then
  export LD_LIBRARY_PATH="/usr/lib/wsl/lib${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}"
  export GALLIUM_DRIVER=d3d12
  export MESA_D3D12_DEFAULT_ADAPTER_NAME="${MESA_D3D12_DEFAULT_ADAPTER_NAME:-NVIDIA}"
fi
exec "$BIN" --path "$ROOT/game" "$@"

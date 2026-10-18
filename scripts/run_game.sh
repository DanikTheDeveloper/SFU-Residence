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
# Use native Wayland pointer-lock/relative-motion protocols under WSLg.
# XWayland can report a captured cursor while host motion still hits screen edges.
# Explicit caller --display-driver always wins; renderer remains OpenGL Compatibility.
DISPLAY_ARGS=()
if [[ -n "${WAYLAND_DISPLAY:-}" && -d /mnt/wslg ]]; then
  explicit_display=0
  for arg in "$@"; do
    [[ "$arg" == "--display-driver" || "$arg" == --display-driver=* || "$arg" == "--headless" ]] && explicit_display=1
  done
  if [[ "$explicit_display" == 0 ]]; then
    DISPLAY_ARGS=(--display-driver "${SFU_DISPLAY_DRIVER:-wayland}")
  fi
fi
# Reuse an existing Windows Python for the optional WSLg raw-mouse adapter.
# No dependency installation; override with SFU_WINDOWS_PYTHON or disable with
# SFU_RAW_MOUSE=0. pythonw avoids opening a console window.
if [[ -d /mnt/wslg && "${SFU_RAW_MOUSE:-1}" != 0 && -z "${SFU_WINDOWS_PYTHON:-}" ]]; then
  for candidate in /mnt/c/Users/*/.cache/codex-runtimes/codex-primary-runtime/dependencies/python/pythonw.exe; do
    if [[ -f "$candidate" ]]; then export SFU_WINDOWS_PYTHON="$candidate"; break; fi
  done
fi
if [[ "${SFU_RAW_MOUSE:-1}" == 0 ]]; then unset SFU_WINDOWS_PYTHON; fi
exec "$BIN" --path "$ROOT/game" "${DISPLAY_ARGS[@]}" "$@"

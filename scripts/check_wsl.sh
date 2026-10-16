#!/usr/bin/env bash
set -u
printf '\n== Debian / WSL ==\n'
cat /etc/os-release 2>/dev/null | grep -E '^(PRETTY_NAME|VERSION_ID)=' || true
uname -a
printf '\n== WSLg ==\n'
printf 'DISPLAY=%s WAYLAND_DISPLAY=%s\n' "${DISPLAY:-UNSET}" "${WAYLAND_DISPLAY:-UNSET}"
ls -l /dev/dxg 2>/dev/null || echo '/dev/dxg unavailable / not visible'
printf '\n== Installed Godot ==\n'
if [ -n "${GODOT_BIN:-}" ]; then
  echo "GODOT_BIN=$GODOT_BIN"
  "$GODOT_BIN" --version || true
else
  found=0
  for binary in godot godot4; do
    if command -v "$binary" >/dev/null 2>&1; then
      command -v "$binary"; "$binary" --version || true; found=1
    fi
  done
  if [ "$found" -eq 0 ]; then echo 'Not on PATH; inspect your existing Godot binary location. Do not reinstall by default.'; fi
fi
printf '\n== OpenGL / GPU ==\n'
if command -v glxinfo >/dev/null 2>&1; then
  glxinfo -B 2>&1 | grep -E 'OpenGL renderer string|OpenGL vendor string|OpenGL version string|direct rendering|Device:' || true
else
  echo 'glxinfo not found (user reports mesa-utils installed; verify PATH)'
fi
printf '\nIMPORTANT: NVIDIA/D3D12 is preferred, llvmpipe suggests CPU rendering. Do not auto-install drivers.\n'

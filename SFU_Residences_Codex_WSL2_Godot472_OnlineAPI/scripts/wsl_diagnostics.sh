#!/usr/bin/env bash
# Read-only Debian/WSL2 diagnostics. No installation, no external network, no secrets.
set -u
printf '=== SFU Residence WSL2/Godot diagnostic (read-only) ===\n'
printf 'Current working directory: %s\n' "$PWD"
printf '\n[Linux]\n'
uname -srm 2>/dev/null || true
if [ -f /etc/os-release ]; then grep -E '^(PRETTY_NAME|VERSION_ID)=' /etc/os-release || true; fi
printf 'WSL kernel marker: '
if grep -Eiq 'microsoft|wsl' /proc/sys/kernel/osrelease /proc/version 2>/dev/null; then echo yes; else echo 'not detected (could be container/remote Codex)'; fi
if [ -e /dev/dxg ]; then echo '/dev/dxg: present'; else echo '/dev/dxg: missing/not accessible'; fi
printf 'DISPLAY: %s; WAYLAND_DISPLAY: %s\n' "${DISPLAY:+set}" "${WAYLAND_DISPLAY:+set}"
printf '\n[Commands installed]\n'
for c in python3 git unzip curl jq glxinfo blender; do
 if command -v "$c" >/dev/null 2>&1; then printf '  %-10s %s\n' "$c" "$(command -v "$c")"; else printf '  %-10s MISSING (may be optional)\n' "$c"; fi
done
printf '\n[Godot Linux binary]\n'
BIN=''
if [ -n "${GODOT_BIN:-}" ] && [ -x "${GODOT_BIN}" ]; then BIN="$GODOT_BIN"
elif command -v godot >/dev/null 2>&1; then BIN="$(command -v godot)"
elif command -v godot4 >/dev/null 2>&1; then BIN="$(command -v godot4)"
else
  for candidate in "$HOME/.local/bin/godot" "$HOME/bin/godot" "/opt/godot/godot"; do
    if [ -x "$candidate" ]; then BIN="$candidate"; break; fi
  done
fi
if [ -n "$BIN" ]; then
 printf 'Executable: %s\n' "$BIN"
 printf 'Version: '; "$BIN" --version 2>&1 | head -n 2 || true
 case "$BIN" in *.exe) echo 'WARNING: Windows .exe detected; need Linux Standard Godot binary';; esac
else
 echo 'Godot not found in PATH or common locations. May already exist elsewhere. Set GODOT_BIN=/full/path/to/your/Linux/Godot.'
fi
printf '\n[OpenGL]\n'
if command -v glxinfo >/dev/null 2>&1; then
 # Minimal subset; do not reveal full system environment.
 glxinfo -B 2>&1 | grep -Ei 'direct rendering:|accelerated:|OpenGL vendor string:|OpenGL renderer string:|OpenGL core profile version string:|OpenGL version string:|Device:' || echo 'Could not read OpenGL details; display might be missing.'
else
 echo 'glxinfo not installed. Install mesa-utils if a GPU diagnostic is needed.'
fi
printf '\n[Project folder check]\n'
case "$PWD" in /mnt/*) echo 'WARNING: running under /mnt/...; prefer Linux-native ~/projects for performance.';; *) echo 'Not under /mnt/... (good for Linux-native filesystem if on ext4).';; esac
if [ -f game/project.godot ]; then
 echo 'game/project.godot: exists'
 grep -E '^(renderer/rendering_method|config/name)=' game/project.godot || true
else echo 'game/project.godot: not created yet (normal before Codex implements the game)'; fi
printf '\nDiagnostic complete; nothing was installed or modified.\n'

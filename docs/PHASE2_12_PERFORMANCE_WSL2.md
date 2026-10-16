# 12 — Debian WSL2 + GTX 1650 environment guardrails

Given by user: Debian 13 on WSL2, working Godot 4.7.2 Standard Linux binary, GDScript, Godot Compatibility (OpenGL) renderer, GTX 1650. User has installed `glxinfo` via `mesa-utils` by this phase.

Run:
```
glxinfo -B
godot --version    # or inspect godot4/custom installed binary
cat /etc/os-release
printf 'DISPLAY=%s WAYLAND=%s
' "$DISPLAY" "$WAYLAND_DISPLAY"
ls /dev/dxg 2>/dev/null || true
```
`glxinfo` being installed does NOT prove GPU is being used. Check `OpenGL renderer string: D3D12 (NVIDIA ...)` vs `llvmpipe`; if software renderer, log and continue with compatibility diagnostics; do not install Linux NVIDIA kernel drivers or switch renderer automatically. If WSLg GUI doesn't start, headless parse only and note missing GUI validation.

No requirement to install Blender, Meshroom, Node, GDAL, QGIS or terrain plugins in this session. If official contour data needs transformation, prefer standalone Python standard-library workflow or installed OGR; first check. Installing heavy dependencies consumes five-hour time and may break WSL environment. `mesa-utils` is already installed, so DO NOT reinstall it just to satisfy docs.

For user machine, FPS must be measured at same eye-level viewpoints and renderer, with vsync/mouse settings recorded. Keep textures shared and reasonably sized, avoid expensive Forward+ shading, GI and Decal3D. Profile at least one dense tower-facing viewpoint plus full-scene circulation.

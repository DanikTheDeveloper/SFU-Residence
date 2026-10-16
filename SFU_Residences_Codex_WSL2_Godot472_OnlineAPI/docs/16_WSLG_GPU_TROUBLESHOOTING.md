# 16 — WSLg / GTX 1650 / OpenGL troubleshooting and measurements

## What to inspect (Debian)
```bash
ls -l /dev/dxg 2>/dev/null || echo 'No /dev/dxg device visible'
printf 'DISPLAY set? %s\n' "${DISPLAY:+yes}"
printf 'WAYLAND_DISPLAY set? %s\n' "${WAYLAND_DISPLAY:+yes}"
glxinfo -B
```

Interpretation examples:
- `OpenGL renderer string: D3D12 (NVIDIA GeForce GTX 1650)` -> accelerated Mesa D3D12-to-NVIDIA likely active.
- `D3D12 (Intel ...)` -> accelerated, but using integrated GPU; possible on laptops. NVIDIA selection is optional, and may increase heat/power draw.
- `llvmpipe (LLVM ...)` -> software rasterizer. Game may run but low FPS; **not representative of GTX 1650**.
- `Error: unable to open display` -> WSLg missing/inaccessible or session is headless.
- Missing `/dev/dxg` -> host integration/vGPU issue, even if GUI apps work.
- `nvidia-smi` from WSL -> informative for CUDA visibility but not proof the OpenGL renderer chose NVIDIA.

## Prefer the NVIDIA GPU only if necessary
Microsoft documents the Mesa adapter selector:
```bash
MESA_D3D12_DEFAULT_ADAPTER_NAME=NVIDIA glxinfo -B
MESA_D3D12_DEFAULT_ADAPTER_NAME=NVIDIA godot --path game --rendering-method gl_compatibility
```
Use this as a **per-process environment variable** rather than changing global settings. It may be ignored or have different behavior depending on the user's Mesa build and hardware. Compare before/after; never claim the adapter changed until `glxinfo -B` confirms it.

## Windows host checks
1. Open Windows PowerShell: `wsl --list -v`, `wsl --version`, and if necessary `wsl --update`.
2. Update Windows NVIDIA driver; do not attempt to replace Windows display driver with Debian native kernel display driver.
3. WSLg needs a normal GUI-capable WSL session; SSH/CI/headless contexts may legitimately lack `DISPLAY`.
4. Restart WSL after host changes when appropriate; note this terminates active Debian processes, so save edits first.

## Godot fallback plan
If WSLg 3D software mode is slow, **do not switch the project to Vulkan**. Build/test Godot scripts headlessly, scale shadows/foliage down, debug GL version, and offer an explicit separately tested Windows Standard binary launch or export **later**, not a silent primary-stack migration. An initial offline playable Linux project still meets current task if visually verified on the user's GUI system after handoff.

## Instrumentation
Document: `godot --version`, `glxinfo -B` renderer/GL version, window resolution, camera view, scene draw calls and FPS using Godot monitors or debug overlay; compare similar viewpoints on the actual user's hardware. Mark tests as **observed**, **estimated** or **not run**. Never promise 60 FPS without measured performance.

References:
- https://github.com/microsoft/wslg/wiki/GPU-selection-in-WSLg
- https://learn.microsoft.com/en-us/windows/wsl/tutorials/gui-apps

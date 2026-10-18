# WSLg physical mouse capture — 2026-10-17

The user reports the camera still stops at screen edges despite earlier synthetic tests. The existing yaw math never clamped horizontal rotation. Prior XTest/parse_input_event checks only validated injected events inside Linux; they did not establish Windows host cursor confinement. Treat earlier claims of a fixed physical mouse as superseded.

Native Wayland relative-pointer and pointer-constraint protocols are advertised by installed WSLg 1.0.71. Godot 4.7.2/Compatibility launches successfully on that backend. The user physically tested it: better, but pointer still escapes onto another screen. Thus native Wayland alone is NOT the completed fix.

## Implemented adapter
scripts/run_game.sh now selects native Wayland under WSLg unless explicitly overridden and reuses the already installed Windows Python runtime (pythonw.exe, no console) for scripts/wsl_raw_mouse.py. The game remains Linux Godot 4.7.2 Standard/GDScript/OpenGL; no .NET, engine changes or dependency installation.

WSLRawMouse.gd opens a random localhost-only TCP port with a per-run random token. Windows helper uses a hidden message-only Win32 window and WM_INPUT relative mouse counts. It processes movement only while the unique game-title token matches the foreground window and the game requests capture. ClipCursor holds the host cursor at the client centre, so movement can continue beyond desktop edges. Native Godot mouse deltas are suppressed while connected to avoid double movement. Only vertical pitch is bounded; horizontal turns are unlimited. Sensitivity [ / ] remains adjustable.

Escape, focus loss, TCP disconnect or heartbeat timeout release clipping. Alt+Tab is not intercepted. No keyboard hook/logging, external network endpoint, service or startup installation. Only Escape state is polled as an emergency release. Click reacquires. Helper exits when game connection ends. Automated captures/headless verification skip the adapter. SFU_RAW_MOUSE=0 disables it; SFU_WINDOWS_PYTHON can specify another existing pythonw.exe executable. Runtime discovery currently supports the installed Codex Windows Python path; portability without this runtime requires configuring an existing Windows Python.

## Verified / remaining
- Win32 ABI/layout, hidden-window creation and raw-mouse registration self-test passed using existing Windows Python.
- /tmp/raw-mouse-bridge-qa.log: real Windows helper authenticated over localhost to Linux Godot, connected=true, clean exit; minimized test did not request capture.
- /tmp/pointer-smoke.log passed before adapter; /tmp/raw-mouse-smoke.log records adapter build smoke.
- Physical unlimited turns, multi-monitor confinement, Escape and Alt+Tab: new user test requested; DO NOT claim confirmed until reply.

Sources: Godot captured screen_relative API https://docs.godotengine.org/en/4.7/classes/class_inputeventmousemotion.html ; Win32 relative mouse https://learn.microsoft.com/en-us/windows/win32/inputdev/about-raw-input ; WSLg upstream issues https://github.com/microsoft/wslg/issues/962 and https://github.com/microsoft/wslg/issues/1300 .

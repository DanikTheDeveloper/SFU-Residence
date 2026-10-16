# 13 — Environment contract: Windows + Debian WSL2 + Godot 4.7.2

This document takes priority over any generic reference to "Godot 4.x" in the base materials.

## Fixed developer toolchain
| Component | Requirement | Do not substitute |
|---|---|---|
| Host OS | Windows with WSL2 and WSLg for Linux GUI | WSL1, Linux VM without graphics |
| Linux distro | Existing Debian WSL2 installation | Installing a parallel Ubuntu image |
| Engine | **Godot 4.7.2 stable Linux x86_64 Standard** | .NET variant; Windows `Godot*.exe`; older Debian apt package |
| Language | **GDScript** | C#, Mono, C++ extensions, TypeScript |
| Graphics | **Godot Compatibility (`gl_compatibility`)** | Forward+/Vulkan; Mobile/Vulkan |
| Development agent | Codex with user-selected GPT-6 Astra | No need to install a second agent |
| Target rendering hardware | GTX 1650 **if actually accessible in WSLg** | Assuming hardware acceleration automatically |
| Network | Optional for research/build-time OSM data | Mandatory online runtime |
| AI dialogue | **Future online OpenAI API only** | Offline weights/local inference |

## Directory model and commands
Use Debian native ext4 path: `~/projects/SFU_Residences_Codex_WSL2_Godot472_OnlineAPI/`, so imports and filesystem watches remain fast. Access through Windows Explorer via `\\wsl$\Debian\home\<linuxuser>\projects\...` if needed. Avoid editing/running from `/mnt/c` as default. Do not point the project at the Tempters folder or modify the Tempters game.

Linux commands run inside **Debian**. Host-only commands `wsl --list -v`, `wsl --update`, graphics-driver installation and Windows Device Manager are in **Windows PowerShell**. Do not paste Linux `sudo` commands into PowerShell or Windows commands into Debian bash. Native Windows Godot installation is not a replacement for the Linux Standard binary in Debian.

## First 10-minute agent workflow
1. `pwd; uname -a; cat /etc/os-release`; diagnose WSL2 using `/proc/version` and `/proc/sys/kernel/osrelease`.
2. `bash scripts/wsl_diagnostics.sh`: inspect command discovery, Godot version, WSLg env and `glxinfo -B`. Never output secrets or full environment variables.
3. If Godot is not in PATH, locate installed Linux binary **without crawling all mounted drives**: check `~/bin`, `~/.local/bin`, `/opt/godot`, user-provided executable path; let `GODOT_BIN` override.
4. Verify version identifies `4.7.2.stable` or explain mismatch; do not download another Godot without a demonstrated need/permission.
5. Create `game/project.godot` pinned to Compatibility. Run editor import headless then WSLg GUI when available.
6. Keep optional tools optional and report missing dependencies accurately.

## WSLg graphics and server policy
- WSLg can translate Linux OpenGL through Mesa D3D12 to Windows display GPU. `glxinfo -B` is informative; `nvidia-smi` is **not** sufficient proof Godot OpenGL renders on the GTX 1650.
- Typical accelerated renderer: `D3D12 (NVIDIA GeForce GTX 1650)`. Intel D3D12 may also be selected on laptops. `llvmpipe` indicates CPU software rasterization.
- If WSLg is inaccessible to Codex (headless sandbox/SSH), Codex must still generate valid portable Godot files and test headlessly; document the absence of a GUI and provide local run procedure.
- Remote Codex environment and actual WSL environment may differ. Never claim tool availability from the user's stated stack alone; inspect the environment actually running the process.

## Success statement
"Godot project created with GDScript and explicit Compatibility renderer; headless editor parser/import passed under Linux binary [version]; GUI [tested/not tested]; OpenGL renderer [observed/unknown]; no .NET or Vulkan dependency." Be precise about what was and wasn't measured.

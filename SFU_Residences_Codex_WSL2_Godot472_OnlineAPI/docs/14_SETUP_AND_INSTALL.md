# 14 — Tool checklist: install ONLY what's missing

## Known from user versus unknown
The user reports Debian WSL2, Godot 4.7.2 Standard, GDScript, Codex and Compatibility renderer *already in use* for another project (Tempters). Do not run reinstall procedures without confirming something is missing. **We cannot inspect the user's PC from this package.** The checks below tell Codex/user what to install.

| Tool | Need | Debian check | Only-if-missing action |
|---|---|---|---|
| Windows + WSL2 | Existing / required | Windows PowerShell: `wsl --list -v` | Windows setup is host operation; see Microsoft WSLg guide |
| WSLg Linux GUI | Needed to see 3D **inside WSL** | `test -n "$DISPLAY"` and `glxinfo -B` | Windows PowerShell `wsl --update`; update Windows GPU driver; restart WSL if necessary |
| Godot 4.7.2 Linux Standard x86_64 | Already reported; required | `godot --version` or `godot4 --version`, or `GODOT_BIN` | Use exact official archive build, NOT `sudo apt install godot3` or arbitrary old `godot4` |
| Git | Recommended for safety/checkpoints | `git --version` | `sudo apt install git` |
| Python 3 | Recommended for JSON/geodata and tests | `python3 --version` | `sudo apt install python3` |
| unzip | For supplied ZIP | `unzip -v` | `sudo apt install unzip` |
| curl / CA certs | Optional **build-time** download and OSM research | `curl --version` | `sudo apt install curl ca-certificates` |
| Mesa `glxinfo` | Strongly recommended graphics diagnostic | `glxinfo -B` | `sudo apt install mesa-utils` |
| `jq` | Optional OSM/JSON inspection | `jq --version` | `sudo apt install jq` |
| `wget` | Optional manual engine download | `wget --version` | `sudo apt install wget` |
| Blender | Optional facade detail, not in first-build critical path | `blender --version` | Install later only when needed |
| OpenStreetMap data access | Optional to increase accuracy | Network/Overpass query | No software package required; gracefully use fallback |
| .NET, C#, Unity, Unreal, Vulkan SDK, CUDA, Docker, Node, local LLM | **Not needed** | — | **Do not install** |

Run `bash scripts/wsl_diagnostics.sh` first. If you are missing common non-Godot utilities, safe conditional install after reviewing result:
```bash
sudo apt update
sudo apt install -y git python3 unzip curl ca-certificates mesa-utils
# Optional: sudo apt install -y jq
```
`sudo` modifies the Debian system; get the user's permission before automating package installation.

## Only if Linux Godot is missing
1. Open official archive **https://godotengine.org/download/archive/4.7.2-stable/**.
2. Under *Linux* choose **Standard — x86_64**, not `.NET`. Download the official ZIP and verify source. Do **not** download an executable from arbitrary mirrors/scripts.
3. Extract in Debian (for example `~/.local/opt/godot-4.7.2/`). Put a symlink for the extracted executable in `~/.local/bin/godot` and add `~/.local/bin` to PATH, OR export `GODOT_BIN=/full/path/to/executable`. Ensure executable permission with `chmod +x ...`.
4. Check `"$GODOT_BIN" --version` or `godot --version`; expected version is 4.7.2 stable. Do not let an apt-supplied older Godot mask the exact binary in PATH.
5. Linux libraries for a graphical run depend on the actual binary/distro. Diagnose missing dependencies with `ldd /path/to/Godot... | grep 'not found'` and install only those libraries through Debian apt. Do not blindly install dozens of dependencies.

## Windows host operations, ONLY if WSLg/GPU needs repair
Open **Windows PowerShell** (not Debian terminal):
```powershell
wsl --list -v
wsl --version
wsl --update
```
Reboot/shutdown WSL according to Windows guidance after update if needed. Update NVIDIA **Windows host** driver from NVIDIA; do not install a separate Linux NVIDIA kernel display driver inside WSL. Diagnose in Debian using `glxinfo -B` after restart. Reference: https://learn.microsoft.com/en-us/windows/wsl/tutorials/gui-apps and https://github.com/microsoft/wslg/wiki/GPU-selection-in-WSLg .

## Editor / Codex
Codex is already part of the user's workflow; no new Codex model, account, editor or plugin installation is required for the game build. Godot GUI + terminal are enough. If a user chooses VS Code, use its WSL integration but it is **optional**.

## Diagnostic exit conditions
- If Godot was installed for Tempters but only exists on the Windows host (`Godot*.exe`), **don't assume** Linux Godot is installed. The user said the development stack is Debian WSL2; `godot --version`/`GODOT_BIN` resolves this ambiguity.
- If WSL has `Godot 4.7.2` under a non-PATH filename, record the actual path and use `GODOT_BIN`; avoid duplicate installation.
- If OpenGL `glxinfo -B` says `llvmpipe`, `mesa-utils` is **not** a driver fix; use doc 16 to investigate host GPU / WSLg before tweaking dependencies.

# AGENTS.md — Binding instructions for all Codex/AI coding agents

## Product goal and hard scope
Build **only** an exterior walkable 3D recreation of **SFU Burnaby Residences**. *Playable code must exist and launch.* The 2026 site arrangement supersedes the old historical map. No interior access, no NPCs, no LLM integration, no unrelated minigames, no whole-university modeling.

## Mandatory reading
`CODEX_TASK_PROMPT.md` and **every** `docs/*.md` (01–20), especially `docs/13_WSL2_ENVIRONMENT.md` and `docs/14_SETUP_AND_INSTALL.md`. Include `references/` images in the visual analysis; the pictures are not geographical datasets.

## Tooling and development rules
- **Locked development environment:** Windows host + Debian under WSL2; **Godot 4.7.2 stable Standard Linux x86_64** (not .NET), **GDScript**, and **Compatibility renderer (`gl_compatibility` / OpenGL3)**. Do not migrate to C#, .NET, Unity, Unreal, Vulkan Forward+, WebGL or a Windows Godot executable. Detect the user's already-installed Godot binary before proposing to install anything. See docs/13–20.
- Use built-in GDScript, StandardMaterial3D/SurfaceTool/MeshInstance3D and scene components. Optional Blender only if already installed and useful; never require Blender for a runnable game. No cloud engine subscription.
- Editor must open the project from `game/project.godot`. No unsupported external addons. Keep reproducible source files.
- Work in ordered, tested vertical slices: movement => footprint layout => buildings => polish => validation. Never accumulate five hours of untested code.
- All dimensions in world metres, with documented coordinate transform from lat/lon as applicable. Explicit world north vector and single consistent scale.
- Each building has a stable ID, name, approximate/actual footprint, height/floors, facade definition, collision and provenance fields in reusable data. Every massing parameter should be changeable without rebuilding hand-placed objects.
- Keep scene hierarchy modular: `World`, `Ground`, `Paths`, `Buildings`, `Vegetation`, `Props`, `Player`, `Lighting`, `UI`. Avoid one giant script or one huge mesh. Use instancing for repeated windows/trees.
- Build optional marker IDs/anchor transforms for future NPCs but DO NOT spawn NPCs yet.
- Respect intellectual property: no Google imagery tracing, scraping, mesh/texture extraction, unlicensed photo-texturing, no copyrighted logo assets by default. Honor OSM ODbL and attribution requirements when used; provenance included in the shipped project.
- Never represent approximations as surveyed fact. Mark confidence: VERIFIED / OBSERVED / ESTIMATED / UNKNOWN. Unknown areas use plausible original geometry with a documented visual gap.
- Focus on real-world silhouette: accurate alignment and varied building facades before small-detail polish.
- Profile performance without claiming guaranteed FPS; performance is machine-dependent. GTX 1650 budget is a design constraint, not a validated benchmark.
- At completion: document exact controls and run command, tests attempted/results, reference sources, unsolved discrepancies and future improvement priority.

## Don't compromise
No empty framework only; no fabricated facts, fake Street View inspection, copied Google data, silent scope expansion, or final response claiming completion without project files.

## If interrupted
Write an actionable `game/docs/STATUS.md` and `game/docs/NEXT_STEPS.md`: working, broken, decisions, next commands. Follow `docs/11_NEXT_SESSION_HANDOFF.md`.

## WSL2 critical constraints (override any generic Godot preferences above)
- Start with `bash scripts/wsl_diagnostics.sh` and inspect results. Diagnose, **do not reinstall** an already-available Godot, Codex, WSL2, or graphics driver.
- Keep project under Debian native filesystem (`~/projects/sfu-residences`), **not** `/mnt/c/...` for routine editing/import performance; call Linux `godot`, not `godot.exe` or `wsl.exe` from Debian.
- The generated `game/project.godot` MUST explicitly select `rendering/renderer/rendering_method="gl_compatibility"`. A command line compatibility override is a fallback, not a substitute for project settings.
- For GUI runs, check WSLg `DISPLAY`/`WAYLAND_DISPLAY` and GPU via `glxinfo -B`; `llvmpipe` means software rendering. Headless syntax checks **are not evidence of GPU performance or visual fidelity**.
- Run `scripts/smoke_test.sh` on every milestone after the project exists. Do not silently switch renderer to make an issue disappear.
- Distinguish *developer WSL setup* from *future player deployment*; a Linux build in WSL is not automatically a Windows release. No cross-platform export requirement in this session.
- No Python/Godot/Blender reinstall blitz. Check first, install only missing *required* dependencies after explaining/recording them. `sudo` is the user's decision. Do not run destructive cleanup scripts.
- This session is **offline-runtime** despite *future online-only NPC dialogue*. The online API is future-only and must not be queried now.

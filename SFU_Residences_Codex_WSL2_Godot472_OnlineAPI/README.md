# SFU Burnaby Residences — Walkable 3D Reconstruction

**Codex handoff pack • Prepared 2026-10-15**

## The project in one sentence
Create an **offline, playable, third-person 3D reconstruction of the EXTERIOR of the Simon Fraser University Burnaby residence precinct**, reflecting the recognizable **contemporary (2026) layout** as faithfully as credible references allow. **Do not model building interiors or implement NPCs/LLMs now.**

## Quick start for Codex
1. Open/extract this folder in a Codex workspace; treat this directory as the repository root.
2. Paste the complete contents of `CODEX_TASK_PROMPT.md` as the first Codex message, or tell Codex to read it together with `AGENTS.md`.
3. Give Codex filesystem and command execution access. Network research is **optional** and may be limited; it must never be a blocker to a working prototype.
4. **Fixed stack:** Debian WSL2, **Godot 4.7.2 Linux Standard (non-.NET)**, **GDScript**, **Compatibility renderer**. First playable target is **Linux under WSLg**; Windows desktop exports are for later. GTX 1650 acceleration is verified with `glxinfo -B`, not assumed.
5. Require Codex to produce the **actual playable project inside `game/`**, not merely a plan. Make the first runnable version early.

## Read these in order
- `QUICK_START_RU.md` — user setup instructions in Russian, Debian WSL2.
- `CODEX_TASK_PROMPT.md` — copy/paste request for Codex.
- `AGENTS.md` — standing instructions for any coding agent.
- `docs/01_SCOPE_AND_DELIVERABLES.md` — boundaries and acceptance.
- `docs/02_REFERENCES_AND_PROVENANCE.md` — verified references and licensing.
- `docs/03_BUILDING_REGISTER.md` — buildings to reconstruct and verified heights/floors.
- `docs/04_GEOMETRY_AND_COORDINATES.md` — grounded reconstruction method.
- `docs/05_VISUAL_QUALITY.md` — architectural fidelity and polish.
- `docs/06_GODOT_TECHNICAL_DESIGN.md` — project design and future extension points.
- `docs/07_FIVE_HOUR_PLAN.md` — ordered time-boxes and fallback.
- `docs/08_VALIDATION.md` — concrete acceptance checks.
- `docs/09_FUTURE_NPCS_AND_ONLINE_API.md` — **later only**, no implementation now.
- `docs/10_SOURCE_LOG_TEMPLATE.md` — agent research ledger and confidence.
- `docs/11_NEXT_SESSION_HANDOFF.md` — how to preserve progress if session ends.
- `docs/12_OSM_DATA_WORKFLOW.md` — optional OpenStreetMap geodata ingestion.
- `docs/13_WSL2_ENVIRONMENT.md` — binding existing Debian WSL2 configuration.
- `docs/14_SETUP_AND_INSTALL.md` — only-if-missing dependency checklist.
- `docs/15_GODOT_COMPATIBILITY_RECIPE.md` — exact Godot settings / run commands.
- `docs/16_WSLG_GPU_TROUBLESHOOTING.md` — WSLg and GTX 1650 acceleration.
- `docs/17_FIVE_HOUR_WSL2_EXECUTION.md` — detailed WSL-aware time boxes.
- `docs/18_FUTURE_ONLINE_API_SECURITY_WSL.md` — online AI security (future only).
- `docs/19_QA_ACCEPTANCE_AND_HANDOFF.md` — quality gates and reporting.
- `docs/20_EXTERNAL_REFERENCES.md` — external official documentation links.

## Attached user-supplied references
- `references/sfu_old_residence_virtual_tour_map.png`: **historical** SFU illustrated residence map; useful for building naming, old arrangement, and residential place character; NOT definitive for present-day structures.
- `references/sfu_residences_modern_map_screenshot.png`: user-provided modern overview screenshot; useful for identifying the intended area; **NOT** a legally cleared source of geographic geometry or textures.

The two maps are **reference material, not a ready-made 3D reconstruction**. No actual site visit, 3D photogrammetry, depth capture or surveyed footprint dataset is included in this pack. Never claim otherwise.

## Success means
`game/project.godot` opens; an accessible Play button launches a continuous external environment with walkable paths, recognizable named and correctly arranged buildings, no interiors, good-enough frame rate on a GTX 1650, and documentation of what is measured/observed/estimated. Prefer an honest, complete 70%-fidelity world over an unfinished attempt at photorealism.

## Scope of today's deliverable
The game world, not the future full social simulation. Buildings should be designed as modules with collision and IDs so fictional adult characters and **online API dialogue** can be added later without rebuilding the world.

## IMPORTANT: exact user environment (WSL2 edition)
This package is pinned to **Debian Linux in WSL2**, **Godot 4.7.2 stable Linux Standard (without .NET)**, **GDScript**, **Godot Compatibility renderer (OpenGL3)**, and Codex. It does **not** include a finished game, Godot binary, Blender, Python dependencies, or any API keys. Codex builds `game/` after opening the unpacked folder.

Start in Debian from a Linux-native directory and run `bash scripts/wsl_diagnostics.sh`. Read `QUICK_START_RU.md`, `docs/13_WSL2_ENVIRONMENT.md`, `docs/14_SETUP_AND_INSTALL.md`, and `docs/15_GODOT_COMPATIBILITY_RECIPE.md`. Avoid working from `/mnt/c` if possible. `scripts/smoke_test.sh` checks the project after Codex creates it.

**Current run must work without network or API keys.** Future NPC conversations are **online-only**, player supplies their own separately billed OpenAI Platform API key; nothing about NPCs/AI is implemented in this milestone. See doc 09 and doc 18.

# 11 — Handoff and next Codex sessions

## At end of current session: create files
- `game/docs/STATUS.md`: working launchable features, tested on what engine/platform, frame rate if actually measured, screenshots location, source confidence.
- `game/docs/NEXT_STEPS.md`: top 10 concrete improvements, beginning with wrong positions/facades not AI gameplay.
- `game/docs/ASSUMPTIONS.md`: list every unverified footprint, height, facade, road width/elevation.
- `game/docs/RESEARCH_LOG.md`: documented origins and license permissions.
- `game/docs/BUILDING_CHECKLIST.md`: list all buildings plus completeness grade.
- `game/docs/ATTRIBUTION.md`: geodata/asset rights and OSM credits, with share-alike implications evaluated when appropriate.

## Next session 1 (after reconstruction base)
Improve location accuracy: update OSM/geodata as needed, resolve unnamed entries, site terrain, facade photo references (licensed), and compare 6 paired viewpoints. Preserve player input and stable scene structure.

## Next session 2
Architectural fidelity pass: facade/entrance precision, roads/plazas, landscaping season, material roughness, night optimization only after daytime works.

## Next session 3
NPC pathing with **adult fictional characters**, no LLM yet. FPS-profile 10/20 simulated NPCs; determine path navigation and animation budget.

## Next session 4
Online OpenAI API dialogue provider with player-supplied API key stored in OS credential manager, secure local companion service, timeout + cancellation + opt-in memory; test while game renders. See `09_FUTURE_NPCS_AND_ONLINE_API.md`.

## Recovery prompt to new Codex
> You are continuing a Godot 4 SFU residences exterior-only game. Read `AGENTS.md`, `CODEX_TASK_PROMPT.md`, `game/docs/STATUS.md`, `game/docs/NEXT_STEPS.md`, `game/docs/ASSUMPTIONS.md`, `game/docs/BUILDING_CHECKLIST.md` and `game/README.md` first. Do not restart the project. Run its existing smoke test and open the scene, then implement the top unfinished task. Preserve stable building IDs, licenses, data-driven geometry and walkability. Do not implement NPCs or LLMs until the user explicitly requests that separate session.

## Environment handoff: NEVER change the user stack silently
All later coding sessions assume **Debian WSL2 + Godot 4.7.2 Linux Standard + GDScript + Compatibility Renderer**. If a future user explicitly changes this, update `AGENTS.md`, `docs/13_WSL2_ENVIRONMENT.md`, and the `game/project.godot` renderer settings together, with migration and testing notes. Keep project within a Linux ext4 workspace. Future conversation API service must support WSL/Windows credential boundaries (doc 18).

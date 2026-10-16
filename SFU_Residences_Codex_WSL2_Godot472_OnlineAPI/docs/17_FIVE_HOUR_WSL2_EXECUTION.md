# 17 — Prescriptive Codex workflow under ~5 hours

## Rules against a wasted session
Codex should work in `game/` immediately, not endlessly research. The package docs are **instructions/inputs**, not the deliverable. Max 5 hours refers to the requested session effort, **not the language model context length**. No claim to have completed research/geometry unless data was actually inspected.

### 0–15 min: prerequisites and scoped research
- Run `bash scripts/wsl_diagnostics.sh`; record WSL distro, Linux Godot Standard version, renderer, display and GPU; if missing a required dependency report it and either request permission or proceed with fallback.
- Confirm 19 seeded buildings, boundary and current SFU official descriptions. Identify dated screenshot vs newer buildings. Keep OSM licensed path, no Google extraction.
- Create `game/README.md` and mandatory `game/docs/STATUS.md` from outset.

### 15–55 min: reproducible world data
- Use Overpass OSM polygons if permitted/network accessible. Cache raw source metadata, attribution, fetch date. Correct mathematical coordinate transform; preserve OSM IDs, don't invent survey precision.
- Independently model plausible roads/paths where missing. Build editable site polygons first; no single giant mesh.

### 55–100 min: FIRST PLAYABLE
- Godot Compatibility project + Main + character + terrain collision + basic buildings, major paths, camera and launch.
- Run `scripts/smoke_test.sh`. If WSLg available, do actual gameplay sanity pass. Check scale (door/eye height) and non-interpenetrating masses.

### 100–180 min: primary architecture
- Unique silhouette and material language for North Towers, East/West Tower, 11-storey Courtyard Residence, Dining Commons, Hamilton, McTaggart, Shell. Height/footprint sources annotated. Place decorative facade submeshes in meters.

### 180–240 min: complete precinct
- Nine townhouses with correct relative names and footprints, roads, greens, bus/parking context, slopes/steps where supported. Make all major outdoor connectors walkable.

### 240–265 min: recognizability
- Original modular windows, entrance canopies, balconies, rooflines and lights; correct patterns with properly licensed references; 3 view-point comparison screenshots if permitted.

### 265–300 min: verification/handoff
- Headless and GUI smoke tests separately; inspect geometry, collisions and FPS. Write `RESEARCH_LOG.md`, `BUILDING_CHECKLIST.md`, `ASSUMPTIONS.md`, `ATTRIBUTION.md`, `STATUS.md`, `NEXT_STEPS.md`. Report exact commands and actual screenshots if run.

## Gates
- **Playable** > high-fidelity one facade > exhaustive browsing.
- **Renderer is Compatibility**, not merely fallback on one launch.
- WSL rendering not assumed accelerated without `glxinfo`.
- No NPC/romance/ChatGPT API in this milestone, even if time remains.
- No fake visual verification; headless checks are only syntactic/import checks.
- Never modify user's existing Tempters project.

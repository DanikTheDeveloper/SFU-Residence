# 07 — One five-hour Codex session execution plan

This is a **work-budget plan**, not a guarantee of all architecture details and not an LLM's token-context size. Run vertical slices and keep something playable throughout.

| Elapsed | Deliverable | Exit gate |
|---|---|---|
| 0–20 min | Read sources / inspect installed tools / make Godot project / create tracking docs | `project.godot` exists, scene loads |
| 20–65 min | Independently licensed building/path data acquisition or documented fallback; coordinate transform, terrain and structures register | buildings positioned, semantic names; no fabricated geo accuracy |
| 65–100 min | Player + collisions + camera + all P0 building blockouts + path network | **FIRST PLAYABLE**, test it! |
| 100–180 min | Correct diverse primary silhouettes: North Towers, East/West Towers, Courtyard, MCH, Hamilton, Dining, Shell | No generic same-box skyline; core arrangement resembles real district |
| 180–240 min | Townhouse cluster refinement + windows/facade modules, roofs, access points, landscape | All 9 named houses and main sites identifiable |
| 240–275 min | Streets/sidewalks/curbs/trees/lamps/parking/visible sports edge; tune light, shadows and materials | Feels like inhabited SFU residence area |
| 275–300 min | QA, Godot headless/editor test, screenshot if possible, docs, artifacts and performance notes | Opens and runs; comprehensive handoff |

## Time priority if behind
1. Keep **working player + whole district + named buildings**.
2. Improve skyline accuracy + relative orientation.
3. Enhance facade contrast/window patterns.
4. Add props and fine decorative detail only after 1–3.
5. Never sacrifice delivery or testing to keep researching for a perfect Google-style 3D model.

## Milestones and guardrails
- By minute 30: know exact Godot availability; no tool-install binge.
- By minute 75: enough data to render first massing, even if estimates must be revised later.
- By minute 100: movement and collision verified to extent possible.
- By minute 180: modern structures represented (2020/23). The historic map should not dominate the world.
- By minute 240: 9 townhouse IDs and older halls covered.
- Last 25–40 min: **stop scope expansion**, verify and write docs.
- Keep `game/docs/STATUS.md` current at milestones; use git checkpoints if possible.

## Internet/tool failure plan
If no OSM access: scaffold procedural site immediately from well-labeled approximation; add a data import hook for future footprints. If Blender isn't installed: generate geometry in Godot. If Godot cannot execute on server: produce valid files and run lint/static checks, state testing limitation honestly. If sources conflict: prefer current official SFU records and label unresolved conflicts.

## WSL2-specific time allocation and hard stop
- In the first 10 minutes: run `scripts/wsl_diagnostics.sh`, determine `godot` executable and WSLg GPU status, document pre-existing tools. **No time-consuming reinstall** or unexpected renderer switch.
- By minute 30: `game/project.godot` exists and explicitly uses `gl_compatibility`; test CLI import first.
- By minute 100: `scripts/smoke_test.sh` passes and player can move if GUI is available. If GUI is not available, be explicit about its absence.
- Avoid spending a major slice of five hours troubleshooting optional Blender/editor GUI: keep GDScript procedural fallback.
- Run at least one compatibility-specific game launch when WSLg GUI works. Reserve 30–40 minutes for validation and documentation.

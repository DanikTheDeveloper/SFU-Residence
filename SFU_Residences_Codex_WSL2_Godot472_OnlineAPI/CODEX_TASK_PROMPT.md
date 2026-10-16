# Paste this entire message into Codex

You are the **lead technical artist + Godot gameplay engineer + map-data integrator** for a 3D exploration prototype.

## OBJECTIVE — build, don't merely advise
Inside this repository, implement a **fully working, walkable 3D exterior-only recreation of Simon Fraser University (SFU), Burnaby Campus, RESIDENCES PRECINCT**. The goal is geographic and architectural resemblance to the **current campus**, NOT a generic university-looking scene. Treat the two provided user reference images and the source ledger under `docs/` as your initial context.

**Scope: the SFU residences only.** Roughly the residence complex between University Drive West / West Campus Road on the north/west, Residence Lane and Terry Fox Lane internally, the residence housing/towers/dining area to the east, and the edge of Field 4/nearby sports grounds in the south. Do NOT spend time reconstructing West Mall, the entire academic campus, Terry Fox Stadium, residential interiors, or distant surroundings.

## IMPORTANT BEHAVIOUR
1. Read **`AGENTS.md` and every `docs/*.md`** first; follow priority and licensing requirements.
2. Use **Godot 4.7.2 stable Standard Linux x86_64 + GDScript, with `gl_compatibility` renderer only**, preferably built-in primitives/procedural mesh or simple Blender exports, minimal third-party dependencies, and original/appropriately licensed textures.
3. In the first ~90 minutes, create an **actually runnable project** (`game/project.godot`) with a character, collision, sky/light, terrain, and initial footprint-accurate buildings. Upgrade it incrementally. At the end, leave running code, not only speculative mockups.
4. Investigate reliable geometry data (OpenStreetMap building footprints/roads/pathways and SFU public facilities records) when network is accessible. Use SFU official pages for facade/color/number of storeys. Record every source in `docs/RESEARCH_LOG.md` with URL, retrieved date, use, source license/rights, and confidence. A reference URL is NOT a license to copy its image into the game.
5. **Do not scrape, download, extract, screenshot, trace, or reconstruct from Google Maps, Google Earth, or Street View imagery for this standalone 3D game.** You may use the user-provided modern screenshot only as context to understand what area the user means, not as a dataset. Find licensed substitutes such as OSM and appropriately permissioned photos, or create original authored approximation.
6. If network access is unavailable, do not halt or invent externally researched facts. Use existing sources and clearly labeled approximate placement/height; build an editable data-driven scene that can be aligned later. Do not tell the user you visited Street View unless you actually did and lawful usage is supported.
7. **No interiors**: doors are visual/collision only, player cannot enter. **No NPCs, no LLM, no sex/romance features, no dialogue UI in this session.** You MAY include lightweight data interfaces and clean scene boundaries that make NPCs possible in future.
8. Design for **NVIDIA GeForce GTX 1650 (~4GB VRAM typical) + unknown CPU/RAM**; avoid expansive textures, dense unique materials, full-res photogrammetry, expensive real-time GI. Use configurable graphics quality and LOD/culling/multimesh as appropriate.
9. Prioritize **accuracy of layout/silhouettes and distinct recognizable building exteriors** over a huge polygon budget or excessive detail of one building. Pay special attention to the 2020/2023 new buildings absent from the older illustrated map.
10. Preserve work iteratively, use commits if git is present, log blockers clearly, and test launch if Godot is installed. If runtime not available, run static file and scene consistency tests and provide exact local launch steps instead of falsely claiming visual verification.

## IMPLEMENTATION ORDER
- Establish coordinates and a data-driven registry of residence buildings and pedestrian ways; validate current vs historic building names.
- Build scaled terrain/block layout, real walkable pedestrian links, Residence Lane/Terry Fox Lane, West Campus Road context, accessible paths, greens, parking, retaining walls if supported.
- Build primary unique building silhouettes: North Towers (Pauline Jewett, Barbara Rae, Shadbolt); East Tower; West Tower; Courtyard Residence; McTaggart-Cowan Hall; Hamilton Hall; Shell House; Dining Commons; nine named townhouses.
- Add facade-specific windows, color zones, roof structures, stairs/entrances, canopy, signs, paved plaza, lamps/trees/bike racks if substantiated. Exact facades should be modeled from legitimate reference photos; not just duplicate a cube for every building.
- Finish movement/collisions, day-time lighting, environment fog/sky, performance options, controls/hud with a named location indicator and debug map/teleport optional. Screenshot/test + final README.

## SUCCESS CRITERIA
- Launch directly to a playable full 3D scene (not a 2D map, not a web panorama), third-person WASD + mouse-look + jump/run or equivalent, Esc releases pointer; no falling through terrain, traversable sidewalks, solid building collisions, no accidentally accessible interiors.
- North/east/west layout and relative distances intelligible when compared with reliable OSM-based plans and attached references. All high-priority buildings represented and identifiable, 9 townhouses represented. Visible distinction between tall modern towers and 3-4-storey older residences.
- Clearly delineated **in-scope boundary**; no grand attempt to model SFU in its entirety.
- `README.md` instructions; `docs/RESEARCH_LOG.md`, `docs/ASSUMPTIONS.md`, `docs/STATUS.md`, `docs/NEXT_STEPS.md` in produced project, and `docs/BUILDING_CHECKLIST.md` with one row per building and status/quality/confidence. Build never depends on online APIs at runtime.
- Character and buildings structured for future NPC spawning and online API dialogue interaction, but no NPC code or model downloads now.

## TIME MANAGEMENT — MAX ~5 HOURS
Follow `docs/07_FIVE_HOUR_PLAN.md` strictly. If running behind, progressively downgrade ornamental detail, not playability or overall coverage. Never spend the last hour exclusively researching. At **each** milestone ensure the project still opens. Reserve the last 30–40 minutes for a runnable demo, verification and thorough handoff.

START WORK NOW. Avoid asking routine clarifying questions; make defensible assumptions and document them. Ask only if there is a genuinely blocking user choice. First inspect the repo/environment with `bash scripts/wsl_diagnostics.sh` (read-only), then immediately build the game. Follow docs 13–19; run the WSL smoke test at milestones. Use only installed tooling where possible; do not treat WSL headless smoke checks as visual inspection.

## WSL2 / Godot 4.7.2 binding addendum — mandatory
- The developer already uses **Debian on WSL2**, **Godot 4.7.2 Standard, non-.NET**, **GDScript**, **Compatibility Renderer**, **Codex GPT-6 Astra**. Treat this as the fixed stack, not suggestions. Do not convert the Godot version, install a second Godot blindly or generate C#.
- `game/project.godot` must contain `[rendering]` with `renderer/rendering_method="gl_compatibility"`; ensure actual method in runtime is Compatibility. Prefer OpenGL 3.3-compatible primitive materials/shaders only.
- Make a Windows PowerShell vs Debian Bash distinction. Follow `docs/14_SETUP_AND_INSTALL.md` to report only *missing* dependencies; never claim to know what is currently installed without checking.
- WSLg may provide Mesa D3D12 GPU acceleration or `llvmpipe` software fallback. Record `glxinfo -B`, do not claim the GTX 1650 is being used unless observed. If WSLg unavailable, build and headless-verify and give GUI commands to run locally.
- Do NOT depend on external scenery packages, editor add-ons, Blender, .NET SDK, Docker, Node, CUDA, PostgreSQL or paid map APIs. These are not required.
- Commit/test after vertical slices. Preserve all previous design, source/license, building-register and OpenAI-future documentation.

# 19 — Quality gates, deliverables and final reporting contract

## Command checklist
From package root, Codex must attempt and record:
```bash
bash scripts/wsl_diagnostics.sh
python3 scripts/validate_pack.py
bash scripts/smoke_test.sh  # after game exists
```
If `python3` is not installed, manual JSON check + engine tests are fallback. If a Godot engine is not available to Codex's execution environment, create source files and honestly mark **engine test NOT RUN**.

## Exterior coverage (19 named entries)
The `data/buildings_seed.json` file defines 19 unique building IDs: 3 North Towers, East/West Towers, Courtyard, Hamilton, McTaggart-Cowan, Shell, Dining Commons, 9 townhouses. Check every ID has non-empty scene representation with distinct target materials/silhouettes. A list entry alone is not a modeled building. If a structure cannot be placed with verified data, label ESTIMATED and let it be revised without code rewrites.

## Functionality QA
- Map scale: height of person consistent with doors and sidewalks; stable camera movement; input remappable; no falling through terrain.
- Ground paths cross actual playable terrain without large gaps. Building mesh aligns with collider; collisions close building doorways. No interiors.
- Unique structures: different tower shapes and heights; distinct courtyard structure and dining facility; townhouses identifiable by cluster.
- World correct axes: +X east, -Z north, +Y up, one unit = metre; terrain must allow grades to avoid obviously impossible flat roads.
- Renderer: `gl_compatibility` project property, supports OpenGL 3.3 and Godot Standard 4.7.2, no imported Forward+ dependencies.
- WSLg test: `glxinfo -B` and actual game launch on same machine. Record software acceleration if llvmpipe; do not make fictitious performance claims.
- Reliability: open clean project, headless editor import, run basic game, no missing file errors and no endless external API wait.
- Licenses: OSM attribution/data obligations respected; no map tile/Street View data copied into asset folder; references source provenance documented.

## Explicit out of scope
Interior navigation, NPCs, adult themes, romance systems, OpenAI API key settings, remote API calls, offline models, Steam distribution, Windows export, voice chat, VR, nighttime photorealism, full SFU campus.

## What final Codex response must contain
1. Exact completed game files and run command (from Debian WSL2).
2. WSLg/GPU diagnostic (observed or not observed), Godot version and Compatibility setting.
3. Count of buildings present and which shapes/facades are still estimated.
4. Data source and citation/attribution notes and restrictions.
5. Headless checks vs actual GUI validation **separated**; observed FPS only if actually measured.
6. Missing dependencies, if any; never ask user to reinstall existing tools without evidence.
7. Known issues + top 5 high-value next steps for next session; no unimplemented features claimed as finished.

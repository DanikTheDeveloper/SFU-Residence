# 01 — Scope, boundaries and deliverables

## What we're building
An exploratory **third-person perspective** standalone desktop prototype: user runs/walks around recognizable exterior SFU Burnaby residence buildings with roads, paths, grass, trees, plazas, courtyards and parking. The target **current campus**, not historical snapshot. It should be spatially believable and visually differentiated.

## Precinct boundary (approximate; confirm with independently licensed geometry)
- Northwest/north: University Drive West / West Campus Road, row of residences and townhouses below the road.
- West: Chilcotin/Cowichan/Kimberley/Kitimat/Penticton/Qualicum/Quesnel/Squamish/Kelowna townhouse neighborhood and residence parking access.
- Centre: Hamilton Hall, Pauline Jewett/Barbara Rae/Shadbolt North Towers, Residence Lane, McTaggart-Cowan Hall.
- East/central: East and West Tower buildings, Courtyard Residence, Dining Commons, Shell House; pedestrian links and roadway loops.
- South: south edge of residences, including the immediate northern edge of Field 4 / the visible near sports field boundary and Terry Fox Lane. Sports playing surfaces are only low-detail background orientation, not a playable stadium/field game.
- Exclude academic buildings to the east, university-wide roads/trails beyond the immediate edges, the full West Mall and stadium interior.

**Avoid rigidly hardcoding these verbal edges** if OSM shows nearby residence structures more precisely. Use an irregular playable polygon with natural edge scenery, not a straight walled square.

## Core deliverables
1. `game/project.godot` Godot 4 project and all source assets/scripts/scenes.
2. Playable scene at sensible human walking scale; player movement, look, camera collision, building/terrain collision.
3. Buildings covering residence complex, data-driven IDs, correct relative massing/locations, a recognizable visual style for each category.
4. Walking paths, roads and key connectors; enough landscape and props to resemble a real inhabited complex during day, but **no other characters yet**.
5. No interior routes; building doors/facades are closed visual elements.
6. Original/reusable low-footprint assets; LOD and profile plan for GTX 1650.
7. Development docs and source ledger showing where the geometry came from and what remains estimated.
8. Screenshots from distinct viewpoints if the runtime is available and screenshots can be captured lawfully.

## Fidelity tiers
A. **Required:** correct building list, position/order, major footprints, relative heights and roof silhouettes, paths/courtyards, solid collisions, walkability.
B. **Strongly preferred:** accurate massing segmentation, facade palettes, entrance direction, window patterns, slope changes, sidewalks/lanes/grass, repeated trees and lights.
C. **Only if time:** distinctive awnings, benches, railings, bicycle racks, parking lines, richer vegetation, subtle decals/roughness, day-night slider. No rain/night implementation unless A and B are stable.
D. **Forbidden this iteration:** interiors, characters, romantic/dialogue systems, live maps integration, expensive photogrammetry, interactive campus-wide expansion.

## What not to promise
A pair of reference screenshots and site web pages are not enough to determine every window, stairwell, tree, elevation, and complex roof. Accuracy must be accompanied by evidence confidence; no false 'centimetre accurate' claim.

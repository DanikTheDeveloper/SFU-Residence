# 05 — Architectural visual fidelity standards

## Visual target
Recognizable **real-world contemporary SFU residences**, slightly stylized for real-time performance. Not photorealism, not Minecraft, not 2D, not a collection of untextured featureless boxes. Focus on silhouette, facade colors, building volumes, stories, entrances, landscape paths, slopes and clustering.

## Work from the outside in
1. **Orientation/arrangement**: measured footprints and path junctions are more important than visual microdetail.
2. **Massing**: true relative story counts, multiple building blocks where footprint has wings, primary roofline and silhouette.
3. **Facade signature**: material palette, facade panel rhythm, proper window grid size/spacing and glazing, stairwells, corner/entrance treatment.
4. **Grounding**: foundations/collision, curbs, access walks and connections (not floating doors).
5. **Population of landscape only**: parking and lawns, tree clusters, lamps, a few benches/bike racks, distant foliage; **no human NPCs now**.

## Distinctive materials without copied photos
Use tiling original concrete, brick, plaster, painted siding, metal panels, roofs and glass. Procedural color/noise roughness variation is preferable to scraped Google photos. Avoid using university logos or sign designs unless license/permission is clear; plain text name signs are enough for recognition and debugging.

## Mesh/modularity practices
- Facade parts as reusable modules (window, balcony/railing if real, door/canopy if documented, facade panels).
- Spatial chunking + frustum culling + LOD for windows/trees; combine repeated static meshes or MultiMeshInstance3D when possible.
- Avoid dozens of transparent planes layered inside windows; single glass material with subtle roughness and emissive options only if needed.
- 1k textures mostly; 2k only for rare hero pieces; build texture atlases, avoid lots of 4k images.
- Use basic directional sun, baked/static or economical shadows, light fog/sky; do not turn on heavy SDFGI/SSAO/SSR by default.

## Camera views used for manual validation
1. West townhouse row looking east along inner path.
2. Hamilton Hall toward Pauline Jewett/Barbara Rae/Shadbolt north towers.
3. Residence Lane looking toward modern East/West towers and Dining Commons.
4. McTaggart-Cowan Hall looking north/NE toward the rest of residences.
5. Courtyard Residence/Dining Commons from a near walkway.
6. Bird's-eye **in-game debug camera screenshot** looking north: compare **relative layout** only to compatible map data.

## Distinguish demonstrated fidelity
Do not claim a facade detail is real if it was inferred from generic materials. Record `source_photo`, `observed_feature`, or `estimated_style` with confidence and a timestamp for every building type. A game screenshot cannot prove real-world accuracy by itself.

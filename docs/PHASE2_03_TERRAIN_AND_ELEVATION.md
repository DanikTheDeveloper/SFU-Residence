# 03 — Real topography / hillside engineering

## Evidence-based workflow (highest priority)
**First source to investigate**: City of Burnaby Maps & Open Data (terrain/LiDAR/DEM) and 1m contour data. Source links in PHASE2_16_OFFICIAL_DATA_URLS. Determine licensing/permission, coordinate system, dataset date/coverage, spatial extent and vertical datum before using. Open GIS downloads are not automatically public-domain. If legally accessible, use DEM/contours to derive the actual SFU residence grade. Don't use Google imagery as height/texture extraction.

**World transform**: keep original game XZ layout and scale untouched. Record source CRS (e.g. contours service reports EPSG:26910; verify actual retrieved data). For surveyed `Easting, Northing, elevation`, transform via same existing horizontal anchor/rotation/scale used by the Phase-1 building coordinates. In Godot, X east; Z convention documented, typically north = -Z; Y upward. Normalize elevation to chosen local Y datum but preserve **relative** elevation differences across anchors. If old layout uses different orientation, preserve the old orientation and document it rather than rotating buildings.

**Alignment**: establish at least 3 separated known XZ anchor locations (townhouse zone, East/West Towers/Dining, parking/field); check contour intersection and elevation monotonicity where known. Avoid global scale drift, flip and mirrored maps. Independently compare slope direction to real photo evidence; user says pronounced incline, not an exact measured gradient or which endpoint is higher.

## Mesh and collision
- For gridded DEM, use `ArrayMesh` or `SurfaceTool` terrain meshes and corresponding `HeightMapShape3D` collision built from the *same elevation array*; ensure visual and collision height parity. For irregular terrain or retaining walls, separate meshes and collisions with appropriate shapes. Avoid runtime per-frame mesh regeneration.
- Smooth/interpolate terrain at meaningful sample spacing, keeping real grade and distinct terraces: do not smear over curbs, stair risers or sharp retaining wall transitions.
- Building foundations should be level where evidence supports; step/retain hillside with visible footing, ramps/stairs/retaining walls rather than burying bottom floors or floating building boxes.
- Derive path mesh y from sampling elevation at each vertex; account for width crossfall and joins. Use the same height query for player grounding/debug.
- Protect player spawn positions on terrain; player eye level and slope contact should not clip the ground. Add pathfinding anchors for later NPCs only as metadata.

## If no usable elevation data available within ~45 min
Create `game/data/terrain_anchors.json` with world X/Z and `elevation_m: null` for UNRESOLVED anchors; add provisional artist-adjustable *relative* local elevations ONLY where supported by user/photo evidence, confidence ESTIMATED and explicit not-surveyed note. **Do not silently invent absolute heights or assert a 15-degree slope.** Generate continuous gently varying mesh and iterate while comparing user photographs; leave a clear backlog for later sourced DEM replacement.

## User-visible test
Run from townhouses toward dining area (in BOTH directions) and along the main route; verify noticeable slope, plausible view change, no abrupt invisible collision, ramps/stairs navigable, paved paths contact terrain, entrances accessible at building grades, parking not buried. Take matched before/after screenshot. At performance bottleneck, start with coarser grid and maintain high-fidelity local patches.

## Formal QA
- World scale/transform unchanged for building XZ centers.
- Elevation source confidence recorded: measured vs derived vs provisional.
- No floating pavement, hovering trees, floating doors, wall clipping, underground player/road intersections.
- Grounds and roads survive reload and project restart; no tool dependency for runtime.

# 04 — Georeferencing, geometry acquisition, terrain

## Source priority
1. OSM geometry (subject to license and actual local data quality) for building footprints, paths, roads, grass zones, and parking.
2. Independent open municipal/provincial GIS data if verified accessible and licensed; prefer authoritative, but no time-consuming dataset hunt if OSM suffices.
3. Official SFU facility/housing source for names, floor counts, general exterior characteristics; a floor count ≠ surveyed building height.
4. User maps for orientation and naming (historic map cannot be your geometry authority); not for pixel extraction / tracing.
5. **Estimate explicitly** wherever none exists, preserving layout relationships. Refine in next session.

## Recommended coordinate strategy
- Use a local tangent-plane approximation in metres anchored near the precinct. **Initial anchor proposal only:** `lat0=49.28035; lon0=-122.92769` near Pauline Jewett House (OSM-based published center; check with fresh data).
- X = east, Y = up, Z = south (right-handed world as used by Godot), with lat/lon converted via an equirectangular approximation around local latitude, or a proper local UTM projection. Approx 1 degree latitude ~111,200 m and 1 degree longitude at this latitude ~72,600 m; compute actual conversion instead of relying on rounded figures for large distances.
- `east_m = (lon-lon0) * R*cos(lat0 in radians)*pi/180`
- `north_m = (lat-lat0) * R*pi/180`
- Position = `(east_m, terrain_y, -north_m)`, with `R ~ 6,371,000 m` if simple equirectangular math.
- Heights: keep floor-to-floor as exposed configurable variable; initial heuristic 2.8–3.5 m per floor depending on use, roof/mechanical levels additional. Store values as **estimated**, not surveyed.

## Suggested *query only* OSM region
A preliminary bounding box to validate and edit: `south=49.2785, west=-122.9315, north=49.2818, east=-122.9234` (covers more than residence grounds to avoid cutting footprints). This is **an initial sampling box**, not a precisely approved property boundary. See `docs/12_OSM_DATA_WORKFLOW.md` for sample Overpass QL.

## Building polygon handling
- Preserve OSM way IDs, nodes or coordinate lists, tags `name`, `building`, `building:levels`, `height`, `roof:*`. Split multiple multipolygons and avoid treating internal holes as solid mass. Handle point/line/area features distinctly.
- Polygon extrusion: planar project vertices, simplify only where harmless, triangulate carefully including concavities/holes; height by verified levels or recorded estimates; walls normal/culling correct. Preserve meaningful sub-shapes/wing forms.
- Keep each registered building's `footprint` data separate from generated mesh; use a JSON/CSV manifest and unique stable ID. Allow fine-tuning facade/roof, window count, entrances separately.
- Roof form: document flat vs gabled/complex per source; unknown = neutral placeholder marked estimated. Do not force a common roof shape across all.
- Terrain: start with a gently varying low-cost ground mesh so that movement and roads are usable; if an open DEM licensed and accessible, use it for ground slope, else document height as estimated. Ensure player never walks underneath roads/buildings or floats over slopes. Use gentle ramps where necessary.
- Roads/sidewalks: mesh widths physically plausible, smooth corners, 3D patches matched to ground, navable for player. Use correct intersections and level transitions rather than simple floating texture lines.

## Elevation and scale sanity checks
- Player capsule ~1.7–1.85m tall, walking ~4–5 m/s (gameplay values, not verified geography).
- A 3-storey house should feel visibly shorter than an 8-storey tower; Courtyard 11 storeys the tallest in this list unless geo/photo evidence says otherwise.
- Use map debug overlay and named teleport anchors to verify every P0 structure is reachable. All exit points should remain on walkable ground.

## Fallback for missing OSM/network
Create a data-driven hand-authored approximate footprint set, with source `user_map_context` and confidence ESTIMATED (not 'OSM'). Do **not** pretend that coordinates were read from Google. The site must still be playable, with obvious placeholder/missing-fidelity notes.

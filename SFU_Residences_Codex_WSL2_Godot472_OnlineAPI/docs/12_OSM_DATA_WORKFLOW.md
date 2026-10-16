# 12 — OpenStreetMap building footprint import workflow

## Why
A 3D model can be recognizably positioned if local building polygons, paths, service roads, grass/parking zones are based on OSM or properly licensed government mapping rather than hand-tracing Google imagery. This is a suggested workflow, **not** a guarantee that all SFU buildings have good OSM polygons.

## Preliminary Overpass QL (for testing / adjust bounds)
```
[out:json][timeout:45];
(
  way["building"](49.2785,-122.9315,49.2818,-122.9234);
  relation["building"](49.2785,-122.9315,49.2818,-122.9234);
  way["highway"](49.2785,-122.9315,49.2818,-122.9234);
  way["landuse"](49.2785,-122.9315,49.2818,-122.9234);
  way["leisure"](49.2785,-122.9315,49.2818,-122.9234);
  way["amenity"="parking"](49.2785,-122.9315,49.2818,-122.9234);
);
out body geom;
```

- Use a public Overpass instance carefully with polite request rate and correct HTTP POST. Query failures/rate-limits shouldn't block the world prototype. Read/confirm current OSM API details, site usage rules and sources first.
- Store raw OSM metadata separately from transformed gameplay data: `game/data/osm_source.json` (or `.osm`), `game/data/building_manifest.json`, `game/data/road_geometry.json`.
- Verify named Pauline Jewett way `102388632` and Cowichan way `102388881` if present, and cross-match by tag/proximity; **do not assign building identity based on nearest point alone** when footprints overlap or the tags are ambiguous.
- Convert polygons to metre-space coordinate vectors using a single anchor and project `x=east, z=-north`; preserve original OSM way/relation ID. Account for relation holes and concavity, don't triangulate blindly.
- Record OSM license and attribution in project docs and UI/about if appropriate. Do not strip source tags from the data log. For distributed adapted OSM databases, check ODbL obligations.
- If using government DEM/contours, verify specific dataset's reuse terms, not just 'open data' label.

## Implementation shortcuts
- First pass: get named building centroid, bounding polygon and an extruded mass.
- Later: split into detailed volumes / independent facade modules while keeping accurate footprint stable.
- OSM may contain empty/misnamed buildings, so use official SFU names/floor counts to correct data **with an independent factual source**, not Google tracing.
- For visual debugging, render building ID/name above roofs in developer mode with height/footprint provenance.

## Terrain / paths
- OSM road/path centerlines can become tube/strip meshes of estimated width (explicitly marked estimated). Bridge points, intersections, and ramps correctly. Where footpath connections are absent, create hand-authored connector with estimated flag and don't present it as original GIS.
- Don't overbuild University Drive or academic side of campus; trim to area and hide ending with distant scenery.

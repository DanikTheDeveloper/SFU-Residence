# 04 — Separate roads, pedestrian circulation, paved zones and parking

## Correct the scene graph DATA first
Represent circulation as polygons and centerlines with semantic types, not one generic `road` generator:
- `vehicle_road_marked`: e.g. outside vehicle road, dark gray asphalt/pavement, *line marking ONLY if photograph/source confirms*.
- `vehicle_road_unmarked`: access drive, may be asphalt or concrete according to evidence, no decorative yellow center line by default.
- `pedestrian_concrete`: wide unmarked concrete paths/lanes and pedestrian-only access, subtle seams, curbs, roughness; no road striping.
- `plaza_concrete` and `pavers`: paved courtyard area as polygon, not extruded traffic lane.
- `parking_lot`: paved AREA polygon, access entry/exit, rows of stalls only where orientation/size supported; NOT two disconnected roads. Stall marking white only if seen in source; cars optional (low priority).
- `stairs_or_ramp`: follows terrain grade and real access links.
- `grass`, `soil`, `retaining_wall` as terrain-adjacent types.

## Phase-1 migration specifics
Inspect existing road data structures; add classification fields or a facade/material override layer rather than replacing every route's XZ geometry. Find what the user describes as the parking zone and turn its visual/collision surface into a lot polygon while preserving ingress/egress path anchors. If parking outline unavailable, create an estimated but clearly labelled lot area and a `needs_photo` annotation. Preserve vehicle accessibility.

## Visual realism in Compatibility Renderer
Prefer correctly colored PBR `StandardMaterial3D` roughness, subtle shared tiling textures and physically plausible seams. Optional legally sourced material textures can be placed in `game/assets/materials/` with attribution; start with original procedural detail. No real-time Decal3D reliance in Compatibility — stripe/seam/crosswalk markings can be thin coplanar-safe overlay meshes at a controlled offset, or built into small material atlas/UV geometry. Avoid overly dark glossy roads, asphalt everywhere, cartoon color swatches or repeating grid of excessive cracks. Use a small set of materials and rational UV scale.

## Visual acceptance
Screenshot both vehicle perimeter and pedestrian lanes at human eye height. Painted lines should not appear on unmarked concrete. Parking must read as a PARKING AREA (wide open surface and stalls where observed) with actual access. Paving must follow actual slope with no gaps or z-fighting. Compare gray balance with photos, not arbitrary bright colors.

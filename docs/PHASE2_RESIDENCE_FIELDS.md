# Residence sports fields — current evidence and implementation

Reviewed 2026-10-18. Three distinct mapped venues are retained; Field4's facility outline and playing polygon are the same venue, not two fields. Source IDs and original projected polygons are in data/site_sources/residence_fields_projected.json.

## Field4
The former anonymous green quadrilateral is replaced by OSM32528090. Separate local grading is estimated at -1.52m (median of existing terrain), 3m collar and 18m outer blend; original source elevations and building pads are untouched. Soccer lines and two goals are original batched meshes, based on the official SFU photograph. Detailed dimensions/fixture placement are provisional. No copyrighted pixels are game textures. Study boundary unions the mapped polygon with an 8m margin.

Source: https://www.sfu.ca/recreation/info/facilities.html ; image URL and observations in reference_photos/Sports_Fields/ONLINE_REFERENCES.json. Photograph date unknown. Official text describes artificial turf, soccer/lacrosse, two coaches booths, lighting and 360 seats. Booths, stands, lighting and exact scoreboard placement are still pending; do not invent them as verified.

A new traversal initially failed because a 41m segment exceeded the harness's 500-frame travel budget at 4.5m/s. Intermediate checkpoints now cover the same route. This was not proof of a physical wall; the initial diagnosis was revised after reproducing the timeout.

## Field2 (verified first pass)
User identifies the eastern field beside McTaggart as the second part of Beedie and describes football use. Official SFU labels this Field2 and lists rugby/soccer. Its specific photograph includes an Athletic Field2 sign, dry natural grass and tall H-shaped posts. Preserve the user's location clarification while retaining official venue naming and uncertainty about American football markings.

Original OSM32528091 extends to Z257.972, beyond old terrain Z240. scripts/build_field2_grade.py generates a separate appended-row extension to Z280 using original licensed City of Burnaby contours, six local smoothing passes and a 20m seam-offset blend. It does not overwrite terrain_grid.json. A separate finished-field grading layer is provisional. No arbitrary global vertical scaling.

## Remaining shared work
Accurate approaches, seating, pole/scoreboard locations, perimeter fences where evidenced, field-specific surface transitions and richer forest-edge planting. Beedie's sunken dugouts, bleachers, bullpens and batting cage remain unfinished. Current photographs supersede obsolete street imagery for modern buildings and surfaces. Maintain continuous access and verify new terrain/collision coverage before claiming completion.

Field2 runtime integration verified:215 physics checks and385 route checkpoints, including old/new terrain seam and extended-field crossing. Field4 verified checkpoint681cade. See STATUS/HANDOFF for captures and remaining limitations.

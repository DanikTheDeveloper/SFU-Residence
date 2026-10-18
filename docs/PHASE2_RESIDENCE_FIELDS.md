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

## User visual correction — 2026-10-18, after portico checkpoint
User accepts locations of all three fields but rejects their current visual resemblance. Field realism is now the next priority, ahead of the previous Courtyard continuation. Specifically identify and recreate the BLACK walk-in booth/shelter on the residence-facing side of Field4 directly behind East/West Towers. User initially mentioned McTaggart but explicitly corrected to East/West; do not place it at Field2 based on the initial wording. Open shelter access is requested; do not turn this into residential interior scope.

Official SFU Recreation lists TWO coaches booths on Field4, but identity of the user's black shelter is NOT yet visually confirmed. Do not substitute a generic dugout, a Beedie softball shelter, or Terry Fox stadium booth. Research exact Field4 photos, match residence-side orientation, inspect roof/sides/openings/bench/base/fence/adjacent paving and then implement a physically enterable exterior shelter with collision and eye-level capture. Preserve approved tower models and field footprints. Reassess all three fields' surface colours, line layout, perimeter structures, vegetation and approaches against specific photographs; current fields are explicitly only first passes, not photo-matched finished models.

Sources found in targeted search (not yet visually reviewed in this follow-up):
- https://www.sfu.ca/recreation/info/facilities.html — official Field4 artificial turf, two coaches booths, lights,360 seats; text checked.
- https://sfulacrossecamps.com/2015/12/20/accomodations/ — dated2015 Field4/residence panorama; historical surroundings and towers must not overwrite modern buildings.
- https://www.flickr.com/photos/drowcliffe/6995171797 — titled SFU Field4 view from southeast; historical2012-era candidate, copyright/visual-reference only.
- https://icsf.ca/fields-facilities/sfu-4 — exact field page, candidate for current evidence.
Broad image search returned mostly OTHER venues/commercial dugouts; rejected as identity evidence. None downloaded or modeled. Field2/Beedie need equally specific comparisons, not generic sports assets.

Actual host usage94% consumed during this follow-up. Saved research/priority correction only; runtime unchanged from2f8385f, so no repeated game tests needed. Continue next user-started window from this section. Earlier218 physics/389 route passing checkpoint still applies; it establishes playability, not visual fidelity.

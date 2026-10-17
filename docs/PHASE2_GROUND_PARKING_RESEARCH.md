# Ground, parking and planting evidence — 2026-10-17

## Residence Main Lot
This lot was entirely absent from the original three parking polygons, which cover townhouse parking. Added a separate runtime site layer, preserving original site.json, all building coordinates and roads. OSM way 32528160 version 8 (2023-04-05) describes Residence Main Lot, surface=paved. Its geometry is used in the existing geographic projection. Current version 9 is Phase 3 construction; the reconstruction uses the full pre-construction lot as a reversible working assumption following the user's request. No construction building was added.

Sources:
- https://www.openstreetmap.org/way/32528160/history (ODbL; downloaded XML under data/site_sources)
- https://www.sfu.ca/students/residences/community/construction-updates.html (Phase 3 occupies Residence Main Lot; current construction differs from intended parking reconstruction)
- https://www.sfu.ca/stayhere/groups/private-residence-rooms.html and its photo https://www.sfu.ca/content/sfu/stayhere/groups/private-residence-rooms/_jcr_content/main_content/image_1187063833.img.original.low.jpg/1705008533232.jpg (visually reviewed online: identifiable North-family rear elevations, parked cars and deciduous trees along buildings; individual tower not certain, image date unknown; reference only, no pixels redistributed). The tightly cropped ground does NOT establish exact markings, drainage or kerb dimensions.
- User supplied historic virtual-tour map corroborates main-lot location, not surveyed dimensions.

User confirms the lot is levelled. `scripts/build_parking_grade.py` creates a reversible runtime height delta, keeping the original terrain grid and elevation source intact. Target 8.87m in game coordinates is the median of the existing contour-derived samples under the mapped lot, NOT a surveyed finished height. The core is flat; the surrounding 26m transition is restricted on the south to preserve North foundations and gallery. The first unrestricted transition failed gallery traversal; it was rejected and corrected. Four core level checks pass, all existing pedestrian loops pass, and a new eight-point access/aisle traversal passes. Exact retaining-wall/stair layouts remain unresolved and are not claimed reconstructed.

Parking stall count/spacing and occupancy are still estimated. Cars use CC0 Cosmo models, not surveyed exact parked makes. Preserve service/pedestrian clearance. Aisle locations and empty tower-side stalls need more photographic/site-plan evidence; do not claim an exact stall plan.

## Surface sections
`data/surface_evidence_index.json` lists EVERY one of the 398 road/path segments, source way ID, source URL, mapped surface tag and confidence. OSM API returned 114 ways. Explicit asphalt/concrete/concrete:plates/paving_stones/dirt/ground/compacted tags drive runtime overrides; generic paved is deliberately insufficient to infer a precise material. 95 pedestrian segments now use explicit mapped finishes; 110 retain default concrete, 102 use townhouse photo interpretation, one uses handpicked East pavers; 90 vehicle segments remain asphalt.

Photo evidence for East pavers takes precedence over generic tags. Mapped tags are evidence, not field verification; they can be stale. Original path positions and widths are unchanged. New slab joints and aggregate textures are original artwork; dimensions are estimated. `game/data/surface_overrides.json` is keyed to original segment order and should be regenerated if the road database changes.

PWL's official project page https://www.pwlpartnership.com/projects/sfu-residences describes structured courtyards, green connecting corridors and a consistent landscape palette (2016–2023). It does not supply a per-path material specification. Do not transfer details from unrelated PWL projects or the separate SFU North Parking Lot near the academic campus.

## Vegetation research
Current OSM precinct extract has no individually mapped trees. It does contain wooded polygons and grass polygons; these can constrain planting regions but not exact tree counts/species. The named Madge Hogarth Garden has level=2, so it must NOT be scattered onto ground terrain. Official North photo confirms deciduous trees by rear elevations; individual positions/species need estimates. Existing random cone/sphere trees are not photo-verified.

## Verified checkpoint
/tmp/main-parking-restricted-verification.log: 184 checks, all original 333 route checkpoints plus 8 main-lot checkpoints, zero failures. GTX1650 Compatibility capture /tmp/main-parking-capture.log completed; three main-lot views inspected. Approved East/West master, facade kit, original pads and original source terrain remain unchanged. Runtime local grading is intentionally changed. FPS shares load with an existing user game.

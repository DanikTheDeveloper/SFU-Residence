# Beedie Field — exterior checkpoint, 2026-10-18

## Evidence and scope
User-requested Beedie Field (not "Biddy") is mapped as OSM way32528092, with sport=softball and surface=grass. Source: https://www.openstreetmap.org/way/32528092 . Original projected outline retained at data/site_sources/beedie_field_projected.json, runtime record game/data/beedie_field.json. OSM geometry is not a survey.

Official SFU Athletics facility description: https://athletics.sfu.ca/sports/2012/7/10/SB_0710124436.aspx . Supports grass sports turf, sand/silt infield, synthetic rubber warning track, six lighting poles and50ft sunken concrete dugouts. Reference-only panoramas uploaded2012, including https://athletics.sfu.ca/images/2012/9/3/TWO.jpg (Jasper Chan credited), show a dark blue outfield screen with yellow cap, tall backstop, pale dugout roofs and red scoreboard. Do not claim these historical photographs establish every present-day fixture. Metadata in reference_photos/Beedie_Field/ONLINE_REFERENCES.json; no reference pixels shipped.

## Implemented first pass
Separate BeedieField.gd: original turf/infield/warning-track meshes, fence and backstop, static line/base markings, six unlit pole assemblies, two open-sided roofed shelter representations and simplified scoreboard. No sports gameplay, NPCs, interiors or realtime floodlights. Pole/fixture positions, heights, gate, dugout depth, infield29m radius and marking dimensions are estimates. Regulation-like18.288m baseline/13.11m pitching distance are modeling assumptions, not measured Beedie values. Dugouts are NOT yet sunken correctly and lack their specific concrete walls, bleachers, surrounding bullpen/batting cage and concession structure.

## Ground and boundary
Existing smoothed contour surface varied from about-3.12m to+2.19m across the field, unsuitable for a playing surface. scripts/build_beedie_grade.py creates a separate reversible1997-sample layer, game/data/beedie_grade.json. Level0.48m is the median source terrain under the mapped field, NOT surveyed finished elevation. Flat core/3m collar,14m smooth surrounding blend,4m building exclusion and another4m protection ramp. Original terrain_grid.json and source elevations remain unchanged. Approved building pads are untouched.

Runtime study boundary unions the original boundary with an8m buffer of the actual field footprint. This removes the former boundary wall through the outfield without moving or clipping the field or altering original site.json. Other original geometry and routes remain preserved.

## Verification
Pending current regression and eye-level GPU capture. Added level-surface/boundary checks and a continuous10-point gate-to-outfield traversal. Do not treat a successful import as visual approval. Logs: /tmp/beedie-verification.log and /tmp/beedie-capture.log.

## Remaining fidelity
Historical photo/date caveat; actual finished level/drainage fall; sunken dugouts; correctly located scoreboard supports/foul poles; bleachers, bullpens and batting cage; fence mesh is a simplified square grid rather than chain-link; landscaping beyond outfield and current campus-side approach paving. No branding photo or fabricated active game score used.

Beedie first pass verified: /tmp/beedie-verification.log passes191 physics checks and358 continuous route checkpoints (including10 through field gate/outfield),376 terrain-ray samples, preservation and family validators. Initial GTX1650 Compatibility capture complete; field_0 and field_3 visually inspected. Final capture repeats after replacing patterned procedural turf noise with seeded random grain. No isolated FPS claim; remaining details in PHASE2_BEEDIE_FIELD.md.

Final GTX1650 Compatibility capture /tmp/beedie-final-capture.log completed after turf grain adjustment; field_1 inspected at eye level. The initial distinct linear noise pattern is removed. Runtime tests remain191 physics checks/358 route points/0 failures; only turf texture generation changed afterward.

## Beedie seating follow-up — in progress2026-10-21
Re-viewed official SFU Athletics TWO.jpg (2012 upload, Jasper Chan). Light metal spectator seating visible behind backstop. Added original batched8m three-tier seating section, footboards, grounded supports and rear rails near[94,124]; dimensions/count/placement estimated. Not a claim of current surveyed layout or completed sunken dugouts. Added seat-collision probe and field capture view. Full verification /tmp/beedie-seating-verify.log pending; preserve field gate and existing routes. Current official facilities page still lists50ft sunken dugouts/batting cage, but no evidence obtained for exact as-built coordinates.

Seating pass verified295 physics/376 terrain/524 routes, zero failures; --capture-seating view inspected. Original batched geometry; exact3-row/8m layout estimated from historical reference. Remaining dugouts, bullpen, cage and fixture survey stay pending.

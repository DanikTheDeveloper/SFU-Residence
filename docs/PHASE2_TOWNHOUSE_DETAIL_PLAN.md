# Townhouse detail plan — user photo priority, 2026-10-16

## Correction accepted
These are attached individual three-level houses grouped in nine blocks, not generic apartment slabs. Four bedrooms per unit; exterior reconstruction only. Preserve mapped nine footprints, but articulate individual doors, porches and house-width facade modules. Existing model's uniform3.5m window grid was inadequate.

## User-selected evidence inspected
- 1752685165951.jpg and17526851659512.jpg: close frontage, orange/red individual doors, blue lap siding, deep white porch beams/posts, grey masonry base, projecting middle-level window bays, small upper balconies, eave rafters and gutters. Exact pictured block unresolved.
- 16360616545524.jpg: end house and hip-roof porch, white vertical trim, paired tall windows, lower stonework.
- images.jpeg: paired doors beneath shared porch, substantial white posts on masonry bases, visible soffit framing.
- images (1).jpeg: front elevation shows house-width rhythm, balcony offsets and roof stacks.
- images (2).jpeg: narrow frontage walkway, porch depth and downpipes.
- images (3).jpeg: three-storey end massing, shallow hipped main roof, roof stacks, hillside stairs and retaining edge.
No people or photographic pixels are copied into the game. SHA256 inventory: data/user_photo_inventory.json.

## This implementation
Shared TownhouseBlockExterior.gd now uses approximately5.2m mirrored house modules with shared paired porches on longitudinal facades, with separate red doors, side ground windows, white porch posts/beams, shallow pitched porch covers, masonry bases, middle-floor projected frames, top-floor balcony rails, deeper blue siding and eave rafters. Principal footprint axis identifies longitudinal sides. These are photo-informed modules, not survey-verified unit positions/counts. Main footprints and three-floor registry unchanged. East/West files untouched.

## Official plans located
All nine block-plan links recorded in reference_photos/Townhouses/ONLINE_REFERENCES.json and central online index. All nine ground-floor drawings visually inspected with bundled Poppler; Chilcotin levels2/3 also inspected. Detailed per-block labels and orientations recorded in data/townhouse_plan_observations.json. SFU page says96 total units and11 per building; do not normalize9x11 into99. Ground plans label units01 through99 across nine blocks,11 per drawing. This conflicts with96 on the current webpage; treat operational total as unresolved. Laundry is shared across the complex; user reports attached laundry rooms at some blocks. Identify annex outlines and exact blocks before adding them.

## Next detailed passes
1. Georeference the nine inspected plan diagrams to the unchanged world footprints. Common-end orientation varies; PDF left/right is NOT compass direction. Chilcotin common annex is absent on upper levels, supporting a lower service volume once its world location is established.
2. Match each user photograph to named block and facade. Retain UNKNOWN where no sign/geographic proof exists.
3. Replace estimated module spacing with per-block unit layout, including end-house and laundry variants.
4. Improve true bay-window side glazing, hip porch roofs, gutters/downpipes, roof stacks and stepped foundations/doorstep grading.
5. Check porch-post collisions and clear pedestrian passage; current thin porch decoration is visual-only, building shell collision retained.
6. Repeat first-person captures from frontage/end/approach and full continuous routes after collision changes.

## Deferred buildings, explicitly requested
- North family: user identifies an open ground-level hallway through the towers. Photo-03-1024x672.jpg visibly supports open space beneath a wing, columns and glazed entry; 1790722544125.jpg shows stairwell glazing, projecting lounge bays, concrete fins and slab edges. Current solid ground shell is inaccurate there. Locate exact opening/columns from plans, then cut geometry AND collision for a traversable exterior passage. Keep one shared North master, individual placement/entrances.
- Hamilton: new1638917139878.jpg has readable Hamilton Hall sign, resolving earlier identity doubt. New1726522334676.jpg matches four-storey grey siding/white window frames, projecting window groups, broad concrete entrance canopy on round columns, stone base and multicolor pavers. Use these before online alternatives; implement a distinct family in a later checkpoint.
- Other new photos: inventory preserved; inspect individually before use. Do not assume every image in a combined folder depicts a North Tower (a filename explicitly says Dining Hall).
- East and West: user repeatedly approves appearance and forbids remodel. Protected hashes remain binding.

## Plan review outcome
All nine published ground plans share11 numbered houses, four pairs of doors on the long sides, a pair at one end and a single house beside common rooms at the other. Common room labels vary by block. Ground-only service volume is explicit in Chilcotin levels2/3 comparison. The current runtime still uses uniform3-floor block massing and estimated facade segmentation; the asymmetric common annex and exact11-door mapping are NOT implemented yet. Do not describe these remaining differences as verified reconstruction. New rendered references stayed in temporary local research storage, outside the game, with URL provenance retained.

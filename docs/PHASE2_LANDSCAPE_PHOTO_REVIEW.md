# Landscape photo review — 2026-10-17

All four supplied Terrain_and_Stairs photographs inspected individually; searchable observations in PHOTO_REVIEW.json in that folder.

1001 identifies Shadbolt by its sign and establishes concrete stairs, light sidewalls, silver rails, inset step lamps and grey staggered rectangular approach pavers. 1025 shows modern tower courtyard planting and an open-frame charcoal light. 1029 supplies a close-up of paver bonds, light concrete edging and linear drainage. 1068 establishes overall planted precinct context but predates the completed Dining expansion.

Current increment: ResidencePavers.gd, an original 256px mipmapped running-bond texture, with building-aligned metre-scaled UVs for the existing North courtyard apron only. Dimensions (400 x 200 mm) and apron extent are estimates. Gallery circulation remains concrete; no changes to terrain, route heights or protected building models.

Pending: exact stair-to-gallery connection and step count; planted-bed boundaries; locations of drains and light columns; species identification. Do not scatter these props or invent measured coordinates from close-up photos.

Open-frame charcoal courtyard fixtures now replace generic pole/cap shapes at existing estimated points within 45 m of modern-tower centroids. This changes fixture shape only; neither exact locations nor dimensions are surveyed. Two shared MultiMeshes, no extra dynamic lights or collision obstacles. PWL 1025 is the shape reference; East/West building masters remain untouched.

Stair-location audit: archived prototype source OSM 1159793611 runs from (112.856,8.273) to (110.252,19.715), beside the inter-house gap. Shadbolt photo entry registry is (118.507,40.275), and its long-wing centre is about (144.69,31.90). That segment cannot simply be asserted to be the foreground flight in PWL 1001. The old prototype's six broad treads over 11.7 m also do not match the compact photo flight. Keep archived until independently localized; do not restore based only on nearby house identity.

Validation: 177 checks and all 333 route checkpoints passed. North views 13/14 visually inspected; paver tones reduced after first capture and final landscape_0 inspected. Dedicated --capture-landscape now captures the apron and fixture in two views.

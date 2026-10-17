# Hamilton Hall photo/model review — 2026-10-16

All three user-selected photos inspected individually; searchable provenance and SHA256 in reference_photos/Hamilton_Hall/PHOTO_REVIEW.json.1638917139878.jpg has readable Hamilton Hall identification;1726522334676.jpg matches its architecture.1726522313260.jpg shows a different modern envelope and is excluded pending identification. Dates/rights/compass orientation unknown; no pixels redistributed as textures.

## Implemented first detailed exterior pass
HamiltonExterior.gd is a distinct reusable master using common FacadeKit batching without changing FacadeKit. Four floors and original eight-vertex footprint retained. Grey stucco body, projecting paired glazed stacks, horizontal light-grey siding, white frames, lower transoms, narrow operable-light dividers, occasional opaque curtain strips, stone base, overhanging fascia/gutter/downpipes, broad columned flat entrance portico and sealed glazed entrance. Textures are original procedural patterns. No interiors.

## Uncertainty and follow-up
Exact bay count, projections and colors are photo estimates, not measured. Official SFU level2 plan (linked in ONLINE_REFERENCES.json) explicitly orients north toward the Towers and shows the central north projection. Together with the sign photo this supports relocating the broad portico composition to the central north face. The exact ground door is still inferred: the public PDF has no ground-floor plan. Old east route anchor and a small closed secondary door remain; original registry unchanged. First attempt at a broad east-end portico blocked all3 route loops; rejected and replaced before checkpoint. Portico11m span/2.1m depth are estimates. The initial3.2m depth placed a support on an existing path; reduced depth and supports inside the frontage apron preserve the original pedestrian corridor. Original flat-roof body retained with photo-visible eave treatment; roof pitch/hidden elevations unknown. Paving pattern confirmed, exact plaza boundary unverified. Keep modern mismatched photo excluded.

Verified173 physics checks,333 route checkpoints and protected-runtime/family checks. Final GTX1650/Compatibility capture complete; facade, north entry and close-up paver/door views inspected. Exact bay count and ground entrance measurements remain estimated.

Paving: HamiltonPaving.gd generates original grey/brown rectangular pavers with a pale band, mapped in building-aligned UVs onto terrain triangles. Small12m×3.4m frontage apron only; no terrain/collision or original road polygon edits.

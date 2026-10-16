# 05 — Evidence-first photo intake (organized by visual family)

Use the NEW outer `reference_photos/` layout documented in `reference_photos/README.md`. Important: `East_West_Towers/` is **one combined folder** for East + West current towers, with explicit building name in filename, and `Townhouses/` combines all blocks. `Barbara_Pauline_Shadbolt/` is ONE combined North Towers folder for Barbara Rae, Pauline Jewett and Shadbolt (photos labeled individually). Dining Commons, Courtyard Residence, Shell House, Hamilton Hall and McTaggart-Cowan Hall are separate. For parking, paving, grade and stairs, use their dedicated context folders.

## Naming and minimum coverage
- `East_Tower__front_entrance__2026-10__self.jpg`; `West_Tower__side_west__date_unknown__source.jpg` **both in `East_West_Towers/`**. If tower ID is uncertain, `Unknown_Modern_Tower__view_unknown__date_unknown.jpg` and flag UNKNOWN; never infer East/West door from it.
- `Barbara_Rae_House__entrance__2026__self.jpg`, `Pauline_Jewett_House__...`, `Shadbolt_House__...` ALL inside `Barbara_Pauline_Shadbolt/`; if not identifiable label `Unknown_North_Tower__...`.
- `Townhouse_Block_03__front__2026__self.jpg` in `Townhouses/` if block number is VERIFIED against Phase1 mapping; otherwise `Unknown_Townhouse_Block__front__...`.
- At minimum for a photo-matched family representative: front facade/entrance, angle/corner, side or rear, window/material close-up and ground-grade context. Every other instance needs photos of its OWN door and any distinct facade/roof features before those attributes are marked VERIFIED.
- No photos bundled in this ZIP. Sourced images must be lawful; reference use does NOT equal license to redistribute textures. Avoid people/plates/private details as relevant.

## Data
Create local `data/photo_manifest.csv` from `data/photo_manifest.template.csv`; add `family_id` and `building_id` for each image. `UNKNOWN` where uncertain, especially photo era/location/direction/source/usage rights. `data/architecture_families.json` is authoritative for family names. `scripts/photo_inventory.py` reports counts by family/building from filenames and folders; a name is not proof of content.

## Procedure (each photo, then family verification)
1. Inspect each source image individually, record its actual building identity, orientation and era. Old Google imagery can have outdated East/West construction, so do not rely on it for current facade, doors, colors or roof details.
2. Log visible color blocks, material transitions, floor rhythms, bay counts, glazing/mullions, door placement, roof/parapet and site elevation, citing filename; mark hidden elements unknown.
3. Separate genuinely shared architecture from individual variants across East/West, the three North Towers or townhouse blocks. Keep per-instance door/grade and floor count even when facade modules are shared.
4. Estimate ratios, not undocumented metric survey. Build reusable facade meshes/materials; photo-match one representative first, then instantiate verified common forms across matched siblings.
5. Render at human-eye camera near the photograph viewpoint, compare silhouette, color, window spacing, roof, doors and approach paving. Record before/after screenshot and unresolved issues.
6. On family/instance QA, show a family-wide edit propagates, but instance parameter changes do NOT accidentally change siblings' doors or floor counts.

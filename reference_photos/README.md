# User photo intake — one directory per shared architectural family

Put your OWN/reference-licensed photographs into these folders. The ZIP contains only placeholders, not photos. A photograph is evidence for the actually pictured building, even when several buildings use the same model master. A directory does NOT validate a photograph's date, building identity, view direction or permitted use.

```text
reference_photos/
  East_West_Towers/           # one shared East/West architecture family
  Barbara_Pauline_Shadbolt/  # one shared North Tower family, ALL three buildings
  Townhouses/                # all real townhouse blocks
  Hamilton_Hall/
  Courtyard_Residence/
  Shell_House/
  Dining_Commons/
  McTaggart_Cowan_Hall/
  Parking_and_Paths/
  Terrain_and_Stairs/
```

## Recommended filenames

- `East_West_Towers/East_Tower__front_entrance__2026.jpg`
- `East_West_Towers/West_Tower__roofline_from_road__2026.jpg`
- `Barbara_Pauline_Shadbolt/Barbara_Rae_House__front__2026.jpg`
- `Barbara_Pauline_Shadbolt/Pauline_Jewett_House__entry__2026.jpg`
- `Barbara_Pauline_Shadbolt/Shadbolt_House__corner__2026.jpg`
- `Townhouses/Unknown_Townhouse_Block__street_side__date_unknown.jpg`

For uncertain building identity, use `Unknown_North_Tower__...` or `Unknown_Modern_Tower__...`, then enter `building_id=UNKNOWN` in the local photo manifest. Label building-specific doors and ground elevations independently: sharing a master does not guarantee identical entrance placement.

## Why a combined North Tower folder?

Barbara Rae, Pauline Jewett and Shadbolt are user-confirmed identical-looking architectural designs. Analyze their photos together to derive ONE reusable North Tower exterior master; only instance-specific settings such as geolocation, heading, terrain height, signs, entrances and evidence-backed exceptions differ. **Do not remodel the three independently.** SFU insurance inventory lists 8 floors each.

## East/West roof alignment

The shared modern exterior master has independently configurable floor count (officially East 7, West 8), podium, foundation and roof details. User reports visually aligned roofs; confirm using photos from points showing both rooftops and legitimate elevation data. Do not assume both foundations have the same Y or artificially move the roof. User's West-higher/one-floor-shorter recollection conflicts with published floor totals; record that separately rather than guessing.

## Old directories from previous ZIP revisions

Do not delete photos in older `North_Towers/Barbara_Rae_House/`, `North_Towers/Pauline_Jewett_House/`, `North_Towers/Shadbolt_House/`, `North_Towers_Barbara_Rae/`, etc. Use `python3 scripts/relocate_legacy_photos.py --root .` to preview, then `--apply` to make **copy-only** migrations into the new combined folder. The script prefixes the building identity on copied filenames, refuses conflicts, and does not delete or overwrite originals. Also handles legacy separate `East_Tower/` and `West_Tower/` directories.

Collect entire facades, doors/ground-level connections, corners, roofline comparisons and window/material close-ups. Record evidence in `data/photo_manifest.csv` following its template. Use only lawfully obtained photos; not all photos can be redistributed as game textures.

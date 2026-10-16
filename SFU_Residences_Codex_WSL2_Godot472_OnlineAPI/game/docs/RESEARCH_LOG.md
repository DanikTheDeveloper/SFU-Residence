# Research and provenance — 2026-10-15 (America/Los_Angeles)

The package's AGENTS.md, CODEX_TASK_PROMPT.md, QUICK_START_RU.md and all docs 01–20
were read before implementation. Both supplied reference images were inspected
for scope/historical context. Neither was traced, sampled, or placed in the game.

| Source | Actually used | Rights / confidence | Gap |
|---|---|---|---|
| [OSM API extract](https://api.openstreetmap.org/api/0.6/map?bbox=-122.9315,49.2785,-122.9234,49.2818) | Raw nodes, named building ways, roads, footpaths, parking; cached in `data/osm_source.osm` | © OpenStreetMap contributors, ODbL 1.0. VERIFIED records, not survey verification | No verified vertical dimensions or terrain; current mapping may lag construction |
| [SFU insurance facts](https://www.sfu.ca/students/residences/moving-in/insurance.html) | North Towers 8, East 7, West 8, Courtyard 11, Hamilton/McTaggart 4, townhouses 3 floors | Factual descriptions verified on page; images not reused | Floor-to-floor heights remain estimated |
| [SFU East/West](https://www.sfu.ca/students/residences/housing-options/east-west-towers.html) | 7/8 storeys and first two amenity levels | VERIFIED text; no asset reuse | Exact window rhythm unmeasured |
| [SFU North Towers](https://www.sfu.ca/students/residences/housing-options/towers.html) | Three identities; seven-floor marketing discrepancy retained | VERIFIED source text; no photo reuse | Uses eight overall levels supported by insurance and OSM |
| [SFU townhouses](https://www.sfu.ca/students/residences/housing-options/townhouses.html) | Nine names cross-check | VERIFIED text | Current roof/siding details not measured |
| [SFU Courtyard](https://www.sfu.ca/students/residences/housing-options/courtyard-residence.html) | Current residence identity | VERIFIED page | No facade photos distributed |
| [SFU facilities directory](https://www.sfu.ca/fs/campus-maps/directory-of-buildings.html) | Building identity context | Factual reference only | Not used as a geometry dataset |
| [DIALOG Phase 1](https://dialogdesign.ca/projects/simon-fraser-university-phase-1-student-residence/) | U-shaped towers; brick/natural copper material description | VERIFIED architect text. Original estimated material placement/palette | No measured facade divisions; no downloaded imagery/textures |
| [DIALOG Phase 2](https://dialogdesign.ca/projects/simon-fraser-university-phase-2-student-residence/) | Precast, contrasting textures, vertical glazing, sensory garden context | VERIFIED architect text; original approximate modules | No measured panel pattern, tiered height or garden plan |
| [DIALOG Dining Commons](https://dialogdesign.ca/projects/simon-fraser-university-dining-commons/) | Three levels, extensive glazing and patio description | VERIFIED architect text | Conflicts with OSM's 2 levels; use 3, exact split-level form unresolved |
| [OSM copyright](https://www.openstreetmap.org/copyright), [ODbL](https://opendatacommons.org/licenses/odbl/1-0/) | Attribution and derivative data notice | License sources opened | Preserve notices and machine-readable data with distribution |
| [Overpass API documentation](https://wiki.openstreetmap.org/wiki/Overpass_API) | Endpoint/query and responsible retrieval guidance | Technical reference | Overpass requests failed; direct OSM API succeeded |

Retrieval failures: Overpass main POST 502, private.coffee POST 500, main GET 502.
The bounded direct OSM map request succeeded with a ~701 KiB XML extract. The game
does not make this request: acquisition is build-time only. The offline importer
preserves way IDs and tags and chooses buildings by named, explicitly mapped IDs,
not nearest-neighbour guesses. No building multipolygon relations appeared in this
extract; all 19 selected buildings are closed simple ways, including concave forms.
Unsupported relations must be reviewed before using a future replacement extract.

Raw OSM tags retain historical `source=Bing` entries entered by OSM contributors.
This project consumed the licensed OSM database; it did not access or trace Bing or
Google imagery. External photo links were checked but no external photo pixels were
used to produce assets. Architectural detail beyond the factual descriptions above
is ESTIMATED, not visually verified against photographs.

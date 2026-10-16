# 02 — Verified reference URLs, visual sources, provenance

Sources checked **2026-10-15**. These URL references support facts; availability, layouts, and usage permissions should be rechecked by Codex. No third-party site images are packaged here.

## User-provided map references
- `../references/sfu_old_residence_virtual_tour_map.png`: old illustrated SFU residence plan. **Historically informative; missing later East/West/Courtyard buildings**. Colored polygon footprints are schematic; do not treat them as cadastral data. It includes older residence naming conventions and locations.
- `../references/sfu_residences_modern_map_screenshot.png`: modern close-up showing Pauline Jewett, Hamilton Hall, McTaggart-Cowan, West Tower, Residence Lane, townhouse row, Field 4, Beedie Field, Dining area at east edge. **User-provided overview only.** It may contain proprietary map provider graphic content; do not sample pixels, trace geometry, generate textures, or redistribute as a game asset.

## Official primary SFU sources (most useful)
1. SFU Residence & Housing options — https://www.sfu.ca/students/residences/housing-options.html
   - Up-to-date categories, descriptive exterior photos. Viewing pages is not permission to distribute images or photo-textures.
2. East/West Towers — https://www.sfu.ca/students/residences/housing-options/east-west-towers.html
   - East Tower 7 storeys; West Tower 8 storeys. Descriptive video footage may help distinguish architecture if used lawfully for manual orientation; do not rip textures or videos.
3. North Towers — https://www.sfu.ca/students/residences/housing-options/towers.html
   - Pauline Jewett, Barbara Rae, Shadbolt. NOTE: page says seven floors in one marketing context, while the SFU tenant insurance page calls each eight. Treat as a documented inconsistency (perhaps floors accessible to residents vs overall building); **verify facade count** before exact height.
4. McTaggart-Cowan Hall — https://www.sfu.ca/students/residences/housing-options/mctaggart-cowan-hall.html
   - Four storeys; renovated 2025. Prefer contemporary facade references.
5. Courtyard Residence — https://www.sfu.ca/students/residences/housing-options/courtyard-residence.html
   - Official modern-building description and photos.
6. Townhouses — https://www.sfu.ca/students/residences/housing-options/townhouses.html
   - Official visual reference for townhouse form, not just names.
7. SFU Facilities building directory — https://www.sfu.ca/fs/campus-maps/directory-of-buildings.html
   - Actual official building names, building numbers and profile photos, including Shell House, Dining Commons and the two newer towers.
8. SFU tenant insurance building facts — https://www.sfu.ca/students/residences/moving-in/insurance.html
   - Verifiable number of floors for many named buildings; 9 three-storey townhouses; courtyard 11; McTaggart 4; Hamilton 4; 3 North Towers reported as 8.
9. Individual facilities pages: McTaggart https://www.sfu.ca/fs/campus-maps/directory-of-buildings/Mctaggart-cowan-hall.html ; Hamilton https://www.sfu.ca/fs/campus-maps/directory-of-buildings/Hamilton-hall.html ; Pauline Jewett https://www.sfu.ca/fs/campus-maps/directory-of-buildings/Pauline-Jewett-house.html .
10. Historical overview showing construction chronology — https://www.sfu.ca/~jnr2/SFU1/BNResidence.html (historic photos/chronology, not authoritative current facade data).

## OpenStreetMap / geo data
11. OSM copyright / license — https://www.openstreetmap.org/copyright
12. OSM Foundation attribution guidelines — https://osmfoundation.org/wiki/Attribution_Guidelines
13. OSM-based place anchor (not authoritative building dimensions): Pauline Jewett House approximately **49.28035, -122.92769**, listed as OSM way **102388632** — https://mapcarta.com/W102388632 . Approximate Cowichan Residence **49.28064, -122.92871** (OSM way **102388881**) — https://mapcarta.com/W102388881 . These are points/way IDs to help initial query verification, NOT proof of every facade/footprint.

## Google policy: hard restriction for this pack
14. Google Maps Platform ToS (no creation of new content based on Google map imagery, e.g. tracing footprints or constructing 3D models) — https://cloud.google.com/maps-platform/terms
15. Google geographic usage guidelines (do not use Google Earth imagery to reconstruct 3D models; prohibit Street View screenshots for repurposing) — https://about.google/brand-resource-center/products-and-services/geo-guidelines/
16. Google Earth additional terms — https://maps.google.com/intl/en_all/help/terms_maps-earth/

**Do not treat a public webpage as public domain.** If distribution is planned, contact rights-holders or use assets with explicit game-compatible licenses, track attribution. When OSM is used, respect ODbL/attribution and consider share-alike requirements for adapted geospatial databases; document all derived data and provide legally required data access when necessary.

## Best visual workflow
A. Use **licensed ground-level photos with explicit re-use rights** (self-shot/user-owned/CC-compliant assets) to examine facade detail and original hand-modeled geometry.
B. For official SFU photos not licensed for reuse, use the description/architectural information; seek permission for actual image inclusion.
C. Procedurally generate original facades from measured silhouette geometry, authored materials, and repeatable window modules. Avoid extraction of photogrammetry and unlicensed photo textures.
D. Use OSM for geographic geometry and SFU facts for labels/storeys; record conflicting dates and geometry in a log.

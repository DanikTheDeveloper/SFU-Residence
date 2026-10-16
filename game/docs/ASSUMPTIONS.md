# Accuracy boundaries

One unit is one metre. Origin: latitude 49.28035, longitude -122.92769.
Local equirectangular transform uses R=6,371,000 m:
X = radians(lon−lon0) × R × cos(lat0); Z = −radians(lat−lat0) × R.
Y is up; north is (0,0,−1). Rounded output coordinates are not survey precision.

| Item | Confidence and consequence | Evidence needed |
|---|---|---|
| All 19 plan footprints | VERIFIED OSM records, not independently surveyed; IDs and raw polygons retained | Current licensed survey / official open GIS |
| Heights | ESTIMATED: 3.1 m per storey; Dining 3.7 m. Flat bases below the lowest footprint terrain point | Elevations / measured sections |
| North Towers | Eight total floors used; seven-floor marketing text conflicts | Confirm facade/storey interpretation |
| Shell House | Four floors from OSM, not newly confirmed SFU floor count | Facilities section |
| Dining Commons | Three levels from architect; OSM says two. Current outer footprint retained, uniform extrusion approximates split levels | Current ground footprint and exterior elevations |
| Courtyard | OSM concave footprint and 11-floor maximum; uniform height over footprint | Stepped massing and roof survey |
| Terrain | ESTIMATED gentle plane Y=0.005X−0.025Z, not an actual DEM | Licensed terrain heights |
| Roads | OSM centre lines; estimated 6/9 m widths, 2.6 m footpaths. Stairs become continuous gentle routes | Width, curb, stairs and accessibility survey |
| Entrance direction | ESTIMATED short clear connection to an OSM path; 19 tested exterior anchors | Verified entry locations |
| Facades | Original modular approximations. Phase 1 brick/copper and Phase 2 precast/glazing follow architect text. Window counts, glass, bands, colors and doors unmeasured | Permissioned contemporary exterior photos and elevations |
| Roofs | Flat where tagged; neutral flat estimates elsewhere; detailed rooftop equipment omitted | Contemporary roof references, especially townhouses |
| Landscape | Trees, planters, benches, lights, cars and markings are original estimated dressing, not inventories | Licensed landscape plan / field observations |
| Boundary | Authored irregular study boundary with hedge collision and recovery; not SFU property boundary | Broader scope only if explicitly requested |
| Field edge | Original low-detail orientation patch; dimensions not a sports survey | Licensed field layout if needed |

No building interiors, NPCs, conversation code, credentials, HTTP clients, remote
runtime assets, AI API calls or local models are present. Stable building IDs,
metadata and outdoor anchors are the only future extension points. See the original
package docs 09 and 18 for future-only architectural considerations.

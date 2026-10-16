# Terrain evidence and reconstruction limits

Retrieved 2026-10-16 from the City of Burnaby's [Contours 2014 open-data layer](https://gis.burnaby.ca/arcgis/rest/services/OpenData/OpenData3/MapServer/6). Raw responses and metadata are in `data/terrain_sources/`. Native horizontal CRS EPSG:26910; the service reprojected query results to EPSG:4326. The existing spherical local projection is retained: origin 49.28035,-122.92769; X east, Z south; metres.

The [City licence](https://data.burnaby.ca/pages/open-government-licence) permits adaptation and redistribution with attribution. Its actual content is cached from the City's ArcGIS page item `5651cd6a185c42288dfc19d102f40bc5`. Contains information licensed under the Open Government Licence – British Columbia. Source: City of Burnaby. This prototype is not endorsed by the City or SFU.

The current BurnabyMap 1m endpoint returned HTTP/application query errors; the explicit OpenData3 2014 layer succeeded. All 2,412 intersecting IDs were fetched in batches of 400, with transfer-limit checks. Bounding query: longitude -122.934 to -122.921, latitude 49.2775 to 49.283. Full lines may extend beyond the query; the build filters locally.

Elevation is interpolated, NOT a survey. Source contour samples at approximately 3m intervals feed a 2m grid using 16-neighbour inverse-distance squared weights and three mild smoothing passes. Local zero is the interpolated Phase 1 spawn elevation. Vertical datum remains UNRESOLVED: do not copy the current service's ellipsoidal metadata onto this historical dataset or claim absolute surveyed heights.

2014 precedes modern tower construction. Flat pads and 8.8m transition shoulders are explicit **ESTIMATED_MODERN_GRADING**, each anchored to the interpolated original entrance position. They are editable assumptions, not surveyed foundations. Entrances remain geographically approximate until matched to photos. East/West roof alignment is tested as an observation, never imposed by changing floors or forcing Y.

Runtime terrain, collision, height queries and clipped pavement use the same grid and triangle diagonal. Source reconstruction scripts run offline after acquisition; the game requires neither Python nor network access.

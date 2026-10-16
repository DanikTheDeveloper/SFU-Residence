# Next session — refine this project, do not restart

1. Obtain permissioned contemporary exterior references for all building families;
   replace estimated facade palettes, bay counts and townhouse roof forms.
2. Resolve Courtyard's stepped volumes and Dining Commons' current expansion /
   three-level split form against licensed drawings; preserve OSM footprint provenance.
3. Replace the estimated terrain plane with licensed DEM/survey heights; reconcile
   stairs, retaining walls, ramps and actual entrances without breaking walkability.
4. Verify 2026 construction changes and pedestrian connections using current open
   GIS or a field survey. Keep the nine townhouse identities and newer residences.
5. Profile steady-state GPU cost at 1080p on this WSLg setup; optimize facade batches,
   shadows and distance detail before targeting 45–60 FPS. Current measurements are
   720p snapshots, not a guaranteed benchmark.
6. Refine original materials and vegetation with smaller spatial batches and smooth
   distance transitions; improve courtyard planting from a licensed landscape plan.
7. Replace estimated street furniture, parking stalls and crosswalks with observed
   locations. Add rooftop structures only where reference evidence supports them.
8. Perform a human keyboard/mouse walk around the three documented loops and tune
   sensitivity, camera distance and walking animation to preference.
9. Extend tests to any replacement polygons with inner rings/multipolygon buildings;
   current importer deliberately covers the closed ways in this cached extract.
10. Only after a separate explicit request, revisit future NPC/API architecture in
    package docs 09/18. This session contains no implementation of those systems.

Start in Debian from the package root:
```bash
bash scripts/verify_game.sh
python3 scripts/validate_world.py
bash scripts/run_game.sh --editor
```
Read STATUS, ASSUMPTIONS, BUILDING_CHECKLIST and README first. Preserve the installed
Godot 4.7.2 Linux Standard, GDScript and gl_compatibility stack. Do not install a
second engine or touch the user's other projects.

# Iteration 2 review — 2026-10-16

## Mouse and terrain
- Native captured mouse input with separate yaw/pitch replaced the rejected manual-warp approach. User confirms full turns with no blinking. Preserve current PlayerController. Earlier native-injection results belong to the rejected implementation and are not current evidence.
- Terrain artifacts traced to short-range contour interpolation, narrow pad shoulders and flat shading. Constrained diffusion smooths localized bumps without a vertical scale factor. All19 pad levels retained; entrance triangle corners pinned. Parameters in `data/terrain_smoothing.json`; original pre-filter grid preserved.
- Townhouse-region95th-percentile slope:46.1% to22.2%; local neighbor residual:.09675m to.020625m. Broad hillside remains. These algorithm diagnostics do not certify actual civil grades.

## Exterior improvements
- East/West approved model and shared kit protected by hashes; unchanged.
- Shared nine-block townhouse details verified: pitched roofs, blue-grey siding, white frames, projected bays and upper balconies. Exact block-specific details remain provisional.
- McTaggart-Cowan gets a distinct renewed-envelope master from confirmed contractor photography: charcoal brick, bronze-framed tall windows, grey roof fascia and glazed entrance connector. Original footprint/floors retained; repeated bay spacing and grade exposure estimated.
- Courtyard gets a distinct precast facade from DIALOG gallery: ribbed pale panels, dark recesses/bands, red reveals and broad base glazing. Uniform11-floor massing remains a known discrepancy with lower photographed wings. Resolve footprint-to-wing mapping before changing roof elevations.
- Online sources and rights recorded in `data/online_reference_index.json` and corresponding local photo folders. No third-party photographs downloaded or embedded as textures.

## Next priorities
1. Continue North Tower detailed architecture from PHASE2_NORTH_TOWER_REVIEW.md; camera is user-confirmed fixed.
2. Resolve Courtyard wing heights and facade orientations from current elevations/photos.
3. Hamilton identity is confirmed by readable sign in1638917139878.jpg; obtain current Dining expansion and Shell exterior references.
4. Model documented outdoor steps/retaining walls and improve surface/vegetation appearance. `game/data/stair_segments.json` is a source-derived15-segment candidate list, not implemented stairs.
5. Profile dense promenade views. Compatibility GTX1650 verified; view-dependent frame rates do not constitute a formal benchmark.

No interiors, NPCs or API code. Geographic source coordinates preserved.

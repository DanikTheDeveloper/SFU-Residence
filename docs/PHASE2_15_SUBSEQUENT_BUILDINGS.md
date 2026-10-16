# 15 — Building-by-building iterative refinement after this sprint

Follow a repeatable ONE-SHARED-FAMILY/session production cell (unique buildings get their own family):
1. Ingest fresh legal photos and provenance. Require front/entrance + angled reference; flag missing facades.
2. Correct name/current era/floor count/identity; read existing building registry and terrain foundation altitude.
3. Document per-facade color/material/photo references, roof, windows, door side and approach path.
4. Build verified silhouette and facade in reusable scene + material library, preserve stable ID/footprint.
5. Render at matching first-person viewpoints, compare to each photo; document mismatches.
6. Test collisions, slope connections, performance and scene reload.
7. Update `data/building_refinement_tracker.csv`, `docs/PHASE2_STATUS.md`, screenshot archive and handoff.

Suggested order AFTER current *East+West shared family* pilot: the three North Towers as one reusable family, the townhouses as one reusable family, then distinct Dining Commons, Courtyard Residence, Hamilton Hall, Shell House and McTaggart-Cowan Hall (or reorder according to photos/player sightlines). **Do not schedule an independent full modeling session for West after East, nor one per North Tower / townhouse building.** Validate per-instance entrances and grades separately even with shared facade masters.

Progressive fidelity gates:
- L0: topology correct + basic footprint (existing baseline).
- L1: grade and context + credible separate materials/parking/pedestrian surfaces.
- L2: correct building color blocks, shape and verified entrances.
- L3: photo-validated facade geometry and architectural modules.
- L4: high-quality legally sourced physical materials and site objects, proper light/camera QA.
- L5: advanced lighting/photogrammetry only if GPU, rights and time permit later (not required).

Do not advance to the next building while previously edited building has broken entrances/collisions. Prevent cross-building color/door transfer via evidence file IDs and explicit identity controls.

> CORRECTION 2026-10-16: User confirmed a continuous LONGITUDINAL gallery under the long courtyard-facing wing, linking PJH–BRH–SBH. Previous north–south two-lane passage interpretation is rejected. Ground-floor dimensions and inter-building connection details remain estimated. Implementation and tests are being corrected; previous passage passes do not validate the correct layout. Hamilton Hall follows this correction.

# North Tower refinement — current 2026-10-16 checkpoint

## User direction and reference review
User accepts townhouses; focus on Barbara Rae, Pauline Jewett and Shadbolt. E/W, camera, terrain and original geography remain protected. All nine local images reviewed individually; searchable observations, SHA256, identity confidence and rights in reference_photos/Barbara_Pauline_Shadbolt/PHOTO_REVIEW.json. No supplied photo pixels are shipped as textures.

PWL-SFU-Residences-Phase-1-1001.jpg has readable Jack Shadbolt House sign, confirming SBH. Other images confirm the family but not exact instance. SFU-Residence-Dining-Hall-6-scaled.jpg actually depicts the North courtyard facade despite its filename: central columned ground opening, projected lounge at one end, narrow room windows/white lower panels, broad concrete panels, glazed side-wing ground floor.1752684841514.jpg shows narrow side-wing glazing, deep concrete fins, broad end wall and roof overhang. Untitled.jpg and PWL1011 show screened stair cores and red service doors. Dates unconfirmed.

## Implemented shared model
- Corrected the earlier narrow side-wing tunnel: broad24m central courtyard undercroft with four solid support piers, ceiling, concrete paving and actual openings through visible/collision walls. This supersedes the42%-along-side-wing estimate in checkpoint2b4e178.
- Narrower room windows separated by broad concrete panels, white lower panels, projecting central lounge stack with glazed returns/deeper slabs.
- Separate dark screened stair-core end treatment with narrow white-framed glazing. Generic repeated room windows removed from those faces.
- North-only cached procedural concrete/formwork and screen materials, batched via existing geometry infrastructure. Shared FacadeKit and E/W hashes unchanged.
- Framed closed double entry doors, central mullion, transom and handles; solid concrete canopy. Geographic entrance thresholds retained. No interiors.

## Evidence versus estimates
Photos establish architectural features, not survey dimensions.24m undercroft width,2.9m clearance, column locations/size, rear exit configuration and screened end assignment remain estimated shared reconstruction. Stair-core handedness now follows the public level2 plan: projecting/screened end west for BRH/SBH and east for PJH. Screen placement remains a photo-plus-plan inference, not individually identified facade proof. Ground glazing/columns around lounges and side wings are incomplete. Entry placement still follows original registry; photo sign location has not been georeferenced to move it. Roof/foundation/floor counts unchanged. Red service doors, precise parapets/top-floor fins, stairs, curved courtyard paving and detailed landscaping remain pending.

## Validation
Full smoke/physics/routes after relocating opening:153 checks and333 walking checkpoints passed. Added column collision checks and door details: final smoke and156 physics checks passed, architectural-family/runtime validators passed. Canopy bounds retained; no route geometry changes after full route pass. Logs /tmp/north-courtyard-verification.log, /tmp/north-final-smoke.log, /tmp/north-final-physics.log. Native GPU visual captures completed for earlier courtyard refinement; latest plan revision capture completed and reviewed. View8 is courtyard undercroft; view9 is entry at the verified anchor.

## Next concrete steps
1. Inspect latest plan-revision captures; shared central lounge now has three-part glazing, with sealed base and two flanking circulation lanes.
2. Map photographed stair-core handedness and lounge/entrance locations per tower; avoid silently treating family identity as facade-orientation proof.
3. Improve top-floor fins/parapets and ground-level glazing. Add evidenced red service-door modules only after locating faces.
4. Resolve courtyard stair/paving placement without altering original path coordinates or terrain wholesale. Keep156 runtime checks and333 route checkpoints passing.

Townhouse common-annex/unit mapping and Hamilton detailed model remain deferred. Do not change approved townhouse appearance or East/West. Preserve user-confirmed native mouse capture.

## Plan revision validation
See PHASE2_NORTH_PLAN_AUDIT.md.165 physics checks pass, including both lanes in opposite directions for all3 towers and central-core closure;333 continuous checkpoints pass. Original source geometry and protected E/W pass. Public plans have no ground floor, and full Facilities key plans require CAS authentication; no bypass attempted.

## Ground frontage/detail follow-up
Inner side wings now use wider ground-level glazing above concrete bases. Courtyard apron is terrain-following and leaves original paths unchanged. North glass tone/blind pattern and concrete screen texture are original generated materials; per-room blind positions are aesthetic estimates, not occupancy claims. End screen narrowed to3.6m beside1.9m corner glazing; remaining end wall concrete. Dark name plaques are at retained registry entrances, not claimed survey locations. HUD footprint-distance fix tested at PJH.166 checks pass; final detail captures8-12 reviewed on GTX1650 Compatibility. Architect DYS gallery confirms8 storeys and close-up glass clamps; no image assets imported.

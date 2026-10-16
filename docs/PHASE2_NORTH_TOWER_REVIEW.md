# North Tower refinement — 2026-10-16

User accepts current townhouse appearance; switch current priority to Barbara Rae, Pauline Jewett and Shadbolt. Townhouse exact house numbering/common-annex mapping remains deferred, not finished. East/West and camera are frozen.

## Evidence reviewed
- `reference_photos/Barbara_Pauline_Shadbolt/1790722544125.jpg`: tall white-framed windows, broad concrete wall panels, horizontal slabs, projected glazed lounge stack, dark stair-core face. Individual tower identity unresolved.
- `Photo-03-1024x672.jpg`: multiple family buildings, open ground-level undercroft with concrete supports; historic landscaping, date unknown.
- `1636047123915.jpg`: small courtyard view showing ground opening beneath side wing, glazed lounge stack and pale concrete.
- `images.jpeg`: eye-level open undercroft, dark stairwell face, concrete columns and paving. Exact individual tower not identified.
User-selected images are visual references only, not redistributed textures.

## Current implementation
One NorthTowerExterior master for all three. Broader concrete panels, narrower room windows and projecting lounge bay. Exterior passage helper clips lower wall triangles/collision, removes facade modules from opening, adds solid side walls and soffit. No building interiors. Footprints, entrances, foundation and roof heights unchanged.

Passage width3.6m, clear height2.9m and location42% along east inner wing edge are ESTIMATES. Photos establish the feature, not surveyed dimensions or exact per-building location. Axis follows registered footprint and exits the opposite wall. Lounge stack location is an estimated common module. Do not call these survey-verified. Dark stair core and exact entrance compositions remain next detailed work.

Validation: smoke and153 physics checks passed, including clear eye-level rays, overhead collision and player capsule traversals in all three passages. All333 existing walking checkpoints passed. East/West protected hashes, foundation levels and original geography passed.8 architectural families validate. Logs: /tmp/north-verification.log and game/docs/phase2_tests/. Existing diagnostic script ran from retained nested scripts/; Godot4.7.2 and Debian13 verified, no installs; glxinfo absent in current PATH. GUI confirms D3D12 GTX1650 OpenGL Compatibility.

Eye-level view4 and passage view8 inspected: opening visibly runs through building. First capture exposed grass beneath passage; final cosmetic paving follows existing terrain triangles and leaves collision untouched. Concrete is still too uniform/clean compared with reference, and side-wall passage resembles a tunnel rather than the photographed wider columned undercroft. This is a functional first increment, NOT a completed photo match. Exact column/open-side configuration must be resolved next. Do not claim all visible undercroft geometry is reproduced.

## Next concrete step
Compare courtyard-side footprint edges with user photos and establish a per-instance passage/column override record. Refine enclosed side walls into the evidenced columned undercroft only where outside circulation is confirmed; keep closed residential space sealed. Retain passage traversal tests. Then reproduce dark stair-core face and white-framed glazed lounge returns, followed by mapped entrance framing. Do not change floors, geographic footprints or approved E/W assets. Townhouses remain visually accepted; common annexes deferred.

Final GUI capture includes terrain-following passage paving; completion recorded in STATUS/HANDOFF after inspection. Measured FPS is camera-dependent, not a formal benchmark or60FPS guarantee.


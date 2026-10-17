# Dining Commons exterior review — 2026-10-17

The two handpicked images were inspected individually. They show the original concrete/glass wing, not the entire 2022 expansion. DiningExterior.gd now distinguishes the original southern wing and northern extension inside the unchanged merged footprint.

Original wing: concrete fascia and piers, broad curtain glazing, external screening and opaque service/end panels. Northern extension: tall glazed ends, dark long wall with clerestory, cantilevered pale roof edge and warm soffit. Materials are original procedural textures, with batched opaque exterior glazing; no interiors.

The architect's official page identifies the 2022 project. July 2021 construction photographs corroborate the north extension and tall glazed front. The exterior rendering credited to DIALOG/SFU establishes design intent only: final dark cladding and soffit colours remain provisional. Source URLs, licensing and observations are indexed in reference_photos/Dining_Commons.

Uncertainties: exact old/new junction, final extension finish, roof steps, mezzanine configuration, service doors and detailed facade orientation. The original three-level registry and 11.1 m height are retained; this does not claim three equal visible storeys. Original coordinates, pads, entrance routing and solid wall collisions remain unchanged.

177 physics checks and all 333 continuous route checkpoints passed in /tmp/dining-verification.log, including protected geometry/terrain/East-West checks. GPU visual captures completed in /tmp/dining-capture.log and /tmp/dining-grade-capture.log; all four eye-level views inspected. Grade-following stems close the visible facade-to-terrain gap without moving the terrain. Final post-stem regression passed: 177 checks and all 333 route checkpoints, plus preservation validators.

Performance caveat: a separate interactive Godot game process was already running during automated captures (PID 344105, over six hours elapsed). It was left running. The measured roughly 17–32 FPS shares GPU resources with that instance and is not an isolated benchmark. Retest one instance before attributing the slowdown to this facade.

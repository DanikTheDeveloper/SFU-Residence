# 07 — First-person ONLY (not third-person, no toggle)

## Requirements
- `CharacterBody3D` walking (WASD), sprint Shift if present, jump Space only if already desirable, gravity and floor snap; mouse-look horizontally on player and vertical pitch on camera pivot with sensible clamp.
- `Camera3D` parented to eye/pivot, approximately 1.6–1.75 m standing view; document chosen gameplay eye height (not measured player height). Mouse captured during game, ESC release, click to recapture; no visible third-person character mesh as player camera target.
- Remove/disable third-person chase camera and orbit controls; avoid spring arm forced external view. **No toggle back to third-person.** Keep UI/debug named building/location list if existing.
- Body collider must stay aligned with terrain and stairs/ramps. Reasonable walkable slope maximum, step-up handling from authored collision design, floor snapping, no ground clipping or stair jump requirement if ramp exists.
- Optional simple crosshair and FOV slider; never force camera collision into wall. Light head bob only if user later asks (motion sickness sensitivity).

## Acceptance demonstrations
1. Launch with camera visibly at eye level (no character visible in front of camera).
2. WASD directional movement, mouse look, Shift if supported, ESC cursor release and click recapture.
3. Traverse the real hillside from townhouses toward dining/courtyard and across lot, without sinking or levitating.
4. Approach every important facade and main public entrance without entering interiors.
5. Run headless syntax/smoke, then manual GUI test; headless cannot verify mouse capture/FOV behavior.

## Implementation caution
Respect preexisting movement state or save settings; do not create two competing player controllers. Rename/reparent nodes minimally, update scene references and main entry accordingly. Record controls in game/docs/STATUS.md or outer PHASE2_STATUS.

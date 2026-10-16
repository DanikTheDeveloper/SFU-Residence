# 09 — Codex five-hour RESET window: adaptive work queue (NOT 300-minute execution deadline)

**Meaning of five hours:** Codex account usage allowance replenishes on a five-hour reset schedule. **Do not confuse this with five hours of guaranteed continuous inference, a five-hour coding deadline, or a context window.** The user wants each iteration to do as much good work as possible using that window's available allowance. One iteration can end well before five wall-clock hours if usage is exhausted. The agent generally cannot read a reliable real-time percent remaining; cannot ensure a stop shortly before the cap; cannot schedule itself to resume just after the reset. Do not fabricate consumption counters.

## Queue — continuous useful progress as allowance permits

Start from the last verified checkpoint and choose the next highest-value item; advance immediately upon completing one item. These are **priority gates, not mandatory one-iteration boundaries**:

1. **First iteration only:** read new outer instructions; audit nested Godot; dry-run safe promotion; copy `game/` to outer if absent; baseline smoke test; archive obsolete nested Markdown safely; keep backup original game. Verify outer root is authoritative. Do not remove user assets.
2. **First-person:** strictly first-person player, correct mouse handling, hill walking/collisions; validate game.
3. **Terrain:** measured/grounded contours where feasible; preserve XZ building topology; integrate foundations and grade, walking connections; validate game. If geodata acquisition stalls, use clearly labeled editable estimate and advance.
4. **Surfaces:** concrete internal paths and plazas, differentiated marked public vehicle roads, proper parking *area* with parking spaces, ramps/curbs; validate game.
5. **Architecture:** reference-photo matching of ONE high-coverage reusable family (prefer East/West), shared scenes and per-instance configs, confirm heights/roofline from valid evidence; validate game. Then continue to next architectural family or additional site details if allowance remains. Do not stop merely because one family is finished.
6. **Continuous QA:** screenshots, render comparison, evidence log, visual/collision/performance tests. Keep issues and project state written to disk.

If a higher-priority feature is blocked, record the exact blocker and an actionable next step; switch to an independent task instead of spending the whole allowance rereading/researching.

## Persistent checkpoint discipline
- At **start of each iteration**: inspect `docs/PHASE2_STATUS.md`, `docs/PHASE2_HANDOFF.md`, `git status`, current game, and fresh photos. If handoff missing, initialize from `.template.md`. First iteration also reads the outer Phase 2 instructions; later iterations need only changes/relevant documents.
- After **every meaningful completed change** (such as migrated playable baseline, first-person controls, terrain working, surfaces, each family): run feasible quick tests, save/commit where safe, update STATUS and HANDOFF on disk. Prefer several small verified edits over one massive rewrite.
- Never leave all documentation/test work to a final fixed-time block. Save handoff before risky operations and after each checkpoint; exact interruption point is unpredictable.
- If a **real host warning**, user-provided `/status` near the limit, or explicit user instruction suggests low remaining usage: finish current smallest safe operation; update handoff including precise next command, tests, blockers, file paths; stop without starting another high-cost task. Do not claim autonomous quota visibility. If no signal, continue work.
- No active waiting, five-hour sleeping, automated self-resumption, looping repeated status calls, or speculative capacity percentages.

## Acceptance and continuation
Maintain playable `game/project.godot`, Godot 4.7.2 Standard GDScript Compatibility, actual building XZ positions, first-person only, terrain grade/collision, correctly classified paths/parking, visually evidenced reusable facades. Never claim unverified visual details. `docs/PHASE2_22_USAGE_WINDOW_ITERATIONS.md` defines how to resume after a reset. The user can instruct Codex to stop at any time.

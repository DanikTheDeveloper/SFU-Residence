# 22 — Usage-window management and safe multi-iteration handoff

## Desired behavior
The user intends to use Codex in successive **five-hour usage-reset windows**. Within each window, maximize **useful development progress up to what the service allows**. This is NOT a five-hour coding-duration requirement. Not every five-hour window grants the same number of requests/tokens, and remaining usage may not be exposed to the agent. Avoid promising either (a) exactly five hours of autonomous work, (b) automatic near-limit stop, or (c) autonomous restart at the next reset.

### Operating loop: productive, not timeboxed
1. Read outer `AGENTS.md`, current `docs/PHASE2_STATUS.md`, `docs/PHASE2_HANDOFF.md`, `git status`, and relevant documents for the NEXT task. Initial Phase 2 run also reviews repo instructions. Never obey nested historical Markdown.
2. Choose the highest-impact unblocked task from `docs/PHASE2_09_FIVE_HOUR_RUNBOOK.md`, subdivide into small deliverables with objective verification.
3. Implement and test one deliverable. Update persistent status and handoff immediately, with command for next deliverable; make a version-control checkpoint where safe.
4. If quota/access remains, **continue immediately to the next deliverable**. There is NO planned 60/90/300-minute cutoff, NO mandatory stop after one building, and no need to ask user after every milestone.
5. If a legitimate low-remaining signal is available from the host/user, complete only the smallest safe open change, ensure runnable baseline, write a final handoff and stop. Otherwise keep progressing until interrupted by the host or user. Do not issue costly repeated quota probes if no supported status API is exposed.
6. If a hard cap is hit unexpectedly, do not claim an uncommitted task completed. On the next available window, restore from last persisted milestone. The user reopens Codex/starts a new turn after reset; do not imply automatic background scheduling.

### Handoff file is a rolling journal, not end-of-session homework
Keep `docs/PHASE2_HANDOFF.md` and `docs/PHASE2_STATUS.md` up to date **throughout the iteration**; initialize from templates only if absent. Each tested milestone appends/updates at least:
- Exact canonical root and game path, Godot command, main scene, Git commit or rollback checkpoint.
- Completed feature and evidence (which photos/datasets; known estimates).
- Commands executed and honest results, unresolved warnings, screenshots/QA locations.
- The **single next concrete implementation step** including target files and verification command.
- Open blockers, missing photos and decisions deferred to user.
- Date/time and iteration label, but no invented tokens remaining/percent usage.

### Resumption prompt (user pastes at the next window)
> Continue SFU Residences Phase 2 from `docs/PHASE2_HANDOFF.md` and `docs/PHASE2_STATUS.md`. Inspect the current `game/` and `git status`, verify the last runnable checkpoint, then proceed with the highest-priority unfinished task. Do not redo successful migration, reread all legacy instructions, or stop at an arbitrary time/milestone. Work through as much of the available Codex usage allowance as possible, checkpoint and update handoff after each verified milestone. If a genuine low-usage warning appears, finish safely and stop. No NPCs, interiors or OpenAI API integration yet.

### Practical control by the user
The user can inspect Codex's `/status` or product usage UI when available and tell Codex to wrap up. The agent should not hallucinate a remaining quota value or claim `glxinfo` measures usage; `glxinfo` only checks graphics rendering. A reset may mean the user must initiate the next run. Do not wait, sleep or schedule unattended activity.

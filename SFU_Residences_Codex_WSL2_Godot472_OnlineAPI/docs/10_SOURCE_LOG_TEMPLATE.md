# 10 — Source and assumption log templates

At project creation copy and fill in `game/docs/RESEARCH_LOG.md` and `game/docs/ASSUMPTIONS.md`.

## RESEARCH_LOG.md record template
| Date/time UTC | Item | Source URL / local file | Data actually used | Permission/license | Confidence | Current vs historical | Gap / next check |
|---|---|---|---|---|---|---|---|
| 2026-10-15 | Example: McTaggart storeys | https://www.sfu.ca/students/residences/moving-in/insurance.html | 4 floors only | factual site description; photo not reused | VERIFIED for source claim | current | actual facade to model |

Never mark external content VERIFIED if not successfully opened; record link unavailable. A source supporting a factual storey count doesn't automatically license texture downloads. Identify each third-party game asset with its license and attribution.

## ASSUMPTIONS.md record template
| ID | Assumption | Why unavoidable | Consequence | Needed evidence to upgrade |
|---|---|---|---|---|
| A001 | Footprint is roughly rectangle | OSM not accessed | weak real-world match | legal footprint polygon and georeferencing |

## Building checklist template
| ID | Footprint provenance | Height provenance | Silhouette | Facade | Collision | Walkway accessible | Confidence | Outstanding work |
|---|---|---|---|---|---|---|---|---|

## Confidence vocabulary
- **VERIFIED:** claim present in identified verified primary/independently licensed source.
- **OBSERVED:** human-authored visual note from a permitted source, not measured.
- **ESTIMATED:** plausible implementation fallback, with no authoritative evidence.
- **UNKNOWN:** not established, don't silently fill as true.

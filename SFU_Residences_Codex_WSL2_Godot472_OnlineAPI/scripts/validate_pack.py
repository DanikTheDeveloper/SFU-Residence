#!/usr/bin/env python3
"""Read-only validation of Codex handoff documentation and seed IDs."""
import json, sys
from pathlib import Path
R=Path(__file__).resolve().parent.parent
errors=[]
for key in ['AGENTS.md','CODEX_TASK_PROMPT.md','QUICK_START_RU.md','README.md']:
 if not (R/key).exists(): errors.append(f'Missing {key}')
for i in range(1,21):
 hits=list((R/'docs').glob(f'{i:02d}_*.md'))
 if len(hits)!=1: errors.append(f'Expected exactly one docs/{i:02d}_*.md, got {len(hits)}')
try:
 dat=json.loads((R/'data/buildings_seed.json').read_text(encoding='utf-8'))
 ids=[b['id'] for b in dat['buildings']]
 assert len(ids)==19,f'Expected 19 buildings, got {len(ids)}'
 assert len(set(ids))==len(ids),'Duplicate building IDs'
 assert sum(b['type']=='townhouse' for b in dat['buildings'])==9,'Expected nine townhouses'
 print(f'Seed dataset: {len(ids)} unique buildings; {sum(b["type"]=="townhouse" for b in dat["buildings"])} townhouses.')
except Exception as e: errors.append(f'Data validation failed: {e}')
for image in ['sfu_old_residence_virtual_tour_map.png','sfu_residences_modern_map_screenshot.png']:
 if not (R/'references'/image).exists(): errors.append(f'Missing reference {image}')
future=(R/'docs/09_FUTURE_NPCS_AND_ONLINE_API.md').read_text(encoding='utf-8')
if 'online-only' not in future.lower(): errors.append('Online future scope note not found')
if errors:
 for e in errors: print('ERROR:',e)
 sys.exit(1)
print('PASS: reference maps, docs 01-20, and source seed are present. This does NOT validate a future game.')

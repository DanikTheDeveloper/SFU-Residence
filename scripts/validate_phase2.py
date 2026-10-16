#!/usr/bin/env python3
"""Validate outer package structure; doesn't need a running Godot project."""
from pathlib import Path
import csv
import sys
ROOT=Path(__file__).resolve().parent.parent
required=[ROOT/'AGENTS.md',ROOT/'CODEX_TASK_PROMPT.md',ROOT/'README.md',ROOT/'scripts/promote_game.py',ROOT/'scripts/smoke_test.sh',ROOT/'reference_photos/README.md',ROOT/'data/photo_manifest.template.csv']
required+=list(ROOT.glob('docs/PHASE2_*.md'))
required += [ROOT/'data/architecture_families.json', ROOT/'scripts/validate_families.py', ROOT/'scripts/relocate_legacy_photos.py', ROOT/'docs/PHASE2_18_SHARED_ARCHETYPE_PIPELINE.md']
issues=[]
for p in required:
    if not p.is_file() or p.stat().st_size==0:issues.append('Missing/empty '+str(p))
if len(list(ROOT.glob('docs/PHASE2_*.md')))<15: issues.append('Missing phase2 plan docs')
with (ROOT/'data/photo_manifest.template.csv').open(newline='',encoding='utf-8') as f:
    cols=next(csv.reader(f))
    for needed in ('file_path','family_id','building_id','usage_rights','view_label','entrance_location'):
        if needed not in cols:issues.append('Missing photo field '+needed)
if (ROOT/'game/project.godot').exists():
    content=(ROOT/'game/project.godot').read_text(errors='replace')
    if 'gl_compatibility' not in content:issues.append('Game not configured for gl_compatibility')
print('Phase2 package:',ROOT,'docs',len(list(ROOT.glob('docs/PHASE2_*.md'))),'issues',len(issues))
for issue in issues:print('ERROR:',issue)
sys.exit(bool(issues))

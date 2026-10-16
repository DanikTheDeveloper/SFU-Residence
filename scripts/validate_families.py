#!/usr/bin/env python3
"""Validate architectural-family mapping, uniqueness, photo folders and important user invariants."""
from pathlib import Path
import json,sys,csv
ROOT=Path(__file__).resolve().parent.parent
issues=[]
p=ROOT/'data/architecture_families.json'
obj=json.loads(p.read_text())
families=obj['family_definitions']
by_id={f['family_id']:f for f in families}
if len(by_id)!=len(families):issues.append('duplicate family_id')
for f in families:
 path=ROOT/'reference_photos'/f['photo_folder']
 if not path.is_dir():issues.append('missing family photo directory: '+str(path))
 if isinstance(f['instances'],list):
  for inst in f['instances']:
   if 'photo_folder' in inst and not (ROOT/'reference_photos'/inst['photo_folder']).is_dir():issues.append('missing instance photo dir '+inst['photo_folder'])
all_ids=[i['id'] for f in families if isinstance(f['instances'],list) for i in f['instances']]
if len(all_ids)!=len(set(all_ids)):issues.append('one building assigned multiple families')
modern=by_id['modern_east_west']['instances']
if [(i['id'],i['floor_count']) for i in modern] != [('East_Tower',7),('West_Tower',8)]:issues.append('incorrect East/West identities or floor counts')
north=by_id['north_towers']['instances']
if set(i['id'] for i in north)!={'Barbara_Rae_House','Pauline_Jewett_House','Shadbolt_House'}:issues.append('incorrect north tower mapping')
if set(i['floor_count'] for i in north)!={8}:issues.append('North Tower floor counts should be 8 per SFU')
if by_id['north_towers']['photo_folder']!='Barbara_Pauline_Shadbolt':issues.append('North Towers must use one combined photo directory')
if any(i.get('photo_folder')!='Barbara_Pauline_Shadbolt' for i in north):issues.append('North Tower photos must share combined directory')
# Legacy photo folders may remain after overlay extraction; they are ignored, not errors.
if by_id['modern_east_west']['roof_alignment']['status']!='USER_REPORTED_NOT_SURVEYED':issues.append('roof alignment evidence status must remain unresolved pending survey')
if by_id['townhouses']['instances']!='ALL_EXISTING_TOWNHOUSE_BLOCKS_FROM_PHASE1':issues.append('townhouses must reuse preexisting blocks')
with (ROOT/'data/photo_manifest.template.csv').open(encoding='utf-8',newline='') as f:
 cols=next(csv.reader(f))
 for item in ('file_path','family_id','building_id','usage_rights','entrance_location'):
  if item not in cols:issues.append('photo manifest missing '+item)
with (ROOT/'data/architecture_instances.template.csv').open(encoding='utf-8',newline='') as f:
 cols=next(csv.reader(f))
 for item in ('building_id','family_id','entrance_face','foundation_y','floor_count','existing_scene_node_path'):
  if item not in cols:issues.append('instance template missing '+item)
for template in ('architecture_instances.template.csv','building_refinement_tracker.template.csv','architecture_family_tracker.template.csv'):
 with (ROOT/'data'/template).open(encoding='utf-8',newline='') as f:
  rows=list(csv.reader(f))
  for line,row in enumerate(rows[1:],2):
   if len(row)!=len(rows[0]):issues.append(f'{template} line {line}: {len(row)} != {len(rows[0])}')
print('Architectural-family validation:',len(families),'families,',len(all_ids),'named instances; errors:',len(issues))
for e in issues:print('ERROR:',e)
sys.exit(bool(issues))

#!/usr/bin/env python3
"""Count photos by current architecture family, reading building identity only from labels."""
from __future__ import annotations
import argparse,csv,json
from pathlib import Path
EXT={'.jpg','.jpeg','.png','.webp','.heic','.tif','.tiff'}
BUILDINGS={
 'east_tower__':'East_Tower','west_tower__':'West_Tower',
 'barbara_rae_house__':'Barbara_Rae_House',
 'pauline_jewett_house__':'Pauline_Jewett_House',
 'shadbolt_house__':'Shadbolt_House',
}
def main():
 p=argparse.ArgumentParser(description=__doc__)
 p.add_argument('--root',default='.')
 p.add_argument('--write',action='store_true',help='Write new data/photo_inventory.generated.csv, never overwrite')
 a=p.parse_args(); root=Path(a.root).resolve();base=root/'reference_photos'
 if not base.is_dir():print('Missing photo directory');return 2
 defs=json.loads((root/'data/architecture_families.json').read_text(encoding='utf-8'))['family_definitions']
 folder_family={f['photo_folder']:f['family_id'] for f in defs}
 context={'Parking_and_Paths','Terrain_and_Stairs'}
 rows=[]; counts={}
 for photo in sorted(p for p in base.rglob('*') if p.is_file() and p.suffix.lower() in EXT):
  rel=photo.relative_to(base); category=rel.parts[0]
  family=folder_family.get(category,'CONTEXT' if category in context else 'LEGACY_OR_UNRECOGNIZED')
  name=rel.name.lower();identity=next((v for k,v in BUILDINGS.items() if name.startswith(k)),'UNKNOWN')
  # Folder alone is not evidence of picture contents.
  rows.append({'file_path':str(photo.relative_to(root)),'family_id':family,'building_id_label_only':identity,'bytes':photo.stat().st_size,'usage_rights':'UNKNOWN'})
  counts[family]=counts.get(family,0)+1
 print('Photographs:',len(rows))
 for family,n in sorted(counts.items()):print(f'  {family}: {n}')
 if counts.get('LEGACY_OR_UNRECOGNIZED'):
  print('NOTE: legacy folders found: migrate with scripts/relocate_legacy_photos.py then use active shared folders.')
 if not rows:print('No photos supplied; do not invent facade proof.')
 if a.write:
  dest=root/'data/photo_inventory.generated.csv'
  if dest.exists():print('REFUSE overwrite',dest);return 2
  with dest.open('w',encoding='utf-8',newline='') as f:
   fields=['file_path','family_id','building_id_label_only','bytes','usage_rights'];w=csv.DictWriter(f,fields);w.writeheader();w.writerows(rows)
  print('Wrote:',dest)
 return 0
if __name__=='__main__':raise SystemExit(main())

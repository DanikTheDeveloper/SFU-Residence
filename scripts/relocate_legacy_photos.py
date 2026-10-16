#!/usr/bin/env python3
"""Non-destructive, dry-run-first migration of old photo directory layouts to shared family folders."""
from __future__ import annotations
import argparse, sys, shutil
from pathlib import Path
EXT={'.jpg','.jpeg','.png','.webp','.heic','.tiff','.tif'}
# source folder -> (new folder, explicit filename prefix). Longest nested patterns handled as separate sources.
SOURCES={
 'East_Tower': ('East_West_Towers','East_Tower__'),
 'West_Tower': ('East_West_Towers','West_Tower__'),
 'North_Towers/Barbara_Rae_House': ('Barbara_Pauline_Shadbolt','Barbara_Rae_House__'),
 'North_Towers/Pauline_Jewett_House': ('Barbara_Pauline_Shadbolt','Pauline_Jewett_House__'),
 'North_Towers/Shadbolt_House': ('Barbara_Pauline_Shadbolt','Shadbolt_House__'),
 'North_Towers_Barbara_Rae': ('Barbara_Pauline_Shadbolt','Barbara_Rae_House__'),
 'North_Towers_Pauline_Jewett': ('Barbara_Pauline_Shadbolt','Pauline_Jewett_House__'),
 'North_Towers_Shadbolt': ('Barbara_Pauline_Shadbolt','Shadbolt_House__'),
}
def main():
 p=argparse.ArgumentParser(description=__doc__)
 p.add_argument('--root',default='.')
 p.add_argument('--apply',action='store_true')
 a=p.parse_args(); root=Path(a.root).resolve(); base=root/'reference_photos'
 if not (root/'AGENTS.md').is_file() or not base.is_dir():
  print('ERROR: requires outer Phase2 root with AGENTS.md and reference_photos/',file=sys.stderr);return 2
 tasks=[];conflicts=[];seen=set()
 for source_name,(target_name,prefix) in SOURCES.items():
  old=base/source_name
  if not old.is_dir():continue
  for src in sorted(old.rglob('*')):
   if not src.is_file() or src.suffix.lower() not in EXT:continue
   rel=src.relative_to(old)
   # Do not infer identity from file content; prefix merely states which legacy directory it came from.
   name=rel.name if rel.name.lower().startswith(prefix.lower()) else prefix+rel.name
   dest=base/target_name/rel.parent/name
   if dest.exists() or dest in seen:conflicts.append((src,dest));continue
   seen.add(dest);tasks.append((src,dest))
 for src,dst in tasks:print('COPY' if a.apply else 'WOULD COPY',src.relative_to(root),'->',dst.relative_to(root))
 for src,dst in conflicts:print('CONFLICT (no overwrite)',src.relative_to(root),'->',dst.relative_to(root))
 if a.apply:
  for src,dst in tasks:
   dst.parent.mkdir(parents=True,exist_ok=True)
   try:
    with dst.open('xb') as target,src.open('rb') as original:shutil.copyfileobj(original,target)
    shutil.copystat(src,dst)
   except FileExistsError:
    print('ERROR target appeared; no overwrite',dst,file=sys.stderr);return 2
 print(f'files to copy: {len(tasks)}; conflicts: {len(conflicts)}; originals NEVER deleted')
 return 2 if conflicts else 0
if __name__=='__main__':raise SystemExit(main())

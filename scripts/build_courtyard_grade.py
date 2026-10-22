"""Estimated finish grade at DIALOG0058 eastern forecourt; never alter source grid/pads."""
import json, math
from pathlib import Path
from build_parking_grade import distance
r=Path(__file__).resolve().parents[1]
g=json.loads((r/'game/data/terrain_grid.json').read_text())
buildings=json.loads((r/'game/data/buildings.json').read_text())
cyr=next(b for b in buildings if b['id']=='CYR')
# Existing east-facing zigzag plus an estimated 7-8m paved forecourt width.
inner=[[342.884,10.63],[346.41,-5.671],[338.452,-7.628],[341.013,-18.948],[344.415,-18.136],[347.715,-34.393]]
outer=[[355.2,-32.6],[352.0,-17.0],[349.5,-6.0],[354.0,-4.0],[350.5,12.4]]
poly=inner+outer
# Photo0058: asphalt directly adjoins the curb, not an earthen bank.
# Photo-fit apron and service-lane transition are estimates, not mapped road edits.
apron=[[350.5,12.4],[354.0,-4.0],[349.5,-6.0],[352.0,-17.0],[355.2,-32.6],[361.2,-31.2],[358.0,-15.6],[355.5,-4.6],[360.0,-2.6],[356.5,13.8],[353.5,24.0],[346.5,22.4]]
base=g['pads']['CYR']['height']
changes=[]
for k,h in enumerate(g['heights']):
 x=g['origin_x']+k%g['width']*g['step']; z=g['origin_z']+k//g['width']*g['step']
 if not 310<x<382 or not -54<z<42: continue
 d=min(distance(x,z,poly),distance(x,z,apron))
 if d>=18: continue
 if any(distance(x,z,b['footprint'])<3 for b in buildings if b['id']!='CYR'): continue
 # Preserve original building footprint/pad; approach at its existing height.
 if distance(x,z,cyr['footprint'])==0: continue
 edge=distance(x,z,cyr['footprint'])
 target=base-min(edge,8)*0.015-min(distance(x,z,poly),8)*0.02
 weight=max(0,1-d/18);weight=weight*weight*(3-2*weight)
 changes.append([k,round(h+(target-h)*weight,4)])
(r/'game/data/courtyard_grade.json').write_text(json.dumps({'source':'DIALOG0058 eastern paved forecourt; grades and extent estimated from existing CYR foundation','polygon':poly,'outer_edge':outer,'asphalt_apron':apron,'blend_m':18,'crossfall':0.015,'changes':changes},separators=(',',':')))
print('Courtyard finish grade:',len(changes),'samples; source unchanged')

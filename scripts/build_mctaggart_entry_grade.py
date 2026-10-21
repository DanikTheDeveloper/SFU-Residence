"""Photo-supported descending approach at user-identified west McTaggart connector."""
import json,math
from pathlib import Path
from build_parking_grade import distance
r=Path(__file__).resolve().parents[1];g=json.loads((r/'game/data/terrain_grid.json').read_text());d=json.loads((r/'game/data/mctaggart_entry.json').read_text());bs=json.loads((r/'game/data/buildings.json').read_text())
o=d['entrance'];n=d['outward'];u=[-n[1],n[0]]
changes=[]
for k,h in enumerate(g['heights']):
 x=g['origin_x']+k%g['width']*g['step'];z=g['origin_z']+k//g['width']*g['step']
 t=(x-o[0])*n[0]+(z-o[1])*n[1];s=(x-o[0])*u[0]+(z-o[1])*u[1]
 if not -.5<t<20 or abs(s)>6:continue
 if any(distance(x,z,b['footprint'])<.2 for b in bs):continue
 target=d['landing_height'] if t<=3.0 else d['landing_height']+(d['top_height']-d['landing_height'])*min(1,(t-3.0)/2.8)
 if t>12:target=target+(h-target)*min(1,(t-12)/7)
 weight=max(0,min(1,(6-abs(s))/3.8));weight=weight*weight*(3-2*weight)
 changes.append([k,round(h+(target-.15-h)*weight,4)])
(r/'game/data/mctaggart_entry_grade.json').write_text(json.dumps({'source':d['confidence'],'changes':changes},separators=(',',':')))
print('McTaggart approach:',len(changes),'samples, source and pads preserved')

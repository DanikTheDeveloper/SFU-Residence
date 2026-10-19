"""Separate reversible finish grade for Field4 sideline shelters, dimensions estimated."""
import json,math
from pathlib import Path
from build_parking_grade import distance
r=Path(__file__).resolve().parents[1];g=json.loads((r/'game/data/terrain_grid.json').read_text());g['heights']+=json.loads((r/'game/data/field2_terrain_extension.json').read_text())['heights'];g['depth']=len(g['heights'])//g['width']
for name in ['parking_grade','beedie_grade','field4_grade','field2_grade']:
 for k,h in json.loads((r/'game/data'/f'{name}.json').read_text())['changes']:g['heights'][k]=h
field=json.loads((r/'game/data/field4.json').read_text());a=field['points'][3];b=field['points'][2];length=math.dist(a,b);u=[(b[i]-a[i])/length for i in range(2)];v=[-u[1],u[0]]
polys=[]
for along,size in [(46,5),(67,5),(108,17)]:
 polys.append([[a[i]+u[i]*(along+x)+v[i]*z for i in range(2)] for x,z in [(-size/2-0.3,-6.8),(size/2+0.3,-6.8),(size/2+0.3,-1.3),(-size/2-0.3,-1.3)]])
buildings=json.loads((r/'game/data/buildings.json').read_text());changes=[]
for k,h in enumerate(g['heights']):
 x=g['origin_x']+k%g['width']*g['step'];z=g['origin_z']+k//g['width']*g['step']
 if not -10<x<85 or not 62<z<100:continue
 d=min(distance(x,z,p) for p in polys)
 if d>=5:continue
 bd=min(distance(x,z,b['footprint']) for b in buildings)
 if bd<=4:continue
 t=max(0,min(1,1-d/5));t=t*t*(3-2*t);guard=max(0,min(1,(bd-4)/3));t*=guard*guard*(3-2*guard)
 changes.append([k,round(h+(field['height_estimate_m']-h)*t,4)])
(r/'game/data/field4_shelter_grade.json').write_text(json.dumps({'status':'estimated sideline grading, original grid/pads untouched','changes':changes},separators=(',',':')))
print('Shelter grading samples',len(changes))

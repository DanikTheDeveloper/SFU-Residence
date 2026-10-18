"""Local Field4 grading; source elevations and approved building pads are immutable."""
import json,statistics,hashlib
from pathlib import Path
from build_parking_grade import distance
ROOT=Path(__file__).resolve().parents[1]
def main():
 src=ROOT/'game/data/terrain_grid.json';g=json.loads(src.read_text())
 for filename in ['parking_grade.json','beedie_grade.json']:
  for k,v in json.loads((ROOT/'game/data'/filename).read_text())['changes']:g['heights'][k]=v
 features=json.loads((ROOT/'data/site_sources/residence_fields_projected.json').read_text())['features']
 f=next(x for x in features if x['name']=='Field 4' and x['kind']=='playing_surface')
 p=f['points'][:-1];buildings=json.loads((ROOT/'game/data/buildings.json').read_text());beedie=json.loads((ROOT/'game/data/beedie_field.json').read_text())['points']
 rows=[]
 for j in range(g['depth']):
  z=g['origin_z']+j*g['step']
  if not 45<z<178:continue
  for i in range(g['width']):
   x=g['origin_x']+i*g['step']
   if not -82<x<98:continue
   d=distance(x,z,p)
   if d<18:rows.append((j*g['width']+i,x,z,d))
 target=round(statistics.median(g['heights'][k] for k,x,z,d in rows if d==0),2)
 changes=[]
 for k,x,z,d in rows:
  bd=min(distance(x,z,b['footprint']) for b in buildings)
  if bd<=4 or distance(x,z,beedie)<3:continue
  t=max(0,min(1,(18-d)/15));guard=max(0,min(1,(bd-4)/4))
  t=t*t*(3-2*t)*guard*guard*(3-2*guard)
  changes.append([k,round(g['heights'][k]+(target-g['heights'][k])*t,4)])
 f.update({'points':p,'height_estimate_m':target,'runtime_status':'first pass','official_source':'https://www.sfu.ca/recreation/info/facilities.html','uncertainty':'Mapped pitch bounds; estimated median finished level, goal/line dimensions and fixture locations. User identifies the eastern Field2 as the second Beedie area; Field4 uses the soccer layout shown by SFU.'})
 (ROOT/'game/data/field4.json').write_text(json.dumps(f,indent=2))
 (ROOT/'game/data/field4_grade.json').write_text(json.dumps({'height_m':target,'base_sha256':hashlib.sha256(src.read_bytes()).hexdigest(),'changes':changes},separators=(',',':')))
 print('FIELD4_GRADE',target,'changed samples',len(changes))
if __name__=='__main__':main()

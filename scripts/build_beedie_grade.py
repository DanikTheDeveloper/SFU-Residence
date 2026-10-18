"""Reversible Beedie playing-surface grade; original contour grid stays untouched."""
import hashlib,json,statistics
from pathlib import Path
from build_parking_grade import distance
ROOT=Path(__file__).resolve().parents[1]
def main():
 source=ROOT/'game/data/terrain_grid.json'
 g=json.loads(source.read_text())
 field=json.loads((ROOT/'data/site_sources/beedie_field_projected.json').read_text())
 p=field['points'][:-1]
 buildings=json.loads((ROOT/'game/data/buildings.json').read_text())
 samples=[]
 for j in range(g['depth']):
  z=g['origin_z']+j*g['step']
  if not 115<z<216:continue
  for i in range(g['width']):
   x=g['origin_x']+i*g['step']
   if not 52<x<168:continue
   d=distance(x,z,p)
   if d<14:samples.append((j*g['width']+i,x,z,d))
 target=round(statistics.median(g['heights'][k] for k,x,z,d in samples if d==0),2)
 changes=[]
 for k,x,z,d in samples:
  bd=min(distance(x,z,b['footprint']) for b in buildings)
  if bd<4:continue
  t=max(0,min(1,(14-d)/11))
  protect=max(0,min(1,(bd-4)/4))
  weight=t*t*(3-2*t)*protect*protect*(3-2*protect)
  value=round(g['heights'][k]+(target-g['heights'][k])*weight,4)
  if abs(value-g['heights'][k])>.0001:changes.append([k,value])
 patch={'base_sha256':hashlib.sha256(source.read_bytes()).hexdigest(),'height_m':target,'description':'Estimated finished playing level from median contour terrain; flat core and3m collar,14m smooth blend; building4m exclusion. Not surveyed elevation.','changes':changes}
 (ROOT/'game/data/beedie_grade.json').write_text(json.dumps(patch,separators=(',',':')))
 field.update({'points':p,'implemented':True,'height_estimate_m':target,'reference':'SFU Athletics official facility description and Jasper Chan photographs uploaded2012; historic visual evidence, not a current survey','notes':'Mapped field retained in place. Runtime playable boundary expanded only around this footprint. Individual fixture positions and dimensions estimated.'})
 (ROOT/'game/data/beedie_field.json').write_text(json.dumps(field,indent=2))
 print('BEEDIE_GRADE',target,'samples',len(changes))
if __name__=='__main__':main()

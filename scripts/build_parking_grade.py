import json,math,statistics
from pathlib import Path
ROOT=Path(__file__).resolve().parents[1]

def distance(x,z,p):
 inside=False;d=1e9
 for a,b in zip(p,p[1:]+p[:1]):
  dx,dz=b[0]-a[0],b[1]-a[1];t=max(0,min(1,((x-a[0])*dx+(z-a[1])*dz)/(dx*dx+dz*dz))) if dx*dx+dz*dz else 0
  d=min(d,math.hypot(x-a[0]-t*dx,z-a[1]-t*dz))
  if (a[1]>z)!=(b[1]>z) and x<dx*(z-a[1])/dz+a[0]:inside=not inside
 return 0 if inside else d

def main():
 g=json.loads((ROOT/'game/data/terrain_grid.json').read_text());lot=json.loads((ROOT/'data/site_sources/main_lot_projected.json').read_text()); buildings=json.loads((ROOT/'game/data/buildings.json').read_text())
 p=lot['points'];rows=[];conflicts=[]
 for j in range(g['depth']):
  z=g['origin_z']+j*g['step']
  if z<min(v[1] for v in p)-26 or z>max(v[1] for v in p)+26:continue
  for i in range(g['width']):
   x=g['origin_x']+i*g['step']
   if x<min(v[0] for v in p)-26 or x>max(v[0] for v in p)+26:continue
   d=distance(x,z,p)
   if d>26:continue
   bd=min(distance(x,z,b['footprint']) for b in buildings)
   if d==0 and bd<1:conflicts.append((x,z,bd))
   rows.append((j*g['width']+i,x,z,d,bd))
 print('lot samples',sum(r[3]==0 for r in rows),'foundation conflicts',conflicts[:12],len(conflicts),'median',statistics.median(g['heights'][r[0]] for r in rows if r[3]==0))
 # Preserve every original data byte; write a separate reversible grading layer.
 protected=set()
 for b in buildings:
  ex,ez=b['entrance'];ei=int((ex-g['origin_x'])/g['step']);ej=int((ez-g['origin_z'])/g['step'])
  protected.update(jj*g['width']+ii for jj in (ej,ej+1) for ii in (ei,ei+1))
 target=round(statistics.median(g['heights'][r[0]] for r in rows if r[3]==0),2)
 changes=[]
 for k,x,z,d,bd in rows:
  if k in protected or bd<=0.35:continue
  # The south edge adjoins North Tower foundations. Do not diffuse a parking
  # grade through buildings into the verified courtyard/gallery system.
  if d>0 and z>0.2314*x-17.85+3.0:continue
  t=max(0,min(1,(26-d)/(26-3)))
  influence=t*t*(3-2*t)
  if d>0:
   protect=max(0,min(1,(bd-0.35)/2.65));influence*=protect*protect*(3-2*protect)
  value=round(g['heights'][k]+(target-g['heights'][k])*influence,4)
  if abs(value-g['heights'][k])>.0001:changes.append([k,value])
 lot.update({'tags':{'name':'Residence Main Lot (pre-construction reconstruction)','amenity':'parking','surface':'paved'},'reference':'OSM way 32528160 version 8 (2023-04-05); original node geometry; user-confirmed level lot','height_estimate_m':target,'level_source':'Median existing contour-derived grid under lot; NOT surveyed finished elevation','era':'pre-Phase3 construction; full parking lot explicitly confirmed by user'})
 (ROOT/'game/data/main_parking.json').write_text(json.dumps(lot,indent=2))
 import hashlib
 patch={'base_sha256':hashlib.sha256((ROOT/'game/data/terrain_grid.json').read_bytes()).hexdigest(),'description':'User-requested level Residence Main Lot; target estimated from existing median. 26m bounded blend; foundations/entrance samples fixed. No source elevation changes.','height_m':target,'changes':changes}
 (ROOT/'game/data/parking_grade.json').write_text(json.dumps(patch,separators=(',',':')))
 print('Wrote local grade layer',len(changes),'samples, estimated finished height',target)
if __name__=='__main__':main()

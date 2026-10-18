"""Extend only new terrain rows using licensed original contours; never rewrite source grid."""
import json, math, heapq, hashlib, statistics
from pathlib import Path
from collections import defaultdict
from build_parking_grade import distance
ROOT=Path(__file__).resolve().parents[1]
def main():
 src=ROOT/'game/data/terrain_grid.json';g=json.loads(src.read_text());w=g['width'];step=g['step'];old_depth=g['depth']
 raw=json.loads((ROOT/'data/terrain_sources/contours2014_wgs84.json').read_text());buckets=defaultdict(list);seen=set()
 R=6371000;lat=49.28035;lon=-122.92769
 for f in raw['features']:
  h=f['attributes']['ELEVATION']
  for path in f['geometry']['paths']:
   pts=[(R*math.radians(p[0]-lon)*math.cos(math.radians(lat)),-R*math.radians(p[1]-lat)) for p in path]
   for a,b in zip(pts,pts[1:]):
    n=max(1,math.ceil(math.dist(a,b)/3))
    for i in range(n):
     x=a[0]+(b[0]-a[0])*i/n;z=a[1]+(b[1]-a[1])*i/n
     if not -410<x<460 or not 160<z<360:continue
     key=(round(x),round(z),h)
     if key in seen:continue
     seen.add(key);buckets[math.floor(x/10),math.floor(z/10)].append((x,z,h))
 def sample(x,z):
  bx,bz=math.floor(x/10),math.floor(z/10);near=[]
  for radius in [2,4,8]:
   near=[((px-x)**2+(pz-z)**2,h) for ix in range(bx-radius,bx+radius+1) for iz in range(bz-radius,bz+radius+1) for px,pz,h in buckets[ix,iz]]
   if len(near)>=12:break
  c=heapq.nsmallest(16,near)
  if not c or c[0][0]>80**2:raise ValueError(('insufficient contour coverage',x,z))
  if c[0][0]<.01:return c[0][1]-g['local_datum_m']
  return sum(h/max(.3,d) for d,h in c)/sum(1/max(.3,d) for d,h in c)-g['local_datum_m']
 rows=[[sample(g['origin_x']+i*step,z) for i in range(w)] for z in range(240,282,2)]
 for repeat in range(6):
  rows=[[sum(rows[min(len(rows)-1,max(0,j+dz))][min(w-1,max(0,i+dx))]*weight for dx,dz,weight in [(0,0,4),(-1,0,1),(1,0,1),(0,-1,1),(0,1,1)])/8 for i in range(w)] for j in range(len(rows))]
 # Smoothly match the existing boundary. Row240 itself remains byte-for-byte unchanged.
 extra=[]
 for j in range(1,len(rows)):
  blend=max(0,1-j*step/20);blend=blend*blend*(3-2*blend)
  extra.extend(round(v+(g['heights'][(old_depth-1)*w+i]-rows[0][i])*blend,4) for i,v in enumerate(rows[j]))
 extension={'base_sha256':hashlib.sha256(src.read_bytes()).hexdigest(),'source':g['source'],'license':g['license'],'original_depth':old_depth,'depth':old_depth+len(rows)-1,'heights':extra,'method':'Original contour IDW, six local smoothing passes, 20m seam-offset blend; appended rows only. Heights estimated.'}
 (ROOT/'game/data/field2_terrain_extension.json').write_text(json.dumps(extension,separators=(',',':')))
 g['heights']+=extra;g['depth']=extension['depth']
 for name in ['parking_grade.json','beedie_grade.json','field4_grade.json']:
  for k,v in json.loads((ROOT/'game/data'/name).read_text())['changes']:g['heights'][k]=v
 features=json.loads((ROOT/'data/site_sources/residence_fields_projected.json').read_text())['features'];f=next(x for x in features if x['name']=='Field 2');p=f['points'][:-1]
 buildings=json.loads((ROOT/'game/data/buildings.json').read_text());beedie=json.loads((ROOT/'game/data/beedie_field.json').read_text())['points']
 cells=[]
 for j in range(g['depth']):
  z=g['origin_z']+j*step
  if not 140<z<280:continue
  for i in range(w):
   x=g['origin_x']+i*step
   if not 115<x<297:continue
   d=distance(x,z,p)
   if d<18:cells.append((j*w+i,x,z,d))
 level=round(statistics.median(g['heights'][k] for k,x,z,d in cells if d==0),2);changes=[]
 for k,x,z,d in cells:
  bd=min(distance(x,z,b['footprint']) for b in buildings)
  if bd<=4 or distance(x,z,beedie)<3:continue
  t=max(0,min(1,(18-d)/15));guard=max(0,min(1,(bd-4)/4));t=t*t*(3-2*t)*guard*guard*(3-2*guard)
  changes.append([k,round(g['heights'][k]+(level-g['heights'][k])*t,4)])
 f.update(points=p,height_estimate_m=level,runtime_status='first pass',uncertainty='User calls this eastern pitch second part of Beedie/football; official SFU lists Field2 rugby/soccer. Photo confirms H posts, not American football yard markings. Finished grade and goal positions estimated.')
 (ROOT/'game/data/field2.json').write_text(json.dumps(f,indent=2));(ROOT/'game/data/field2_grade.json').write_text(json.dumps({'height_m':level,'changes':changes},separators=(',',':')))
 print('FIELD2 extension',len(extra),'grade',len(changes),'level',level)
if __name__=='__main__':main()

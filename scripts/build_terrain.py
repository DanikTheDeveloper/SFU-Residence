import json,math,heapq
from pathlib import Path
from collections import defaultdict
R=6371000;LAT=49.28035;LON=-122.92769
raw=json.loads(Path('data/terrain_sources/contours2014_wgs84.json').read_text())
buckets=defaultdict(list); seen=set(); xmin,xmax,zmin,zmax=-350,400,-180,240;step=2
for f in raw['features']:
 h=f['attributes']['ELEVATION']
 for path in f['geometry']['paths']:
  pts=[(R*math.radians(p[0]-LON)*math.cos(math.radians(LAT)),-R*math.radians(p[1]-LAT)) for p in path]
  for a,b in zip(pts,pts[1:]):
   n=max(1,math.ceil(math.dist(a,b)/3))
   for i in range(n):
    x=a[0]+(b[0]-a[0])*i/n;z=a[1]+(b[1]-a[1])*i/n
    if not xmin-60<x<xmax+60 or not zmin-60<z<zmax+60:continue
    key=(round(x),round(z),h)
    if key in seen:continue
    seen.add(key);buckets[math.floor(x/10),math.floor(z/10)].append((x,z,h))
def raw_height(x,z):
 bx,bz=math.floor(x/10),math.floor(z/10);near=[]
 for radius in [2,4,8]:
  near=[]
  for ix in range(bx-radius,bx+radius+1):
   for iz in range(bz-radius,bz+radius+1):
    for px,pz,h in buckets[ix,iz]:near.append(((px-x)**2+(pz-z)**2,h))
  if len(near)>=12:break
 closest=heapq.nsmallest(16,near)
 if not closest:raise ValueError((x,z))
 if closest[0][0]<.01:return closest[0][1]
 weights=[(1/max(.3,d),h) for d,h in closest]
 return sum(w*h for w,h in weights)/sum(w for w,h in weights)
print('samples',len(seen),flush=True)
# Smooth interpolated terrain slightly; contours predate modern construction.
w=(xmax-xmin)//step+1;h=(zmax-zmin)//step+1
heights=[[raw_height(xmin+i*step,zmin+j*step) for i in range(w)] for j in range(h)]
for repeat in range(3):
 heights=[[sum(heights[min(h-1,max(0,j+dz))][min(w-1,max(0,i+dx))]*weight for dx,dz,weight in [(0,0,4),(-1,0,1),(1,0,1),(0,-1,1),(0,1,1)])/8 for i in range(w)] for j in range(h)]
datum=round(raw_height(35,80),2)
values=[round(v-datum,3) for row in heights for v in row]
# Local flat pads are explicit provisional grading, separate from contour source.
buildings=json.loads(Path('game/data/buildings.json').read_text())
pads={b['id']:{'height':round(raw_height(*b['entrance'])-datum,3),'confidence':'ESTIMATED_MODERN_GRADING','entrance_xz':b['entrance']} for b in buildings}
def distance_to_poly(x,z,poly):
 inside=False; nearest=1e9
 for a,b in zip(poly,poly[1:]+poly[:1]):
  dx=b[0]-a[0]; dz=b[1]-a[1]; den=dx*dx+dz*dz
  t=max(0,min(1,((x-a[0])*dx+(z-a[1])*dz)/den)) if den else 0
  nearest=min(nearest,math.hypot(x-a[0]-t*dx,z-a[1]-t*dz))
  if (a[1]>z)!=(b[1]>z) and x<(b[0]-a[0])*(z-a[1])/(b[1]-a[1])+a[0]:inside=not inside
 return 0 if inside else nearest
for b in buildings:
 poly=b['footprint']; px=[v[0] for v in poly];pz=[v[1] for v in poly]; pad=pads[b['id']]['height']
 for j in range(max(0,int((min(pz)-10-zmin)/step)),min(h,int((max(pz)+10-zmin)/step)+1)):
  for i in range(max(0,int((min(px)-10-xmin)/step)),min(w,int((max(px)+10-xmin)/step)+1)):
   distance=distance_to_poly(xmin+i*step,zmin+j*step,poly)
   if distance>=10:continue
   t=max(0,min(1,(distance-1.2)/8.8));t=t*t*(3-2*t)
   index=j*w+i;values[index]=round(pad*(1-t)+values[index]*t,3)
result={'source':'City of Burnaby OpenData3/MapServer/6 Contours 2014','license':'Open Government Licence - City of Burnaby','retrieved':'2026-10-16','source_crs':'EPSG:26910; server transformed to EPSG:4326','vertical_datum':'UNRESOLVED; elevations retained relatively, not claimed surveyed absolute heights','local_datum_m':datum,'origin_x':xmin,'origin_z':zmin,'step':step,'width':w,'depth':h,'heights':values,'pads':pads,'method':'16-nearest contour sample inverse-distance squared; three 2m smoothing passes. Interpolated, not surveyed. Modern construction grading requires separate provisional pads.'}
Path('game/data/terrain_grid.json').write_text(json.dumps(result,separators=(',',':')))
print('grid',w,h,'datum',datum,'range',min(values),max(values))
for b in json.loads(Path('game/data/buildings.json').read_text()):
 print(b['id'],round(raw_height(*b['entrance'])-datum,2))

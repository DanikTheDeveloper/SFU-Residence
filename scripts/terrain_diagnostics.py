import json,math
from pathlib import Path
p=Path('game/data/terrain_grid.json');g=json.loads(p.read_text());w=g['width'];h=g['depth'];s=g['step'];a=g['heights']
regions={'precinct':(-280,355,-110,185),'townhouse_walk':(-260,-70,0,125),'modern':(20,170,25,100)}
for name,(x0,x1,z0,z1) in regions.items():
 slopes=[];rough=[];ys=[]
 for j in range(1,h-1):
  z=g['origin_z']+j*s
  for i in range(1,w-1):
   x=g['origin_x']+i*s
   if not(x0<x<x1 and z0<z<z1):continue
   k=j*w+i;v=a[k];ys.append(v);slopes.append(math.hypot((a[k+1]-a[k-1])/(2*s),(a[k+w]-a[k-w])/(2*s)));rough.append(abs(v-(a[k+1]+a[k-1]+a[k+w]+a[k-w])/4))
 slopes.sort();rough.sort();print(name,'range',min(ys),max(ys),'slope p95/max',slopes[int(.95*len(slopes))],slopes[-1],'rough p95/max',rough[int(.95*len(rough))],rough[-1])
print('profile z60',[(x,a[round((60-g['origin_z'])/s)*w+round((x-g['origin_x'])/s)]) for x in range(-250,351,25)])

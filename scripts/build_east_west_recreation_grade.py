"""Local recreation terraces; estimated finished levels, source terrain/pads immutable."""
import json, math
from pathlib import Path
from build_parking_grade import distance
r=Path(__file__).resolve().parents[1]
g=json.loads((r/'game/data/terrain_grid.json').read_text())
d=json.loads((r/'game/data/east_west_recreation.json').read_text())
bs=json.loads((r/'game/data/buildings.json').read_text())
u=d['across']; v=[-u[1],u[0]]; o=d['center']
court=[[o[j]+u[j]*s+v[j]*t for j in range(2)] for s,t in [(-6.5,-5),(6.5,-5),(6.5,5),(-6.5,5)]]
ramp=d['ramp']; lengths=[math.dist(a,b) for a,b in zip(ramp,ramp[1:])];total=sum(lengths)
segments=[];run=0
for a,b,L in zip(ramp,ramp[1:],lengths):
 i=len(segments);segments.append((a,b,d['ramp_levels'][i],d['ramp_levels'][i+1],1.3));run+=L
for pts,ys,w in [(d['stairs_upper'],[5.3,4.55,3.8],.8),(d['stairs_lower'],[3.8,3.25,3.25,2.7],1.3)]:
 for i in range(len(pts)-1):segments.append((pts[i],pts[i+1],ys[i],ys[i+1],w))
# Lower walk reconnects to existing Residence Lane grade, upper path to court.
segments += [(d['west_access'][0],d['west_access'][1],2.72,5.3,1.3),(d['stairs_lower'][-1],[94.424,86.098],2.7,2.62,1.3),([104.703,57.377],[105,53],5.3,5.3,1.3),([94.729,53.474],[98,51],5.3,5.3,1.0),([94.794,62.792],[96.789,63.303],3.8,3.8,1.3)]
changes=[]
for k,h in enumerate(g['heights']):
 x=g['origin_x']+k%g['width']*g['step'];z=g['origin_z']+k//g['width']*g['step']
 if not 88<x<116 or not 37<z<89:continue
 if any(distance(x,z,b['footprint'])<.15 for b in bs):continue
 candidates=[(distance(x,z,court),5.3),(distance(x,z,d['middle_polygon']),3.8)]
 for a,b,ya,yb,w in segments:
  dx=b[0]-a[0];dz=b[1]-a[1];t=max(0,min(1,((x-a[0])*dx+(z-a[1])*dz)/(dx*dx+dz*dz)))
  gap=max(0,math.hypot(x-a[0]-t*dx,z-a[1]-t*dz)-w)
  candidates.append((gap,ya+(yb-ya)*t))
 gap,target=min(candidates,key=lambda c:c[0])
 if gap>2:continue
 blend=max(0,1-gap/2);blend=blend*blend*(3-2*blend)
 # Decks supply exact finished planes; substrate stays just below them.
 changes.append([k,round(h+(target-.35-h)*blend,4)])
(r/'game/data/east_west_recreation_grade.json').write_text(json.dumps({'source':d['source'],'confidence':d['confidence'],'changes':changes,'court':court},separators=(',',':')))
print('Recreation grade:',len(changes),'samples; source/pads unchanged')

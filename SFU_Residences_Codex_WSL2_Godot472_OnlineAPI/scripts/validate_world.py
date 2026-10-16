"""Offline geometry and precinct reachability tests; standard Python only."""
import json, math, sys
from collections import deque
from pathlib import Path
from import_site import project
ROOT=Path(__file__).resolve().parents[1]
data=ROOT/'game/data'
buildings=json.loads((data/'buildings.json').read_text())
site=json.loads((data/'site.json').read_text())
roads=json.loads((data/'roads.json').read_text())
seed=json.loads((ROOT/'data/buildings_seed.json').read_text())['buildings']
assert {b['id'] for b in buildings}=={b['id'] for b in seed}
assert len({b['osm_id'] for b in buildings})==19
assert project(49.28045,-122.92769)[1]<-11
assert 7<project(49.28035,-122.92759)[0]<8
polys=[]
def inside(p,poly):
    x,y=p; hit=False
    for a,b in zip(poly,poly[1:]+poly[:1]):
        if (a[1]>y)!=(b[1]>y) and x<(b[0]-a[0])*(y-a[1])/(b[1]-a[1])+a[0]: hit=not hit
    return hit
for b in buildings:
    p=b['footprint']
    area=abs(sum(a[0]*c[1]-c[0]*a[1] for a,c in zip(p,p[1:]+p[:1]))/2)
    assert 50<area<10000,(b['id'],area)
    assert 5<b['height_m']<45
    assert all(-310<v[0]<380 and -150<v[1]<210 for v in p)
    bounds=(min(v[0] for v in p)-.5,min(v[1] for v in p)-.5,max(v[0] for v in p)+.5,max(v[1] for v in p)+.5)
    polys.append((p,bounds))
def blocked(x,y):
    for p,(x0,y0,x1,y1) in polys:
        if not x0<=x<=x1 or not y0<=y<=y1: continue
        if any(inside((x+dx,y+dy),p) for dx,dy in [(0,0),(.45,0),(-.45,0),(0,.45),(0,-.45)]): return True
    return False
# 2m grid: conservative geometric connectivity, not a substitute for physics tests.
free={(x,y) for x in range(-290,361,2) for y in range(-126,191,2) if inside((x,y),site['boundary']) and not blocked(x,y)}
def nearest(p): return min(free,key=lambda q:math.dist(q,p))
anchors={b['id']:nearest(b['outdoor_anchor']) for b in buildings}
start=anchors['WET']; reached={start}; queue=deque([start]); parent={}
while queue:
    x,y=queue.popleft()
    for q in [(x+2,y),(x-2,y),(x,y+2),(x,y-2)]:
        if q in free and q not in reached:
            reached.add(q); queue.append(q); parent[q]=(x,y)
assert all(p in reached for p in anchors.values()),anchors
assert len(reached)/len(free)>.99
for road in roads:
    assert len(road['points'])==2 and 0<road['width']<=12
print(f'PASS 19 unique OSM footprints; nine townhouses; coordinate signs/scale; valid areas/heights; {len(roads)} segments.')
print(f'PASS all 19 anchors connected on a 2m clearance grid ({len(reached)}/{len(free)} cells).')
# Save three closed walking itineraries with A* clearance routes for physics QA.
import heapq
def route(a,b):
    queue=[(0,a)]; cost={a:0}; prev={}
    while queue:
        _,p=heapq.heappop(queue)
        if p==b: break
        for q in [(p[0]+2,p[1]),(p[0]-2,p[1]),(p[0],p[1]+2),(p[0],p[1]-2)]:
            n=cost[p]+1
            if q in free and n<cost.get(q,1e20):
                cost[q]=n;prev[q]=p;heapq.heappush(queue,(n+(abs(q[0]-b[0])+abs(q[1]-b[1]))/2,q))
    result=[b]
    while result[-1]!=a: result.append(prev[result[-1]])
    result.reverse()
    # Keep turning points, plus at most 10m between checkpoints.
    simplified=[result[0]]
    for i in range(1,len(result)-1):
        if (result[i][0]-result[i-1][0],result[i][1]-result[i-1][1]) != (result[i+1][0]-result[i][0],result[i+1][1]-result[i][1]) or math.dist(simplified[-1],result[i])>=10: simplified.append(result[i])
    return simplified+[b]
loops=[]
for names in [['WET','HAM','COW','CHI','KEL','KIM','KIT','PEN','QUA','QUE','SQU','WET'],['WET','PJH','BRH','SBH','DC','CYR','SHR','EAT','WET'],['WET','EAT','MCH','HAM','WET']]:
    points=[]
    for a,b in zip(names,names[1:]): points.extend(route(anchors[a],anchors[b])[:-1])
    points.append(anchors[names[-1]])
    loops.append({'buildings':names,'points':points,'source':'Generated QA clearance route; not surveyed footpath'})
(data/'test_routes.json').write_text(json.dumps(loops,indent=2))
print('PASS three closed precinct itineraries generated.')

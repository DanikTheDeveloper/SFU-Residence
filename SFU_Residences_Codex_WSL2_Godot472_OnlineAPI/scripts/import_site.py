"""Rebuild editable metre-space data from the cached OSM extract (offline)."""
import json, math, xml.etree.ElementTree as ET
from pathlib import Path
ROOT = Path(__file__).resolve().parents[1]
OUT = ROOT/'game/data'
LAT, LON, R = 49.28035, -122.92769, 6371000
def project(lat, lon):
    return [round(math.radians(lon-LON)*R*math.cos(math.radians(LAT)),3), round(-math.radians(lat-LAT)*R,3)]
tree = ET.parse(OUT/'osm_source.osm').getroot()
nodes = {n.attrib['id']: project(float(n.attrib['lat']), float(n.attrib['lon'])) for n in tree.findall('node')}
ways = []
for w in tree.findall('way'):
    tags = {t.attrib['k']:t.attrib['v'] for t in w.findall('tag')}
    points = [nodes[n.attrib['ref']] for n in w.findall('nd') if n.attrib['ref'] in nodes]
    ways.append({'osm_id':w.attrib['id'], 'tags':tags, 'points':points})
if __name__ == '__main__':
    for w in ways:
        if 'building' in w['tags']:
            p=w['points']; c=[round(sum(v[i] for v in p)/len(p),1) for i in (0,1)]
            print(w['osm_id'],c,w['tags'])
    for r in tree.findall('relation'):
        tags={t.attrib['k']:t.attrib['v'] for t in r.findall('tag')}
        if 'building' in tags: print('RELATION',r.attrib['id'],tags, [m.attrib for m in r.findall('member')])

    mapping = dict(zip(['PJH','BRH','SBH','EAT','WET','CYR','MCH','HAM','SHR','DC','COW','CHI','KEL','KIM','KIT','PEN','QUA','QUE','SQU'],
                       ['102388632','102388639','102388635','980707207','980707206','1035487348','102388641','102388631','102388883','102388637','102388881','102388885','32894614','102388878','102388877','102388884','102388880','102388879','102388882']))
    by_id = {w['osm_id']:w for w in ways}
    def in_poly(p, polygon):
        x,z=p; hit=False
        for a,b in zip(polygon,polygon[1:]+polygon[:1]):
            if (a[1]>z)!=(b[1]>z) and x<(b[0]-a[0])*(z-a[1])/(b[1]-a[1])+a[0]: hit=not hit
        return hit
    all_polys=[by_id[value]['points'][:-1] for value in mapping.values()]
    def clear(p):
        return not any(in_poly([p[0]+dx,p[1]+dz],poly) for poly in all_polys for dx,dz in [(0,0),(.7,0),(-.7,0),(0,.7),(0,-.7)])
    buildings = json.loads((ROOT/'data/buildings_seed.json').read_text())['buildings']
    palette = {'north_tower':['aaa99b','a77b3f'], 'modern_tower':['8e5741','b4754a'], 'modern_residence':['c4c4b9','926444'], 'lowrise_hall':['aaa391','625d50'], 'dining':['b7ae98','805938'], 'townhouse':['8b9a93','4d6559']}
    paths = []
    boundary = [[-284,20],[-155,-75],[0,-120],[220,-105],[358,-60],[355,25],[292,64],[290,175],[75,190],[-95,165],[-267,135]]
    def inside(p):
        x,z=p; hit=False
        for a,b in zip(boundary,boundary[1:]+boundary[:1]):
            if (a[1]>z)!=(b[1]>z) and x<(b[0]-a[0])*(z-a[1])/(b[1]-a[1])+a[0]: hit=not hit
        return hit
    for w in ways:
        t=w['tags']; kind=t.get('highway')
        if kind and kind not in ['construction','proposed']:
            foot=kind in ['footway','path','steps','pedestrian','cycleway']
            for a,b in zip(w['points'],w['points'][1:]):
                if inside(a) and inside(b):
                    paths.append({'osm_id':w['osm_id'],'name':t.get('name','Walkway' if foot else 'Service lane'), 'kind':'path' if foot else 'road','width':2.6 if foot else (9 if kind=='tertiary' else 6), 'points':[a,b], 'confidence':'OSM centerline; ESTIMATED width and elevation'})
    for b in buildings:
        w=by_id[mapping[b['id']]]; points=w['points'][:-1]
        b.update(footprint=points, osm_id=w['osm_id'], source_tags=w['tags'], geometry_confidence='VERIFIED_OSM_RECORD_NOT_SURVEY', geometry_source='https://www.openstreetmap.org/way/'+w['osm_id'], license='ODbL-1.0', npc_spawn_anchors=[])
        b['floors']=b['floors'] or int(w['tags'].get('building:levels',4))
        if b['id']=='DC':
            b['floors']=3
            b['floors_confidence']='VERIFIED DIALOG project text; OSM says 2, unresolved split-level form'
        b['height_m']=b['floors']*(3.7 if b['type']=='dining' else 3.1)
        b['height_provenance']='ESTIMATED floor-to-floor multiplied by SFU floors (Shell/Dining floors from OSM)'
        b['facade']={'palette':palette[b['type']], 'confidence':'ESTIMATED original modular interpretation', 'bay_m':3.1 if b['type']!='townhouse' else 3.7, 'roof':'flat OSM tag or neutral estimated flat roof'}
        if b['type']=='modern_tower': b['facade']['source']='https://dialogdesign.ca/projects/simon-fraser-university-phase-1-student-residence/ ; brick/copper from text, exact allocation ESTIMATED'
        if b['id']=='CYR': b['facade']['source']='https://dialogdesign.ca/projects/simon-fraser-university-phase-2-student-residence/ ; precast/vertical glazing from text, exact pattern ESTIMATED'
        b['centroid']=[sum(p[i] for p in points)/len(points) for i in (0,1)]
        # Choose a long exterior edge with shortest connection to an existing path.
        choices=[]
        for a,c in zip(points,points[1:]+points[:1]):
            if math.dist(a,c)<6: continue
            mid=[(a[i]+c[i])/2 for i in (0,1)]
            for path in paths:
                u,v=path['points']; d=[v[i]-u[i] for i in (0,1)]; den=sum(q*q for q in d)
                f=max(0,min(1,sum((mid[i]-u[i])*d[i] for i in (0,1))/max(den,.001)))
                near=[u[i]+f*d[i] for i in (0,1)]
                distance=math.dist(mid,near)
                if distance<2.5 or not clear(near): continue
                if any(in_poly([mid[i]+(near[i]-mid[i])*f for i in (0,1)],points) for f in [.1,.3,.6,.9]): continue
                choices.append((distance,mid,near))
        _,door,anchor=min(choices)
        b['entrance']=door; b['outdoor_anchor']=anchor
        paths.append({'osm_id':None,'name':b['name']+' access','kind':'path','width':3,'points':[door,anchor],'confidence':'ESTIMATED connector'})
    (OUT/'buildings.json').write_text(json.dumps(buildings,indent=2))
    (OUT/'roads.json').write_text(json.dumps(paths,indent=2))
    areas=[w for w in ways if w['tags'].get('amenity')=='parking' and 'building' not in w['tags'] and all(inside(p) for p in w['points'])]
    (OUT/'site.json').write_text(json.dumps({'origin_lat':LAT,'origin_lon':LON,'radius_m':R,'north':[0,0,-1],'boundary':boundary,'terrain':'ESTIMATED plane: y=0.005*x-0.025*z','parking':areas,'license':'OSM derived database: ODbL-1.0'},indent=2))
    print('IMPORTED',len(buildings),'buildings',len(paths),'path segments',len(areas),'parking polygons')

from pathlib import Path
import json,urllib.request,xml.etree.ElementTree as ET
roads=json.loads(Path('game/data/roads.json').read_text())
ids=sorted({r['osm_id'] for r in roads if r['osm_id']})
url='https://www.openstreetmap.org/api/0.6/ways?ways='+','.join(ids)
raw=urllib.request.urlopen(url,timeout=45).read();Path('data/site_sources/road_surface_tags.osm').write_bytes(raw)
ways={w.attrib['id']:{t.attrib['k']:t.attrib['v'] for t in w.findall('tag')} for w in ET.fromstring(raw).findall('way')}
print('Fetched',len(ways),'ways; surface tags:',{k:v.get('surface') for k,v in ways.items() if v.get('surface')})
index=[]
for i,r in enumerate(roads):
 tags=ways.get(r['osm_id'],{});material=tags.get('surface','UNKNOWN')
 index.append({'segment':i,'osm_id':r['osm_id'],'name':r['name'],'points':r['points'],'mapped_surface':material,'source_url':'https://www.openstreetmap.org/way/'+str(r['osm_id']) if r['osm_id'] else None,'confidence':'OSM mapped tag, not field verified' if material!='UNKNOWN' else 'UNKNOWN: retain existing photo-informed/default material','accessed':'2026-10-17'})
Path('data/surface_evidence_index.json').write_text(json.dumps(index,indent=2))
overrides={str(e['segment']):e['mapped_surface'] for e in index if e['mapped_surface']!='UNKNOWN'}
Path('game/data/surface_overrides.json').write_text(json.dumps(overrides,indent=2))

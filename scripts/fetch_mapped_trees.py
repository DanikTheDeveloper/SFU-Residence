from pathlib import Path
import urllib.request,xml.etree.ElementTree as ET,json,math
url='https://www.openstreetmap.org/api/0.6/map?bbox=-122.932,49.2784,-122.9225,49.2818'
raw=urllib.request.urlopen(url,timeout=45).read();Path('data/site_sources/precinct.osm').write_bytes(raw)
site=json.loads(Path('game/data/site.json').read_text());trees=[]
for n in ET.fromstring(raw).findall('node'):
 tags={t.attrib['k']:t.attrib['v'] for t in n.findall('tag')}
 if tags.get('natural')!='tree':continue
 lat,lon=float(n.attrib['lat']),float(n.attrib['lon'])
 x=math.radians(lon-site['origin_lon'])*site['radius_m']*math.cos(math.radians(site['origin_lat']));z=-math.radians(lat-site['origin_lat'])*site['radius_m']
 trees.append({'osm_id':n.attrib['id'],'point':[round(x,3),round(z,3)],'tags':tags,'confidence':'OSM mapped tree; species/height/current survival not field verified'})
Path('game/data/mapped_trees.json').write_text(json.dumps(trees,indent=2));print('Mapped trees:',len(trees),[t['tags'] for t in trees[:8]])

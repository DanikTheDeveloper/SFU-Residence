from pathlib import Path
import xml.etree.ElementTree as ET,json,math
root=ET.parse('data/site_sources/precinct.osm').getroot();site=json.loads(Path('game/data/site.json').read_text())
nodes={n.attrib['id']:n.attrib for n in root.findall('node')};zones=[]
for w in root.findall('way'):
 t={a.attrib['k']:a.attrib['v'] for a in w.findall('tag')}
 kind='wood' if t.get('natural')=='wood' else ('grass' if t.get('landuse')=='grass' else None)
 if not kind:continue
 points=[]
 for nd in w.findall('nd'):
  n=nodes.get(nd.attrib['ref'])
  if n is None:break
  lat,lon=float(n['lat']),float(n['lon']);points.append([round(math.radians(lon-site['origin_lon'])*site['radius_m']*math.cos(math.radians(site['origin_lat'])),3),round(-math.radians(lat-site['origin_lat'])*site['radius_m'],3)])
 else:
  if len(points)>2:zones.append({'osm_id':w.attrib['id'],'kind':kind,'points':points,'confidence':'Mapped landcover polygon; individual planting positions and species estimated'})
Path('game/data/planting_regions.json').write_text(json.dumps(zones,separators=(',',':')));print('Saved',len(zones),'mapped planting regions')

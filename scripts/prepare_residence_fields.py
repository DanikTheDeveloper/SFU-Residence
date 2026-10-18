import json,math,xml.etree.ElementTree as E
from pathlib import Path
root=Path(__file__).resolve().parents[1]
r=E.parse(root/'data/site_sources/precinct.osm').getroot()
nodes={n.attrib['id']:(float(n.attrib['lat']),float(n.attrib['lon'])) for n in r.findall('node')}
site=json.loads((root/'game/data/site.json').read_text())
ids={'32528090':('Field 4','playing_surface'),'1091325198':('Field 4','facility_outline'),'32528091':('Field 2','playing_surface'),'32528092':('Beedie Field','playing_surface')}
rows=[]
for w in r.findall('way'):
 if w.attrib['id'] not in ids:continue
 name,kind=ids[w.attrib['id']]
 points=[]
 for nd in w.findall('nd'):
  lat,lon=nodes[nd.attrib['ref']]
  points.append([round(math.radians(lon-site['origin_lon'])*site['radius_m']*math.cos(math.radians(site['origin_lat'])),3),round(-math.radians(lat-site['origin_lat'])*site['radius_m'],3)])
 tags={t.attrib['k']:t.attrib['v'] for t in w.findall('tag')}
 bounds=[min(p[0] for p in points),min(p[1] for p in points),max(p[0] for p in points),max(p[1] for p in points)]
 rows.append({'name':name,'kind':kind,'osm_id':w.attrib['id'],'osm_tags':tags,'source_url':'https://www.openstreetmap.org/way/'+w.attrib['id'],'license':'ODbL-1.0; OpenStreetMap contributors','points':points,'bounds_xz':bounds,'runtime_status':'first pass implemented' if name=='Beedie Field' else 'not implemented; source preparation only'})
 print(name,kind,bounds)
assert len(rows)==4
beedie=next(x for x in rows if x['name']=='Beedie Field')
assert beedie['points']==json.loads((root/'data/site_sources/beedie_field_projected.json').read_text())['points']
out={'reviewed':'2026-10-18','official_source':'https://www.sfu.ca/recreation/info/facilities.html','official_surface_uses':{'Field 4':'Artificial turf; soccer/lacrosse; two coaches booths; lighting; seating360','Field 2':'Grass; rugby/soccer','Beedie Field':'Softball; grass outfield, sand infield, synthetic warning track'},'notes':'Three distinct residence-adjacent fields. Field4 pitch and facility polygons overlap: never instantiate as two fields. Terry Fox Field farther east is a separate fourth venue, not a replacement for Field2. Original source records retained; geometry not a survey.','features':rows}
(root/'data/site_sources/residence_fields_projected.json').write_text(json.dumps(out,indent=2))
print('PASS four records, three venues; projection matches existing Beedie byte-for-value coordinates')

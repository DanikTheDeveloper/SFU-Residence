import urllib.request,json
from urllib.parse import urlencode
from pathlib import Path
from terrain_projection import utm
base='https://gis.burnaby.ca/arcgis/rest/services/OpenData/OpenData3/MapServer/6/query?'
lo=utm(-122.934,49.2775);hi=utm(-122.921,49.283)
p={'f':'json','where':'1=1','geometry':','.join(map(str,lo+hi)),'geometryType':'esriGeometryEnvelope','inSR':26910,'returnIdsOnly':'true'}
d=json.load(urllib.request.urlopen(base+urlencode(p),timeout=30));print('count',len(d.get('objectIds',[])),d.get('error'),flush=True)
ids=d['objectIds'];allfeatures=[]
for i in range(0,len(ids),400):
 dest=Path(f'data/terrain_sources/part_{i//400}.json')
 if not dest.exists():
  p={'f':'json','objectIds':','.join(map(str,ids[i:i+400])),'outFields':'OBJECTID,ELEVATION','returnGeometry':'true','outSR':4326,'maxAllowableOffset':0.00001}
  dest.write_bytes(urllib.request.urlopen(base+urlencode(p),timeout=45).read())
 d=json.loads(dest.read_text());assert 'error' not in d and not d.get('exceededTransferLimit');allfeatures+=d['features'];print(i,len(allfeatures),flush=True)
Path('data/terrain_sources/contours2014_wgs84.json').write_text(json.dumps({'features':allfeatures,'source':base,'count':len(ids)}))

"""Build-time only. One cached OSM request, no runtime networking."""
import json, urllib.request, urllib.parse
from pathlib import Path
root = Path(__file__).resolve().parents[1]
query = '''[out:json][timeout:45];(way["building"](49.2785,-122.9315,49.2818,-122.9234);relation["building"](49.2785,-122.9315,49.2818,-122.9234);way["highway"](49.2785,-122.9315,49.2818,-122.9234);way["landuse"](49.2785,-122.9315,49.2818,-122.9234);way["leisure"](49.2785,-122.9315,49.2818,-122.9234);way["amenity"="parking"](49.2785,-122.9315,49.2818,-122.9234););out meta geom;'''
target = root / 'game/data/osm_source.json'
if not target.exists():
    req = urllib.request.Request('https://overpass-api.de/api/interpreter', data=urllib.parse.urlencode({'data': query}).encode(), headers={'User-Agent':'SFUExteriorPrototype/1.0 (one-off research)'})
    with urllib.request.urlopen(req, timeout=60) as response:
        data = json.load(response)
    target.write_text(json.dumps(data, indent=2))
data = json.loads(target.read_text())
for e in data['elements']:
    if 'building' in e.get('tags', {}):
        print(e['type'], e['id'], e['tags'])

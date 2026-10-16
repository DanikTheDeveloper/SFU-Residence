"""Fetch a small licensed OSM extract at build time; runtime remains offline."""
import argparse
import urllib.request
import xml.etree.ElementTree as ET
from pathlib import Path
ROOT=Path(__file__).resolve().parents[1]
URL='https://api.openstreetmap.org/api/0.6/map?bbox=-122.9315,49.2785,-122.9234,49.2818'
parser=argparse.ArgumentParser()
parser.add_argument('--refresh',action='store_true',help='Replace the cached source only after a successful fetch and XML validation')
args=parser.parse_args()
target=ROOT/'game/data/osm_source.osm'
if args.refresh or not target.exists():
    request=urllib.request.Request(URL,headers={'User-Agent':'SFUExteriorPrototype/1.0 (bounded one-off research)'})
    with urllib.request.urlopen(request,timeout=60) as response:
        content=response.read()
    tree=ET.fromstring(content)
    assert tree.tag=='osm' and tree.findall('way'), 'Invalid/empty OSM response'
    temporary=target.with_suffix('.tmp')
    temporary.write_bytes(content)
    temporary.replace(target)
    print('Fetched',URL)
else:
    tree=ET.parse(target).getroot()
    print('Using cached OSM; no network request. Use --refresh explicitly to update.')
print(len(tree.findall('way')),'ways;',len(tree.findall('node')),'nodes')

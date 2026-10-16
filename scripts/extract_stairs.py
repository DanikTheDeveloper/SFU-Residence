import xml.etree.ElementTree as ET,collections,json
from pathlib import Path
root=ET.parse('game/data/osm_source.osm').getroot();ways={w.attrib['id']:{t.attrib['k']:t.attrib['v'] for t in w.findall('tag')} for w in root.findall('way')}
roads=json.loads(Path('game/data/roads.json').read_text())
steps=[r for r in roads if ways.get(r['osm_id'],{}).get('highway')=='steps']
print(len(steps),[(r['osm_id'],r['points']) for r in steps][:12]);Path('game/data/stair_segments.json').write_text(json.dumps(steps,indent=2))

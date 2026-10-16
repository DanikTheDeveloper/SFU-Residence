"""Check preserved geography, external document backup, and source completeness."""
import hashlib
import json
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
OLD = ROOT / 'SFU_Residences_Codex_WSL2_Godot472_OnlineAPI/game'
for name in ('buildings.json', 'roads.json', 'site.json'):
    assert json.loads((OLD / 'data' / name).read_text()) == json.loads((ROOT / 'game/data' / name).read_text()), name
manifest = json.loads((ROOT / 'docs/PHASE1_ARCHIVE.json').read_text())
for entry in manifest:
    assert not (ROOT / entry['source']).exists(), entry['source']
    backup = Path(entry['backup'])
    assert not backup.resolve().is_relative_to(ROOT.resolve())
    assert hashlib.sha256(backup.read_bytes()).hexdigest() == entry['sha256']
source = json.loads((ROOT / 'data/terrain_sources/contours2014_wgs84.json').read_text())
assert len(source['features']) == source['count'] == len({f['attributes']['OBJECTID'] for f in source['features']})
grid = json.loads((ROOT / 'game/data/terrain_grid.json').read_text())
assert len(grid['heights']) == grid['width'] * grid['depth']
assert len(grid['pads']) == 19
for building in json.loads((ROOT / 'game/data/buildings.json').read_text()):
    ex, ez = building['entrance']
    i = int((ex-grid['origin_x'])/grid['step'])
    j = int((ez-grid['origin_z'])/grid['step'])
    for row in (j, j+1):
        for col in (i, i+1):
            assert abs(grid['heights'][row*grid['width']+col]-grid['pads'][building['id']]['height']) < .001, building['id']+' entrance contact'
player = (ROOT / 'game/scripts/PlayerController.gd').read_text()
assert 'SpringArm3D' not in player and 'EYE_HEIGHT := 1.68' in player
assert 'gl_compatibility' in (ROOT / 'game/project.godot').read_text()
assert not list((ROOT / 'game').rglob('*.cs'))
preserve = ROOT / 'data/east_west_preservation.json'
if preserve.exists():
    protected = json.loads(preserve.read_text())
    for name, digest in protected['files'].items():
        assert hashlib.sha256((ROOT / name).read_bytes()).hexdigest() == digest, name
    for id, pad in protected['pads'].items():
        assert grid['pads'][id] == pad, id
    print('PASS: user-approved East/West master, facade kit and pad elevations unchanged.')
print(f'PASS: unchanged 19-building XZ registry/routes/site; {len(manifest)} external backups verified; {source["count"]} unique contour records; terrain shape; first-person stack.')

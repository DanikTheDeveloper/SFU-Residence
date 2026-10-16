"""Repeatable constrained terrain smoothing, without changing source or vertical scale."""
import json
import math
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
config = json.loads((ROOT / 'data/terrain_smoothing.json').read_text())
grid = json.loads((ROOT / 'data/terrain_sources/iteration1_grid.json').read_text())
buildings = json.loads((ROOT / 'game/data/buildings.json').read_text())
w, h, step = grid['width'], grid['depth'], grid['step']
values = grid['heights'][:]
fixed = {}

def distance_to_polygon(x, z, poly):
    inside = False
    distance = math.inf
    for a, b in zip(poly, poly[1:] + poly[:1]):
        dx, dz = b[0] - a[0], b[1] - a[1]
        den = dx*dx + dz*dz
        t = max(0, min(1, ((x-a[0])*dx+(z-a[1])*dz)/den)) if den else 0
        distance = min(distance, math.hypot(x-a[0]-t*dx, z-a[1]-t*dz))
        if (a[1] > z) != (b[1] > z) and x < dx*(z-a[1])/dz+a[0]:
            inside = not inside
    return 0 if inside else distance

for b in buildings:
    poly = b['footprint']
    xs, zs = [p[0] for p in poly], [p[1] for p in poly]
    for j in range(max(0, int((min(zs)-3-grid['origin_z'])/step)), min(h, int((max(zs)+3-grid['origin_z'])/step)+1)):
        for i in range(max(0, int((min(xs)-3-grid['origin_x'])/step)), min(w, int((max(xs)+3-grid['origin_x'])/step)+1)):
            x, z = grid['origin_x']+i*step, grid['origin_z']+j*step
            if distance_to_polygon(x, z, poly) <= config['fixed_pad_margin_m']:
                fixed[j*w+i] = grid['pads'][b['id']]['height']
    # Pin the four triangle-grid corners at the existing entrance, rather than
    # widening every pad into neighboring buildings at a different level.
    ex, ez = b['entrance']
    ei = math.floor((ex-grid['origin_x'])/step)
    ej = math.floor((ez-grid['origin_z'])/step)
    for j in (ej, ej+1):
        for i in (ei, ei+1):
            fixed[j*w+i] = grid['pads'][b['id']]['height']

# Pinned footprint samples retain existing flat foundations; remaining samples
# diffuse toward a smoother surface. A planar hillside is invariant to this filter.
relax = config['relaxation']
for iteration in range(config['iterations']):
    updated = values[:]
    for j in range(1, h-1):
        for i in range(1, w-1):
            k = j*w+i
            updated[k] = fixed[k] if k in fixed else values[k] + relax*((values[k-1]+values[k+1]+values[k-w]+values[k+w])*0.25-values[k])
    values = updated
grid['heights'] = [round(v, 4) for v in values]
grid['smoothing'] = config
grid['method'] += ' Followed by constrained diffusion; original pad heights unchanged; source and iteration1 grid preserved.'
assert grid['pads'] == json.loads((ROOT / 'game/data/terrain_grid.json').read_text())['pads']
(ROOT / 'game/data/terrain_grid.json').write_text(json.dumps(grid, separators=(',', ':')))
print(f'Smoothed {w}x{h} grid, {len(fixed)} fixed pad samples, {config["iterations"]} passes; no vertical scaling.')

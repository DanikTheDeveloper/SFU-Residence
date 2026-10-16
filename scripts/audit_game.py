#!/usr/bin/env python3
"""Non-invasive text inventory of OUTER game; not a GUI realism assessment."""
from __future__ import annotations
import argparse
from collections import Counter
from pathlib import Path
import re

def main():
    p=argparse.ArgumentParser(description=__doc__)
    p.add_argument('--root', default='.')
    args=p.parse_args()
    game=Path(args.root).resolve()/'game'
    if not (game/'project.godot').exists():
        print('OUTER game/project.godot absent. Run promotion first.');return 1
    files=[f for f in game.rglob('*') if f.suffix.lower() in ('.gd','.tscn','.tres','.godot','.json') and '.godot' not in f.parts and f.stat().st_size<2_000_000]
    counts=Counter()
    examples={}
    pats={
        'cameras':r'Camera3D', 'third_person_candidates':r'SpringArm3D|orbit|third.person|chase.camera',
        'first_person_candidates':r'first.person|MOUSE_MODE_CAPTURED|InputEventMouseMotion',
        'roads':r'road|Road|lane|Lane', 'parking':r'parking|Parking',
        'terrain':r'terrain|Terrain|heightmap|HeightMapShape3D',
        'material_color':r'Color\(|albedo_color', 'renderer_compat':r'gl_compatibility',
    }
    for f in files:
        s=f.read_text(encoding='utf-8',errors='replace')
        for k,rx in pats.items():
            hits=len(re.findall(rx,s,re.I))
            if hits:
                counts[k]+=hits
                if len(examples.get(k,[]))<6:
                    examples.setdefault(k,[]).append(str(f.relative_to(game)))
    print('Godot project:',game)
    print('Files scanned:',len(files))
    for k in pats:
        print(f'{k}: {counts[k]} text hits; examples: {", ".join(examples.get(k,[]))}')
    print('NOTE: Text hits do NOT prove running camera type, slope, material, doors, or good visuals. Visually inspect WSLg game.')
    return 0
if __name__=='__main__': raise SystemExit(main())

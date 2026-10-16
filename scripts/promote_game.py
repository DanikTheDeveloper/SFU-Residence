#!/usr/bin/env python3
"""Safe copy-only nested Godot project -> outer ./game; dry-run by default."""
from __future__ import annotations
import argparse
import os
from pathlib import Path
import shutil
import sys
import uuid

SKIP = {'.godot', '.git', '__pycache__', '.pytest_cache', '.mypy_cache'}

def discover(root: Path) -> list[Path]:
    found = []
    for base, dirs, files in os.walk(root, followlinks=False):
        at = Path(base)
        depth = len(at.relative_to(root).parts)
        dirs[:] = [d for d in dirs if d not in SKIP and not d.startswith('.phase2_stage') and (depth < 6)]
        if at == root / 'game':
            dirs.clear()
            continue
        if 'project.godot' in files:
            found.append(at)
            dirs.clear()  # project root; do not find spurious nested project copies
    return sorted(found)

def inside(path: Path, root: Path) -> bool:
    try:
        path.resolve().relative_to(root.resolve())
        return True
    except ValueError:
        return False

def file_stat(source: Path) -> tuple[int, int, list[Path]]:
    count = total = 0
    symlinks = []
    for path in source.rglob('*'):
        if any(part in SKIP for part in path.relative_to(source).parts):
            continue
        if path.is_symlink():
            symlinks.append(path)
        elif path.is_file():
            count += 1
            total += path.stat().st_size
    return count, total, symlinks

def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--root', default='.', help='OUTER repository root (contains this phase-2 package)')
    parser.add_argument('--source', help='Specific nested directory containing project.godot')
    parser.add_argument('--apply', action='store_true', help='Execute safe copy, otherwise dry-run only')
    args = parser.parse_args()
    root = Path(args.root).expanduser().resolve()
    dest = root / 'game'
    if not (root / 'AGENTS.md').is_file() or not (root / 'scripts/promote_game.py').is_file():
        print('ERROR: --root does not appear to be the outer Phase-2 folder.', file=sys.stderr)
        return 2
    if dest.exists() or dest.is_symlink():
        if (dest / 'project.godot').is_file():
            print(f'Outer game already exists at {dest}. Canonical; NO COPY OR OVERWRITE.')
            return 0
        print('ERROR: ./game already exists but lacks project.godot. Do not overwrite it; inspect manually.',file=sys.stderr)
        return 2
    if args.source:
        source = Path(args.source).expanduser()
        if not source.is_absolute():
            source = root / source
        source = source.resolve()
        candidates = [source]
    else:
        candidates = discover(root)
    candidates = [s for s in candidates if (s / 'project.godot').is_file() and s != dest]
    if len(candidates) != 1:
        print('ERROR: expected exactly one nested Godot project. Candidates:',len(candidates),file=sys.stderr)
        for candidate in candidates: print(' -', candidate,file=sys.stderr)
        print('Specify: python3 scripts/promote_game.py --root . --source "OldPackage/game"',file=sys.stderr)
        return 2
    source = candidates[0]
    if not inside(source, root) or source == root:
        print('ERROR: source must be a nested project directory inside OUTER root.',file=sys.stderr)
        return 2
    count, total, symlinks = file_stat(source)
    print(f'SOURCE (unchanged): {source}\nDESTINATION: {dest}\nFiles (excluding caches): {count}; bytes: {total:,}')
    if symlinks:
        print('ERROR: symlinks found in source. Review manually; not copying:',file=sys.stderr)
        for link in symlinks[:25]: print(' -',link,file=sys.stderr)
        return 2
    if not args.apply:
        print('DRY RUN ONLY. Add --apply to copy without deleting or overwriting the source.')
        return 0
    staging = root / ('.phase2_stage_' + uuid.uuid4().hex)
    try:
        shutil.copytree(source, staging, ignore=shutil.ignore_patterns(*SKIP), symlinks=False)
        if not (staging / 'project.godot').is_file():
            raise RuntimeError('staged Godot project missing project.godot')
        if dest.exists() or dest.is_symlink():
            raise RuntimeError('Destination appeared during copying; refusing overwrite')
        staging.rename(dest)
        print('SUCCESS: promoted copy to',dest)
        print('Original nested project remains untouched at',source)
        return 0
    except Exception as exc:
        print('ERROR while copying:',exc,file=sys.stderr)
        return 1
    finally:
        if staging.exists():
            shutil.rmtree(staging)

if __name__ == '__main__':
    raise SystemExit(main())

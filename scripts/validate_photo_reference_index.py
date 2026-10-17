#!/usr/bin/env python3
"""Report new/changed supplied photos; never equate index presence with fidelity."""
import hashlib
import json
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
EXTENSIONS = {'.jpg', '.jpeg', '.png', '.webp', '.avif', '.tif', '.tiff'}


def main():
    records = json.loads((ROOT / 'data/photo_review_coverage.json').read_text())
    indexed = {record['file']: record for record in records}
    photos = {p.relative_to(ROOT).as_posix(): p for p in (ROOT / 'reference_photos').rglob('*')
              if p.is_file() and p.suffix.lower() in EXTENSIONS}
    findings = []
    if len(indexed) != len(records):
        findings.append('Duplicate file records in coverage index')
    for name, path in sorted(photos.items()):
        record = indexed.get(name)
        if record is None:
            findings.append('NEW: ' + name)
        elif hashlib.sha256(path.read_bytes()).hexdigest() != record['sha256']:
            findings.append('CHANGED: ' + name)
        elif not (ROOT / record['review_index']).is_file():
            findings.append('MISSING REVIEW INDEX: ' + record['review_index'])
    for name in sorted(indexed.keys() - photos.keys()):
        findings.append('MISSING PHOTO: ' + name)
    print(f'Photo inventory: {len(photos)} files; {len(indexed)} indexed; {len(findings)} findings.')
    for finding in findings:
        print(finding)
    print('Index/hash validation does not establish architectural accuracy or reuse rights.')
    return bool(findings)


if __name__ == '__main__':
    raise SystemExit(main())

"""Archive obsolete instructions outside the repository, verify hashes, then remove.

Only Markdown is eligible. Runtime files and source attribution are preserved.
"""
from pathlib import Path
import hashlib
import json
import shutil

ROOT = Path(__file__).resolve().parent.parent
OLD = ROOT / 'SFU_Residences_Codex_WSL2_Godot472_OnlineAPI'
BACKUP = Path.home() / 'Backups/SFU-Residence-Phase1-docs-20261016'
KEEP = {'ASSUMPTIONS.md', 'ATTRIBUTION.md', 'BUILDING_CHECKLIST.md', 'RESEARCH_LOG.md', 'LICENSE.md'}

def digest(p):
    return hashlib.sha256(p.read_bytes()).hexdigest()

def main():
    assert (ROOT / 'game/project.godot').is_file()
    assert not BACKUP.resolve().is_relative_to(ROOT.resolve())
    selected = [p for p in OLD.rglob('*.md') if p.name not in KEEP]
    manifest = []
    for source in selected:
        target = BACKUP / source.relative_to(ROOT)
        target.parent.mkdir(parents=True, exist_ok=True)
        if target.exists():
            assert digest(source) == digest(target), f'Backup conflict: {target}'
        else:
            shutil.copy2(source, target)
        assert digest(source) == digest(target)
        manifest.append({'source': str(source.relative_to(ROOT)), 'backup': str(target), 'sha256': digest(source)})
    BACKUP.mkdir(parents=True, exist_ok=True)
    (BACKUP / 'manifest.json').write_text(json.dumps(manifest, indent=2))
    for source in selected:
        source.unlink()
    (ROOT / 'docs/PHASE1_ARCHIVE.json').write_text(json.dumps(manifest, indent=2))
    print(f'Archived, hash-verified and removed {len(selected)} obsolete Markdown files; backup: {BACKUP}')

if __name__ == '__main__':
    main()

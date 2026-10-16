"""Validate a clean, isolated copy without modifying the working project's cache."""
from pathlib import Path
import tempfile, shutil, subprocess, os
root=Path(__file__).resolve().parents[1]
with tempfile.TemporaryDirectory(prefix='sfu-clean-') as tmp:
    target=Path(tmp)/'game'
    shutil.copytree(root/'game',target,ignore=shutil.ignore_patterns('.godot'))
    for args in [['--editor','--quit'],['--quit-after','12']]:
        run=subprocess.run([os.environ.get('GODOT_BIN','godot'),'--headless','--path',str(target),*args],text=True,capture_output=True,timeout=90)
        output=run.stdout+run.stderr
        print(output)
        assert run.returncode==0 and 'SCRIPT ERROR' not in output and 'ERROR:' not in output
    print('PASS clean copy imports and launches with no pre-existing .godot cache.')

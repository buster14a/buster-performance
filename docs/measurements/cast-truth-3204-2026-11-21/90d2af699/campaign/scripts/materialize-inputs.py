"""Materialize exactly the archived inputs used by the published regression campaign."""
import argparse
from pathlib import Path
import re
import subprocess
p=argparse.ArgumentParser();p.add_argument('repository',type=Path);p.add_argument('output',type=Path)
args=p.parse_args()
sha='c00fc41627b5585208f02f7edf667583e8a14f08'
prefix='docs/measurements/'
paths=subprocess.check_output(['git','ls-tree','-r','--name-only',sha,prefix], cwd=args.repository,text=True).splitlines()
group='tests-holes-2850-2026-11-21/'
needed={group+s for s in ['sweep/extract.py','sweep/sweep.py','probes/probe.py','triggers/triggers.py']}
needed.add('summary-facts-2850-2026-11-21/fuzz/fuzz.py')
needed.update(f.removeprefix(prefix) for f in paths if re.search(r'/probes/cases[^/]*\.py$',f))
assert len(needed)==31
for rel in sorted(needed):
 dest=args.output / rel; dest.parent.mkdir(parents=True,exist_ok=True)
 dest.write_bytes(subprocess.check_output(['git','show',f'{sha}:{prefix}{rel}'],cwd=args.repository))

"""Compare ordinary and source-compact compiler output on the frozen generated TUs."""
import csv
import hashlib
import os
from pathlib import Path
import re
import subprocess
import sys

base = Path(__file__).resolve().parent
compiler = Path(sys.argv[1]).resolve()
out = Path(sys.argv[2]).resolve() if len(sys.argv) > 2 else base / 'generated'
sources = [Path(arg).resolve() for arg in sys.argv[3:]]
if not sources:
    source_dir = base / 'fixtures' if (base / 'fixtures').is_dir() else base.parent / 'root-splice-study/generated'
    sources = sorted(source_dir.glob('types-*.c')) + [base / 'smoke.c']
out.mkdir(parents=True, exist_ok=True)
options = {name: '1' for name in ('NODE_PROOF_NO_FP','NODE_PROOF_POINTERS','NODE_PROOF_CALLS','NODE_SOURCE_ROWS','NODE_PROOF_NATIVE','NODE_SPLICE_FRONT','NODE_SPLICE_ENABLE','NODE_SPLICE_REPORT','NODE_SOURCE_COMPACT','NODE_SOURCE_COMPACT_REPORT','NODE_SOURCE_LOCAL_ACCESS','NODE_SOURCE_PRUNED_GUARDS')}
clean = {k:v for k,v in os.environ.items() if not k.startswith('NODE_')}
policies = {'default': [], 'debug': ['-g'], 'uninit': ['-Wuninitialized'], 'unused': ['-Wunused-but-set-parameter'], 'wall': ['-Wall','-Wextra']}
with (out / 'matrix.tsv').open('w') as f:
    writer = csv.writer(f, delimiter='\t', lineterminator='\n')
    writer.writerow('source policy status-plain status-wide compact consumed deleted diagnostics-equal stdout-equal object-equal'.split())
    for source in sources:
        for policy, flags in policies.items():
            results = []
            for mode in ('plain','wide'):
                obj = out / f'{source.stem}-{policy}-{mode}.o'
                obj.unlink(missing_ok=True)
                env = clean if mode == 'plain' else dict(clean, **options)
                p = subprocess.run([compiler,'--lanes','1','-c',*flags,source,'-o',obj],env=env,capture_output=True)
                debug = (b'source-rows ',b'node-proof ',b'probe-',b'splice-taken:',b'compact-consumed:',b'compact-taken:',b'splice-local-class:')
                diagnostics = [line for line in p.stderr.splitlines(keepends=True) if not line.startswith(debug)]
                roots = re.findall(rb'^compact-taken: .*?removed=(\d+)',p.stderr,re.M)
                consumed = len(re.findall(rb'^compact-consumed:',p.stderr,re.M))
                digest = hashlib.sha256(obj.read_bytes()).hexdigest() if obj.exists() else None
                results.append((p.returncode,diagnostics,digest,len(roots),consumed,sum(map(int,roots)),p.stdout))
            a,b = results
            writer.writerow([source.name,policy,a[0],b[0],*b[3:6],int(a[1]==b[1]),int(a[6]==b[6]),int(a[2]==b[2])])

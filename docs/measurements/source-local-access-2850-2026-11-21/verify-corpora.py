"""Compare actual compile and local access compaction for four frozen C corpora."""
from concurrent.futures import ThreadPoolExecutor
import csv
import hashlib
import json
import os
from pathlib import Path
import re
import shlex
import subprocess
import sys
from tempfile import TemporaryDirectory

compiler, output = map(lambda a:Path(a).resolve(), sys.argv[1:3])
output.mkdir(parents=True, exist_ok=True)
jobs = []
for corpus, args in zip(('sqlite','lua','musl','buster'),sys.argv[3:7]):
    argv = shlex.split(args)
    flags = [arg for arg in argv if not arg.endswith('.c')]
    for arg in argv:
        if arg.endswith('.c'):
            for policy, extra in (('default',[]),('wall',['-Wall','-Wextra'])):
                jobs.append((corpus,policy,Path(arg).resolve(),flags+extra))
base = {k:v for k,v in os.environ.items() if not k.startswith('NODE_')}
flags = {name:'1' for name in ('NODE_PROOF_NO_FP','NODE_PROOF_POINTERS','NODE_PROOF_CALLS','NODE_SOURCE_ROWS','NODE_PROOF_NATIVE','NODE_SPLICE_FRONT','NODE_SPLICE_ENABLE','NODE_SPLICE_REPORT','NODE_SOURCE_COMPACT','NODE_SOURCE_COMPACT_REPORT','NODE_SOURCE_LOCAL_ACCESS','NODE_SOURCE_PRUNED_GUARDS')}
trace = (b'source-rows ',b'node-proof ',b'probe-',b'splice-taken:',b'compact-consumed:',b'compact-taken:',b'splice-local-class:')
def digest(b):
    return hashlib.sha256(b).hexdigest()
def run(job):
    corpus,policy,source,options=job
    file = str(source).split('/switch-inputs/')[-1] if corpus != 'buster' else 'src/buster/compiler/main.c'
    modes = []
    with TemporaryDirectory(dir=output) as scratch:
        for mode,env in [('plain',base),('compact',dict(base,**flags))]:
            obj=Path(scratch)/'output.o'
            obj.unlink(missing_ok=True)
            p=subprocess.run([compiler,'--lanes','1','-c',*options,source,'-o',obj],env=env,capture_output=True)
            diag=b''.join(line for line in p.stderr.splitlines(keepends=True) if not line.startswith(trace))
            h=digest(obj.read_bytes()) if obj.exists() else ''
            taken=re.findall(rb'^compact-taken: token=(\d+).*?removed=(\d+)',p.stderr,re.M)
            consumed={int(n) for n in re.findall(rb'^compact-consumed: token=(\d+)',p.stderr,re.M)}
            modes.append((p.returncode,digest(diag),h,digest(p.stdout),len(taken),len(consumed),sum(int(r[1]) for r in taken)))
            if p.returncode != 0 and corpus=='buster':
                (output/f'{policy}-{mode}.stderr').write_bytes(diag)
    a,b=modes
    return [corpus,policy,file,*a[:4],*b[:4],*b[4:],int(a[:4]==b[:4])]
header='corpus policy file plain_status plain_stderr plain_elf plain_stdout compact_status compact_stderr compact_elf compact_stdout roots consumed deleted identical'.split()
rows=[]
with (output/'receipts.tsv').open('w') as f, ThreadPoolExecutor(max_workers=2) as pool:
    w=csv.writer(f,delimiter='\t',lineterminator='\n')
    w.writerow(header)
    for i,row in enumerate(pool.map(run,jobs)):
        rows.append(row)
        w.writerow(row)
        if i%100==0:f.flush()
summary=[]
for corp in ('sqlite','lua','musl','buster'):
    for policy in ('default','wall'):
        group=[r for r in rows if r[:2]==[corp,policy]]
        summary.append(dict(corpus=corp,policy=policy,tus=len(group),clean=sum(r[3]==0 for r in group),identical=sum(r[-1] for r in group),roots=sum(r[-4] for r in group),consumed=sum(r[-3] for r in group),deleted=sum(r[-2] for r in group)))
(output/'summary.json').write_text(json.dumps(summary,indent=2)+'\n')

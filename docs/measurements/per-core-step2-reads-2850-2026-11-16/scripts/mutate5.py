#!/usr/bin/env python3
# mutate5.py: each single change of the reads' census in turn, built (Debug), run on the fixture as a file and by the
# census tests (test-checker part 5/8); the census's file restored after each. One line a change in mutate5.log.
# The published build/compiler is the last mutant's when this ends: rebuild before any other run.
import subprocess, sys, re, os
S=os.environ['SCRATCH']  # the scratch directory: reads-before-mutations.c, reads/reads.c, reads_mutations.py
sys.path.insert(0,S)
from reads_mutations import MUTATIONS
ROOT='/home/user/buster'
F=ROOT+'/src/buster/compiler/c_check_node_machine_reads.c'
original=open(S+'/reads-before-mutations.c').read()
assert open(F).read()==original
log=open(S+"/mutate5.log","a")
def sh(cmd, timeout=3000):
    return subprocess.run(cmd, shell=True, cwd=ROOT, capture_output=True, text=True, timeout=timeout)
only=sys.argv[1:]
for index,(name,old,new,which) in enumerate(MUTATIONS):
    if only and str(index) not in only: continue
    if old==new:
        line='%2d %-58s SKIPPED (no change written)' % (index, name)
        print(line); log.write(line+'\n'); log.flush(); continue
    parts=original.split(old)
    assert len(parts)>which+1, name
    mutated=old.join(parts[:which+1])+new+old.join(parts[which+1:])
    open(F,'w').write(mutated)
    try:
        b=sh('./build.sh --config Debug')
        if b.returncode!=0:
            line='%2d %-58s BUILD FAILED: %s' % (index, name, (b.stdout+b.stderr)[-400:].replace('\n',' '))
        else:
            r=sh('./build/compiler measure-node-machine --shadow --facts-reads --passes 0 %s/reads/reads.c' % S)
            out=r.stdout+r.stderr
            m=re.search(r'with none changed=(\d+) differences=(\d+)', out)
            t=sh('./build/compiler test-checker --seed 133 --part 5/8')
            tm=re.search(r'(\d+) checks, (\d+) failures', t.stdout+t.stderr)
            line='%2d %-58s fixture: status=%d same-differences=%s | tests failures=%s (status %d)' % (
                index, name, r.returncode, m.group(2) if m else '?', tm.group(2) if tm else '?', t.returncode)
    finally:
        open(F,'w').write(original)
    print(line, flush=True); log.write(line+'\n'); log.flush()
print('mutations done', flush=True)

#!/usr/bin/env python3
# mutate5.py: mutate2.py for mutations5.py's changes: each single change of the operators' kernel in turn, built (Debug) and run on the compiler's own source,
# on sqlite3.c and by the census tests; the kernel's file restored after each. One line a change in mutate2.log.
import subprocess, sys, re, os
S='/tmp/claude-0/-home-user/743aa3e7-1556-5d1b-ba6c-46b8ead1bd58/scratchpad'
sys.path.insert(0,S)
from mutations5 import MUTATIONS
ROOT='/home/user/buster'
F=ROOT+'/src/buster/compiler/c_check_node_machine_facts.c'
original=open(S+'/facts-ops-pr.c').read()
assert open(F).read()==original
log=open(S+"/mutate5.log","a")
def sh(cmd, timeout=3000):
    return subprocess.run(cmd, shell=True, cwd=ROOT, capture_output=True, text=True, timeout=timeout)
def facts(args, file_args):
    r=sh('./build/compiler measure-node-machine --shadow %s --passes 0 %s' % (args, file_args))
    out=r.stdout+r.stderr
    m=re.search(r'node-facts: taken .*differences=(\d+) list-differences=(\d+) failures=(\d+) \(differences over decoys (\d+)\)', out)
    d=re.search(r'conversions=(\d+) derived=(\d+)', out)
    return (m.groups() if m else ('?','?','?','?')), (d.groups() if d else None)
MAIN='-march=native -Isrc -fwrapv -funsigned-char --predefines build/predefines.h src/buster/compiler/main.c'
SQ='-DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -I%s/corpus/sqlite %s/corpus/sqlite/sqlite3.c' % (S,S)
only=sys.argv[1:]
for index,(name,old,new,which) in enumerate(MUTATIONS):
    if only and str(index) not in only: continue
    parts=original.split(old)
    assert len(parts)>which+1, name
    mutated=old.join(parts[:which+1])+new+old.join(parts[which+1:])
    open(F,'w').write(mutated)
    try:
        b=sh('./build.sh --config Debug')
        if b.returncode!=0:
            line='%2d %-55s BUILD FAILED: %s' % (index, name, (b.stdout+b.stderr)[-300:].replace('\n',' '))
        else:
            sh('clang -dM -E -march=native -fwrapv -funsigned-char -x c /dev/null > build/predefines.h')
            w,_=facts('--facts --facts-operators', MAIN)
            l,d=facts('--facts-lean --facts-operators', MAIN)
            q,_=facts('--facts --facts-operators', SQ)
            t=sh('./build/compiler test-checker --seed 133 --part 5/8')
            tm=re.search(r'(\d+) checks, (\d+) failures', t.stdout+t.stderr)
            line='%2d %-55s main whole differ=%s (decoys %s) lists=%s | main lean differ=%s (decoys %s) derived=%s | sqlite3 differ=%s (decoys %s) lists=%s | tests failures=%s' % (
                index, name, w[0], w[3], w[1], l[0], l[3], ('%s/%s' % (d[1], d[0])) if d else '-', q[0], q[3], q[1], tm.group(2) if tm else '?')
    finally:
        open(F,'w').write(original)
    print(line); log.write(line+'\n'); log.flush()
print('mutations done')

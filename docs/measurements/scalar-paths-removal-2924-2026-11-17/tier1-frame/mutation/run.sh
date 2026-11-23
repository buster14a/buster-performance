#!/bin/bash
# run.sh SRC: each mutant of SRC/src/buster/compiler/tier1_frame.c built into the standalone test-tier1-frame harness
set -u
SRC=$1; W=/tmp/claude-0/mut/tree
rm -rf $W; mkdir -p $W; cp -r $SRC/src $W/
python3 - "$W" <<'PY'
import sys, subprocess, shutil
sys.path.insert(0,'/tmp/claude-0/mut'); from mutants import M
W=sys.argv[1]; p=W+'/src/buster/compiler/tier1_frame.c'; orig=open(p).read()
for name,old,new in M:
    n=orig.count(old)
    if n!=1: print(f"{name}: BAD-PATTERN count={n}"); continue
    open(p,'w').write(orig.replace(old,new))
    b=subprocess.run(['clang','-O2','-march=native','-I'+W+'/src','-I'+W+'/src/buster/compiler','-fwrapv','-funsigned-char','-Wall','-o','/tmp/claude-0/mut/t','/tmp/claude-0/h/t.c'],capture_output=True,text=True)
    if b.returncode!=0: print(f"{name}: NOT-BUILT {b.stderr[:200]}"); continue
    verdict='survived'; detail=''
    for args in ([],['--seed','2','--count','2']):
        try:
            r=subprocess.run(['/tmp/claude-0/mut/t']+args,capture_output=True,text=True,timeout=120)
            if r.returncode!=0: verdict='killed'; detail=(r.stderr.strip().splitlines() or ['crash rc=%d'%r.returncode])[0][:150]; break
        except subprocess.TimeoutExpired: verdict='killed'; detail='timeout'; break
    print(f"{name}: {verdict} {detail}", flush=True)
open(p,'w').write(orig)
PY

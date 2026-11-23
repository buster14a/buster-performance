#!/bin/bash
SRC=$1; W=/tmp/claude-0/mm/tree
rm -rf $W; mkdir -p $W; cp -r $SRC/src $W/
python3 - "$W" <<'PY'
import sys, subprocess
sys.path.insert(0,'/tmp/claude-0/mm'); from mutants import M
W=sys.argv[1]; p=W+'/src/buster/compiler/tier1_allocate.c'; orig=open(p).read()
for name,old,new in M:
    if orig.count(old)!=1: print(f"{name}: BAD-PATTERN {orig.count(old)}"); continue
    open(p,'w').write(orig.replace(old,new))
    b=subprocess.run(['clang','-O2','-march=native','-I'+W+'/src','-I'+W+'/src/buster/compiler','-fwrapv','-funsigned-char','-w','-o','/tmp/claude-0/mm/m','/tmp/claude-0/mm/h.c'],capture_output=True,text=True)
    if b.returncode!=0: print(f"{name}: NOT-BUILT {b.stderr[:300]}"); continue
    try:
        r=subprocess.run(['/tmp/claude-0/mm/m'],capture_output=True,text=True,timeout=120)
        v='killed' if r.returncode!=0 else 'survived'; d=(r.stdout+r.stderr).strip().splitlines()[:1]
    except subprocess.TimeoutExpired: v='killed'; d=['timeout']
    print(f"{name}: {v} {d[0][:150] if d else ''}", flush=True)
open(p,'w').write(orig)
PY

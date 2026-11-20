#!/bin/bash
# usage: corpus_report.sh COMPILER OUTDIR [extra flags...]
c=$1; out=$2; shift 2
mkdir -p $out
B=/home/user/buster/build
files="$B/t1p/sqlite3.c $B/lua/src/*.c"
for f in $files; do
  n=$(basename $f .c)
  $c -c --tier1 --tier1-report "$@" -I$B/lua/src -o $out/$n.o $f 2> $out/$n.err > $out/$n.rep || echo "FAIL $n"
done
python3 - $out <<'PY'
import sys,glob,os,subprocess
out=sys.argv[1]
keys=['records','spill_stores','spill_loads','spill_slots','frame_bytes','red_zones','edge_moves','rematerializations','compiled']
tot={k:0 for k in keys}
for r in sorted(glob.glob(out+'/*.rep'))+sorted(glob.glob(out+'/*.err')):
    for line in open(r):
        if line.startswith('tier1\t'):
            d=dict(x.split('=',1) for x in line.strip().split('\t')[1:] if '=' in x)
            for k in keys: tot[k]+=int(d.get(k,0))
text=0
for o in glob.glob(out+'/*.o'):
    s=subprocess.run(['size','-A',o],capture_output=True,text=True).stdout
    for l in s.splitlines():
        p=l.split()
        if p and p[0].startswith('.text'): text+=int(p[1])
print(' '.join(f'{k}={v}' for k,v in tot.items()), 'text=%d'%text)
PY

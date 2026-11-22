#!/bin/bash
set -euo pipefail
cd "$(dirname "$0")"; d=$PWD
python3 iterate.py >build.log 2>&1
cd ../switch-inputs;source ../switch-local-args.sh
tree=$PWD/../pregraph-warning-study/compiler-source
main_arguments="-march=native -I$tree/src -fwrapv -funsigned-char --predefines $PWD/../proof-predefines.h $tree/src/buster/compiler/main.c"
forced_arguments="-march=native -I$tree/src -fwrapv -funsigned-char --predefines $PWD/../proof-predefines.h $d/../initializer-data-study/force-all.c"
printf 'source\tpolicy\tbase-status\tnew-status\tobject-equal\tdiagnostics-equal\tstdout-equal\tbase-elf\tnew-elf\tproducer\n' >"$d/results.tsv"
for g in members numbers aggregate function sizeof omitted enum float sqlite main forced;do
  if [[ $g = sqlite || $g = main || $g = forced ]];then v=${g}_arguments;eval "args=(${!v})";else args=(-std=gnu23 "$d/../initializer-window-study/cases/$g.c");fi
  for policy in default wall all;do
    opts=();if [[ $policy = wall ]];then opts=(-Wall -Wextra);elif [[ $policy = all ]];then opts=(-Weverything -Wno-c++-compat);fi
    for arm in base new;do
      marks=();if [[ $arm = new ]];then marks=(BUSTER_WINDOW_DATA_PUBLISH=1 BUSTER_WINDOW_DATA_AUDIT=1);fi
      stem=$d/$g.$policy.$arm
      rc=0
      env "${marks[@]}" "$d/compiler" --lanes 1 -c "${args[@]}" "${opts[@]}" -o "$stem.o" >"$stem.out" 2>"$stem.log" || rc=$?
      printf '%d\n' "$rc" > "$stem.status"
      awk '!/^static-published\t/' "$stem.log" >"$stem.diag"
    done
    python3 - "$d" "$g" "$policy" <<'PY'
import hashlib,sys
from pathlib import Path
d=Path(sys.argv[1]);g,p=sys.argv[2:]
def file(arm,end):return d/(g+'.'+p+'.'+arm+'.'+end)
def get(arm,end):
 f=file(arm,end)
 return f.read_bytes() if f.exists() else None
def h(a):return hashlib.sha256(a).hexdigest() if a is not None else '-'
a,b=get('base','o'),get('new','o')
marker=next((l for l in get('new','log').decode(errors='replace').splitlines() if l.startswith('static-published\t')),'absent')
with (d/'results.tsv').open('a') as f:f.write('\t'.join([g,p,get('base','status').decode().strip(),get('new','status').decode().strip(),str(int(a is not None and a==b)),str(int(get('base','diag')==get('new','diag'))),str(int(get('base','out')==get('new','out'))),h(a),h(b),marker.replace('\t',',')])+'\n')
PY
  done
done

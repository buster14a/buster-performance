#!/bin/bash
set -euo pipefail
cd "$(dirname "$0")"
top=$PWD
g=$1
source corpora.sh
main_arguments="-march=native -I$top/pooled-main-source/src -fwrapv -funsigned-char --predefines $top/proof-predefines.h $top/pooled-main-source/src/buster/compiler/main.c"
v=${g}_arguments; eval "args=(${!v})"
base=results/factsmain0e1d/compiler
bin=results/batch082c/compiler
d=results/batch082c-locked/$g
mkdir -p "$d"
for b in base bin;do taskset -c 2 "${!b}" --lanes 1 -c "${args[@]}" -o "$d/$b.o" >"$d/$b.stdout" 2>"$d/$b.stderr";done
cmp "$d/base.o" "$d/bin.o";cmp "$d/base.stderr" "$d/bin.stderr";cmp "$d/base.stdout" "$d/bin.stdout"
sha256sum "$d/base.o" "$d/bin.o" >"$d/objects.tsv"
for r in 1 2 3 4 5;do
 if ((r%2));then order=(dense batch batch dense);else order=(batch dense dense batch);fi
 for i in 0 1 2 3;do mode=${order[i]}
  if [[ $mode == dense ]];then marks=(BUSTER_BODY_DENSE_BOUNDARY=1);else marks=(BUSTER_CHECK_BODY_SOURCE_ONLY=1 BUSTER_SOURCE_ROOT_BATCH=1024);fi
  stem=$d/$g-1024-$r-$i-$mode
  taskset -c 2 python3 batch082c-time.py "$stem.time" env BUSTER_CHECK_SOURCE_DECLARATIONS=1 BUSTER_CHECK_BODY_ADMIT_ALL=1 BUSTER_BODY_DISCARD_RESULT=1 "${marks[@]}" "$bin" --lanes 1 -c "${args[@]}" -o /dev/null >"$stem.stdout" 2>"$stem.stderr"
  if ((r<=3));then
   taskset -c 2 perf stat -x ';' -e cycles,cycles:u,instructions:u,minor-faults -o "$stem.pmu" -- env BUSTER_CHECK_SOURCE_DECLARATIONS=1 BUSTER_CHECK_BODY_ADMIT_ALL=1 BUSTER_BODY_DISCARD_RESULT=1 "${marks[@]}" "$bin" --lanes 1 -c "${args[@]}" -o /dev/null >"$stem.pmu.stdout" 2>"$stem.pmu.stderr"
  fi
 done
done

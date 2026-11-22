#!/bin/bash
set -euo pipefail
cd "$(dirname "$0")"; d=$PWD
cd ../switch-inputs; source ../switch-local-args.sh
source_tree=$PWD/../pregraph-warning-study/compiler-source
main_arguments="-march=native -I$source_tree/src -fwrapv -funsigned-char --predefines $PWD/../proof-predefines.h $source_tree/src/buster/compiler/main.c"
mkdir -p "$d/pmu"
cpu=$(python3 -c 'import os;print(min(os.sched_getaffinity(0)))')
for workload in sqlite main;do
 v=${workload}_arguments;eval "args=(${!v})";args+=(-o "$d/pmu/ordinary.o")
 for round in 1 2 3;do
   order=(base new new base);if [[ $round == 2 ]];then order=(new base base new);fi
   for p in 0 1 2 3;do
      label=${order[p]};tree=main-fbef-clean;[[ $label == base ]] || tree=struct-member-facts
      stem="$d/pmu/$workload.$round.$p.$label"
      taskset -c "$cpu" perf stat -x, --no-big-num -o "$stem.perf" -e instructions:u,cycles:u -- "$d/../$tree/build/compiler" --lanes 1 -c "${args[@]}" >"$stem.stdout" 2>"$stem.stderr"
      sha256sum "$d/pmu/ordinary.o" >"$stem.object"
      cmp "$d/pmu/$workload.1.0.base.object" "$stem.object"
      cmp "$d/pmu/$workload.1.0.base.stderr" "$stem.stderr"
   done
 done
done

#!/bin/bash
set -euo pipefail
cd "$(dirname "$0")";d=$PWD
cd ../type-links;python3 "$d/compact-conditions.py" "$PWD"
git diff --binary 84a7d3d76 >"$d/compact-condition.patch"
./build.sh >"$d/compact-condition-build.log" 2>&1
cp build/compiler "$d/compact-condition-compiler";cc=$d/compact-condition-compiler
cd ../switch-inputs;source ../switch-local-args.sh
tree=$PWD/../pregraph-warning-study/compiler-source
main_arguments="-march=native -I$tree/src -fwrapv -funsigned-char --predefines $PWD/../proof-predefines.h $tree/src/buster/compiler/main.c"
switches=(NODE_SOURCE_CONDITION_ONLY=1 NODE_SPLICE_REPORT=1 NODE_SPLICE_FRONT=1 NODE_SPLICE_ENABLE=1 NODE_PROOF_NO_FP=1 NODE_PROOF_POINTERS=1 NODE_PROOF_CALLS=1 NODE_SOURCE_ROWS=1 NODE_PROOF_NATIVE=1 NODE_CROSS_CHUNK=n NODE_CROSS_TYPE_VIEW=1 NODE_CROSS_INCREMENTAL=1 NODE_CROSS_ARG_EPOCH=1 NODE_CROSS_FAST_REQUEST=1 NODE_SOURCE_STRINGS=1 NODE_CROSS_UNINDEXED=1 NODE_SOURCE_CONDITION=1 NODE_SOURCE_CONDITION_ORIGINS=1 NODE_SOURCE_ORIGIN_PUBLISHERS=1 NODE_SOURCE_CONSUME_CONDITION=1 NODE_SOURCE_CONSUME_BRANCH=1 NODE_SOURCE_CONSUME_LABELS=1 NODE_SOURCE_LABELS=1 NODE_SOURCE_CONSUME_POINTER=1)
for g in fixture sqlite main;do
 if [[ $g == fixture ]];then args=("$d/condition-runtime/conditional.c");else v=${g}_arguments;eval "args=(${!v})";fi
 for policy in default debug wall;do
  p=$d/physically-compact/$g-$policy;mkdir -p "$p"
  flags=();[[ $policy != debug ]] || flags=(-g);[[ $policy != wall ]] || flags=(-Wall -Wextra)
  for mode in plain source compact;do
   envs=(env)
   if [[ $mode != plain ]];then envs+=("${switches[@]}");fi
   if [[ $mode == compact ]];then envs+=(NODE_SOURCE_COMPACT=1 NODE_SOURCE_COMPACT_REPORT=1 NODE_SOURCE_COMPACT_CONDITION=1);fi
   rm -f "$p/$mode.native" "$p/$mode.bin"
   "${envs[@]}" NODE_SOURCE_NATIVE_ORACLE="$p/$mode.native" NODE_SOURCE_GRAPH_ORACLE="$p/$mode.bin" "$cc" --lanes 1 -c "${flags[@]}" "${args[@]}" -o "$p/$mode.o" >"$p/$mode.out" 2>"$p/$mode.err" && st=0 || st=$?
   echo "$st" >"$p/$mode.status"
  done
  if [[ $(cat "$p/compact.status") == 0 ]];then python3 "$d/../source-graph-study/graph_check.py" "$p" plain compact source >"$p/graph.json" 2>"$p/graph.err" || true;fi
 done
done

#!/bin/bash
set -euo pipefail
cd "$(dirname "$0")"; d=$PWD; cd ../live-traversal-native
./build.sh --config Develop --target compiler --jobs 1 >"$d/build.log" 2>&1
cp ../body-action-rows/build/predefines.h build/
exe=$PWD/build/compiler
cd ../switch-inputs; source ../switch-local-args.sh
tree=$PWD/../pregraph-warning-study/compiler-source; main_arguments="-march=native -I$tree/src -fwrapv -funsigned-char --predefines $PWD/../proof-predefines.h $tree/src/buster/compiler/main.c"
for unit in sqlite main; do
 v=${unit}_arguments; eval "args=(${!v})"
 for policy in default all; do
  flags=(); [[ $policy != all ]] || flags=(-Weverything)
  for arm in ordinary live audit; do
   marks=(); [[ $arm == ordinary ]] || marks=(BUSTER_PARSE_LIVE_FOREST=1); [[ $arm != audit ]] || marks+=(BUSTER_PARSE_LIVE_AUDIT=1)
   stem=$d/$unit.$policy.$arm
   env "${marks[@]}" "$exe" --lanes 1 -c "${args[@]}" "${flags[@]}" -o "$stem.o" >"$stem.out" 2>"$stem.err" && rc=0 || rc=$?
   echo $rc >"$stem.status"
  done
  for ext in o out err status;do cmp "$d/$unit.$policy.ordinary.$ext" "$d/$unit.$policy.live.$ext";done
  cmp "$d/$unit.$policy.audit.o" "$d/$unit.$policy.live.o"
 done
done

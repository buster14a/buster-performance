#!/bin/bash
set -eu
here=$1
exe=$2
baseline=$3
cd "$(dirname "$0")/../switch-inputs"
source ../switch-local-args.sh
eval "args=($sqlite_arguments)"
features=(-DSQLITE_ENABLE_FTS5 -DSQLITE_ENABLE_FTS3 -DSQLITE_ENABLE_SESSION -DSQLITE_ENABLE_PREUPDATE_HOOK -DSQLITE_ENABLE_GEOPOLY -DSQLITE_ENABLE_DBSTAT_VTAB)
for f in default features;do
 add=();if [[ $f = features ]];then add=("${features[@]}");fi
 for policy in default max;do
  opts=();if [[ $policy = max ]];then opts=(-Weverything);fi
  for mode in candidate baseline;do
   compiler=$exe;if [[ $mode = baseline ]];then compiler=$baseline;fi
   stem=$here/frozen-$f-$policy-$mode
   "$compiler" "${opts[@]}" -c "${args[@]}" "${add[@]}" -o "$stem.o" >"$stem.out" 2>"$stem.err"
  done
  for suffix in o out err;do cmp "$here/frozen-$f-$policy-candidate.$suffix" "$here/frozen-$f-$policy-baseline.$suffix";done
 done
done

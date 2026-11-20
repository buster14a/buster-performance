#!/usr/bin/env bash
set -euo pipefail
w=$(pwd);p="$w/region-batch-evidence";export CORES_LINK=https://github.com/buster14a/buster/issues/2542
cd "$w/compile-evidence"
for input in sqlite3 lua/lvm lua/lparser;do
 opts=(-DSQLITE_THREADSAFE=0 -DSQLITE_OMIT_LOAD_EXTENSION);[[ $input == sqlite3 ]] || opts=(-std=gnu99 -DLUA_COMPAT_5_3 -DLUA_USE_LINUX)
 CORES_TITLE="Count repeated debug-region events in ${input##*/}" cores -n 1 -- env SOURCE_DATE_EPOCH=1792454400 "$w/region-batch-count/build/compiler" --tier1 -O2 -g --lanes 1 -march=znver5 -w "${opts[@]}" -c "inputs/$input.c" -o "$p/lifetimes-${input##*/}.o" 2>"$p/lifetimes-${input##*/}.log"
 cmp "$p/lifetimes-${input##*/}.o" "$w/carrier-evidence/visible-regions-${input##*/}.o"
done
touch "$p/whole-census-done"

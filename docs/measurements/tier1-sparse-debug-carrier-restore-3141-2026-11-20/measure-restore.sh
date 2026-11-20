#!/usr/bin/env bash
set -euo pipefail
w=$(pwd);p="$w/carrier-evidence";export CORES_LINK=https://github.com/buster14a/buster/issues/2542
python "$p/count-restore.py"
(cd carrier-count && CORES_TITLE='Count reused, changed and removed carriers in actual DWARF block entry rows' cores -n 2 -- env BUSTER_HOST_ARCH=znver5 ./build.sh --config Release) >"$p/metrics-build.log" 2>&1
cd "$w/compile-evidence"
for input in sqlite3 lua/lvm lua/lparser;do
 opts=(-DSQLITE_THREADSAFE=0 -DSQLITE_OMIT_LOAD_EXTENSION);[[ $input == sqlite3 ]] || opts=(-std=gnu99 -DLUA_COMPAT_5_3 -DLUA_USE_LINUX)
 CORES_TITLE="Census carrier updates in ${input##*/}" cores -n 1 -- env SOURCE_DATE_EPOCH=1792454400 "$w/carrier-count/build/compiler" --tier1 -O2 -g --lanes 1 -march=znver5 -w "${opts[@]}" -c "inputs/$input.c" -o "$p/restore-count-${input##*/}.o" 2>"$p/restore-count-${input##*/}.log"
 cmp "$p/restore-count-${input##*/}.o" "$p/visible-regions-${input##*/}.o"
done
touch "$p/restore-census"

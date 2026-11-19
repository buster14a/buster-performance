#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"
label=$1
compiler=$2
workload=$3
mkdir -p results
out=$(mktemp /dev/shm/buster-inline-XXXXXX.o)
trap 'unlink "$out"' EXIT
args=(-O2 -march=znver5 --lanes 1 -w)
case "$workload" in
 sqlite-tier1) args+=(--tier1 -DSQLITE_THREADSAFE=0 -DSQLITE_OMIT_LOAD_EXTENSION inputs/sqlite3.c);;
 sqlite-tier0) args+=(-DSQLITE_THREADSAFE=0 -DSQLITE_OMIT_LOAD_EXTENSION inputs/sqlite3.c);;
 lua-lvm|lua-lparser) args+=(--tier1 -std=gnu99 -DLUA_COMPAT_5_3 -DLUA_USE_LINUX "inputs/lua/${workload#lua-}.c");;
 *) exit 2;;
esac
{
  date -u -Iseconds
  cat /proc/loadavg
} > "results/$label.load"
LC_ALL=C perf stat --no-big-num -x ';' -e cycles:u,instructions:u,branches:u,branch-misses:u,task-clock -o "results/$label.stat.new" -- taskset -c 2 "./compilers/$compiler" "${args[@]}" -c -o "$out"
sha256sum "$out" | cut -d' ' -f1 > "results/$label.sha256"
wc -c < "$out" > "results/$label.bytes"
{
  date -u -Iseconds
  cat /proc/loadavg
} >> "results/$label.load"
mv "results/$label.stat.new" "results/$label.stat"

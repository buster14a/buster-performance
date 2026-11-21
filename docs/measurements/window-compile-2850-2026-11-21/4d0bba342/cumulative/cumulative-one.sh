#!/bin/bash
# Each process is run under the host lock and pinned to CPU 2 by the launcher.
set -euo pipefail
series=$1
mode=$2
stem=$3
obj=$4
case "$mode" in
 main) label=mainbd3; opts=() ;;
 returns|returns-copy) label=baked177; opts=(--node-window) ;;
 reads) label=read227; opts=(--node-window) ;;
 discards) label=discard4d0; opts=(--node-window) ;;
 *) exit 2 ;;
esac
binary=$PWD/results/$label/compiler
sql=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
args=("${opts[@]}" -c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$sql" "$sql/sqlite3.c" -o "$obj")
rm -f "$obj"
case "$series" in
 pmu)
   perf stat --no-big-num -x, -o "$stem.perf" -e '{cycles:u,instructions:u,cycles:k,instructions:k}' -e task-clock,page-faults,context-switches,cpu-migrations -- "$binary" "${args[@]}" >"$stem.stdout" 2>"$stem.stderr"
   ;;
 wall)
   "$PWD/results/baked177/compiler" time-runs --runs 1 --warmups 1 --executable "$binary" --list "${args[@]}" >"$stem.wall" 2>"$stem.stderr"
   ;;
 *) exit 2 ;;
esac
test -s "$obj"

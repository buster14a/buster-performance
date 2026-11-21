#!/bin/bash
set -euo pipefail
experiment=$1
kind=$2
which=$3
stem=$4
obj=$5
source ./native-store-screen-config.sh
sql=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
args=(-c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$sql" "$sql/sqlite3.c" -o "$obj")
if [[ -n ${flag[$which]} ]]; then args=("${flag[$which]}" "${args[@]}"); fi
if [[ -n ${stage[$which]-} ]]; then
  export BUSTER_CONDITION_COST="${stage[$which]}"
  if [[ $kind == stage ]]; then export BUSTER_CONDITION_COST_REPORT=1; else unset BUSTER_CONDITION_COST_REPORT; fi
fi
exe=$PWD/results/${binary[$which]}/compiler
rm -f "$obj"
case "$kind" in
 stage)
   "$exe" --time-stages "${args[@]}" >"$stem.stdout" 2>"$stem.stderr"
   count=$(sed -n 's/^node-window: taken=\([0-9]*\).*/\1/p' "$stem.stderr")
   test "${count:-0}" = "${expected[$which]}"
   ;;
 warnings) "$exe" -Wall -Wextra "${args[@]}" >"$stem.stdout" 2>"$stem.stderr" ;;
 pmu) perf stat --no-big-num -x, -o "$stem.perf" -e '{cycles:u,instructions:u,cycles:k,instructions:k}' -e task-clock,page-faults,context-switches,cpu-migrations -- "$exe" "${args[@]}" >"$stem.stdout" 2>"$stem.stderr" ;;
 wall) "$PWD/results/baked177/compiler" time-runs --runs 1 --warmups 1 --executable "$exe" --list "${args[@]}" >"$stem.wall" 2>"$stem.stderr" ;;
 *) exit 2 ;;
esac
sha256sum "$obj" | cut -d' ' -f1 >"$stem.sha256"
wc -c < "$obj" >"$stem.bytes"

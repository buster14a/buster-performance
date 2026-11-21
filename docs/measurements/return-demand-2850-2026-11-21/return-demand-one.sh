#!/bin/bash
set -euo pipefail
experiment=$1
kind=$2
which=$3
stem=$4
obj=$5
source ./return-demand-config.sh
sql=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
args=(-c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$sql" "$sql/sqlite3.c" -o "$obj")
unset BUSTER_RETURN_REPORT BUSTER_RETURN_DEMAND
if [[ $which == on ]]; then export BUSTER_RETURN_DEMAND=1; fi
exe=${binary[$which]}
rm -f "$obj"
case "$kind" in
 stage)
   "$exe" --time-stages "${args[@]}" >"$stem.stdout" 2>"$stem.stderr"
   ;;
 verify)
   BUSTER_RETURN_REPORT=1 BUSTER_RETURN_DEMAND=verify "$exe" "${args[@]}" >"$stem.stdout" 2>"$stem.stderr"
   grep -Fxq 'return-demand: graph=323623 bodies=2674 eligible=1708 controls=43001 sealed=1631 coarse=77 exact=0 roots=0 demanded=0 deep=0' "$stem.stderr"
   ;;
 warnings) "$exe" -Wall -Wextra "${args[@]}" >"$stem.stdout" 2>"$stem.stderr" ;;
 pmu) perf stat --no-big-num -x, -o "$stem.perf" -e '{cycles:u,instructions:u,cycles:k,instructions:k}' -e task-clock,page-faults,context-switches,cpu-migrations -- "$exe" "${args[@]}" >"$stem.stdout" 2>"$stem.stderr" ;;
 wall) "$PWD/results/baked177/compiler" time-runs --runs 1 --warmups 1 --executable "$exe" --list "${args[@]}" >"$stem.wall" 2>"$stem.stderr" ;;
 *) exit 2 ;;
esac
sha256sum "$obj" | cut -d' ' -f1 >"$stem.sha256"
wc -c < "$obj" >"$stem.bytes"

#!/bin/bash
set -euo pipefail
experiment=$1
kind=$2
which=$3
stem=$4
obj=$5
source ./program-roots-config.sh
sql=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
args=(-c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$sql" "$sql/sqlite3.c" -o "$obj")
unset BUSTER_PROGRAM_DIRECT_ROOTS
if [[ $which == on ]]; then export BUSTER_PROGRAM_DIRECT_ROOTS=on; fi
exe=${binary[$which]}
rm -f "$obj"
case "$kind" in
 stage)
   "$exe" --time-stages "${args[@]}" >"$stem.stdout" 2>"$stem.stderr"
   ;;
 verify)
   BUSTER_PROGRAM_DIRECT_ROOTS=verify "$exe" "${args[@]}" >"$stem.stdout" 2>"$stem.stderr"
   grep -Eq '^program-direct-roots: tokens=[0-9]+ graph=[0-9]+ reads=40299 head_diffs=0 next_diffs=0$' "$stem.stderr"
   ;;
 warnings) "$exe" -Wall -Wextra "${args[@]}" >"$stem.stdout" 2>"$stem.stderr" ;;
 pmu) perf stat --no-big-num -x, -o "$stem.perf" -e '{cycles:u,instructions:u,cycles:k,instructions:k}' -e task-clock,page-faults,context-switches,cpu-migrations -- "$exe" "${args[@]}" >"$stem.stdout" 2>"$stem.stderr" ;;
 wall) "$PWD/results/baked177/compiler" time-runs --runs 1 --warmups 1 --executable "$exe" --list "${args[@]}" >"$stem.wall" 2>"$stem.stderr" ;;
 *) exit 2 ;;
esac
sha256sum "$obj" | cut -d' ' -f1 >"$stem.sha256"
wc -c < "$obj" >"$stem.bytes"

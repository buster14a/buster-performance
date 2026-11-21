#!/bin/bash
set -euo pipefail
experiment=$1
kind=$2
which=$3
stem=$4
obj=$5
source ./body-markers-config.sh
corpus=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
case "$experiment" in
 markers735)
    sql=$corpus/sqlite
    source_file="$sql/sqlite3.c"
    flags=(-DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$sql") ;;
 *) exit 2 ;;
esac
unset BUSTER_CONTROL_PEER_MODE
if [[ $which == on ]];then export BUSTER_CONTROL_PEER_MODE=sparse;fi
args=(-c "${flags[@]}" "$source_file" -o "$obj")
exe=$PWD/results/${binary[$which]}/compiler
rm -f "$obj"
case "$kind" in
 stage)
   "$exe" --time-stages "${args[@]}" >"$stem.stdout" 2>"$stem.stderr"
   sha256sum "$source_file" | cut -d' ' -f1 >"$stem.source-sha256"
   wc -c <"$source_file" > "$stem.source-bytes"
   ;;
 audit) BUSTER_CONTROL_PEER_MODE=audit "$exe" "${args[@]}" >"$stem.stdout" 2>"$stem.stderr" ;;
 warnings) "$exe" -Wall -Wextra "${args[@]}" >"$stem.stdout" 2>"$stem.stderr" ;;
 pmu) perf stat --no-big-num -x, -o "$stem.perf" -e '{cycles:u,instructions:u,cycles:k,instructions:k}' -e task-clock,page-faults,context-switches,cpu-migrations -- "$exe" "${args[@]}" >"$stem.stdout" 2>"$stem.stderr" ;;
 wall) "$PWD/results/baked177/compiler" time-runs --runs 1 --warmups 1 --executable "$exe" --list "${args[@]}" >"$stem.wall" 2>"$stem.stderr" ;;
 *) exit 2 ;;
esac
sha256sum "$obj" | cut -d' ' -f1 >"$stem.sha256"
wc -c < "$obj" >"$stem.bytes"

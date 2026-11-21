#!/bin/bash
set -euo pipefail
experiment=$1
kind=$2
which=$3
stem=$4
obj=$5
source ./source-origins-config.sh
corpus=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
case "$experiment" in
 origin57d-sqlite)
    sql=$corpus/sqlite
    source_file="$sql/sqlite3.c"
    flags=(-DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$sql") ;;
 origin57d-main)
    source_file="$PWD/pooled-main-source/src/buster/compiler/main.c"
    flags=(-march=native "-I$PWD/pooled-main-source/src" -fwrapv -funsigned-char --predefines "$PWD/proof-predefines.h") ;;
 *) exit 2 ;;
esac
unset NODE_SOURCE_COMPACT_DRY
args=(-c "${flags[@]}" "$source_file" -o "$obj")
[[ $experiment == origin57d-main ]] && args=(--lanes 1 "${args[@]}")
exe=$PWD/results/${binary[$which]}/compiler
rm -f "$obj"
case "$kind" in
 stage)
   "$exe" --time-stages "${args[@]}" >"$stem.stdout" 2>"$stem.stderr"
   sha256sum "$source_file" | cut -d' ' -f1 >"$stem.source-sha256"
   wc -c <"$source_file" > "$stem.source-bytes"
   ;;
 warnings) "$exe" -Wall -Wextra "${args[@]}" >"$stem.stdout" 2>"$stem.stderr" ;;
 pmu) perf stat --no-big-num -x, -o "$stem.perf" -e '{cycles:u,instructions:u,cycles:k,instructions:k}' -e task-clock,page-faults,context-switches,cpu-migrations -- "$exe" "${args[@]}" >"$stem.stdout" 2>"$stem.stderr" ;;
 wall) "$PWD/results/baked177/compiler" time-runs --runs 1 --warmups 1 --executable "$exe" --list "${args[@]}" >"$stem.wall" 2>"$stem.stderr" ;;
 origin57d-main)
    source_file="$PWD/pooled-main-source/src/buster/compiler/main.c"
    flags=(-march=native "-I$PWD/pooled-main-source/src" -fwrapv -funsigned-char --predefines "$PWD/proof-predefines.h") ;;
 *) exit 2 ;;
esac
sha256sum "$obj" | cut -d' ' -f1 >"$stem.sha256"
wc -c < "$obj" >"$stem.bytes"

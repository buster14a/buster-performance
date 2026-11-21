#!/bin/bash
set -euo pipefail
kind=$1; mode=$2; stem=$3; obj=$4
cd ~/buster-fast-bench/2850-codex-step2
for key in ${!BUSTER_CALL_@} ${!BUSTER_PTR_@}; do unset "$key"; done
unset BUSTER_DISCARD_PTR
[[ $mode != proto ]] || export BUSTER_DISCARD_PTR=1
sql=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
args=(--node-window --lanes 1 -c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$sql" "$sql/sqlite3.c" -o "$obj")
exe=$PWD/results/callptr1b6/compiler
rm -f "$obj"
case $kind in
 stage)
    "$exe" --time-stages "${args[@]}" > "$stem.stdout" 2> "$stem.stderr"
    if [[ $mode == proto ]]; then expect=3650; else expect=2977; fi
    grep -q "^node-window: taken=$expect " "$stem.stderr"
    ;;
 pmu)
    perf stat --no-big-num -x, -o "$stem.perf" -e '{cycles:u,instructions:u,cycles:k,instructions:k}' -e task-clock,page-faults,context-switches,cpu-migrations -- "$exe" "${args[@]}" > "$stem.stdout" 2> "$stem.stderr"
    ;;
esac
sha256sum "$obj" | cut -d' ' -f1 > "$stem.sha256"
wc -c < "$obj" > "$stem.bytes"

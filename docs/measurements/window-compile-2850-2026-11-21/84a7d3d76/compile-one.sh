#!/bin/bash
set -euo pipefail
cd ~/buster-fast-bench/2850-codex-step2
label=$1; tag=$2; root=$3; binary=$4
sql=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
out=$PWD/results/$label/real
obj=$root/sqlite3.o
rm -f "$obj"
args=(-c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$sql" "$sql/sqlite3.c" -o "$obj")
if [[ $tag == on-* ]]; then args=(--node-window "${args[@]}"); fi
if [[ $tag == *stages ]]; then
 taskset -c 2 "$binary" --time-stages "${args[@]}" > "$out/$tag.stdout" 2> "$out/$tag.stderr"
else
 taskset -c 2 perf stat --no-big-num -x, -o "$out/$tag.perf" -e '{cycles:u,instructions:u,cycles:k,instructions:k}' -e duration_time,task-clock,page-faults,context-switches,cpu-migrations -- "$binary" "${args[@]}" > "$out/$tag.stdout" 2> "$out/$tag.stderr"
fi
sha256sum "$obj" | cut -d' ' -f1 > "$out/$tag.sha256"
wc -c < "$obj" > "$out/$tag.bytes"

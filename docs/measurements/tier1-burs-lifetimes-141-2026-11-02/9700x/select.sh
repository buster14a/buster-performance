#!/usr/bin/env bash
# select.sh TREE...: benchmark-tier1-select-source on the frozen sqlite3.c, every process one hold of the shared lock,
# pinned to CPU 2: 5 rounds of both paths interleaved per tree, rotating; then 3 rounds each of --only select,
# --only select --after-scalar 200 and --only select-scalar. Outputs in select/.
. ~/buster-fast-bench/claude-141-takeover/common.sh
mkdir -p select
trees=("$@")
n=${#trees[@]}
for r in 1 2 3 4 5; do
    for i in $(seq 0 $((n - 1))); do
        t=${trees[$(( (r + i) % n ))]}
        "$lock" bash -c "taskset -c 2 $PWD/$t/build/compiler benchmark-tier1-select-source $FLAGS -I$Q $Q/sqlite3.c > select/both-$t-$r.txt 2>&1"
    done
done
for r in 1 2 3; do
    for mode in "select" "select-after" "select-scalar"; do
        case $mode in
            select) args="--only select";;
            select-after) args="--only select --after-scalar 200";;
            select-scalar) args="--only select-scalar";;
        esac
        for i in $(seq 0 $((n - 1))); do
            t=${trees[$(( (r + i) % n ))]}
            "$lock" bash -c "taskset -c 2 $PWD/$t/build/compiler benchmark-tier1-select-source $args $FLAGS -I$Q $Q/sqlite3.c > select/$mode-$t-$r.txt 2>&1"
        done
    done
done
echo done > select/done

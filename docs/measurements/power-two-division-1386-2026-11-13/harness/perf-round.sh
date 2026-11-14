#!/bin/bash
# One more alternation of compile-ab.sh's perf stat runs (round ROUND: main, then head), each a lock hold of its own.
# Usage: perf-round.sh MAIN HEAD CORPUS ROUND
set -e
dir=$(cd "$(dirname "$0")" && pwd)
main=$1
head=$2
corpus=$3
round=$4
unset CPATH C_INCLUDE_PATH
flags="--predefines $corpus/provenance/gnu17-pinned-predefines.txt --target=x86_64-linux-gnu -march=znver5 -std=gnu17 -nostdinc -isystem $corpus/headers/usr/lib/clang/23/include -isystem $corpus/headers/usr/local/include -isystem $corpus/headers/usr/include"
for side in main head; do
    compiler=$main
    [ $side = head ] && compiler=$head
    set +e
    "$dir/lock.sh" perf-$side-$round bash -c 'taskset -c 2 perf stat -r 11 -x, -e instructions:u,cycles:u,task-clock "$1" -c $2 -o /dev/null "$3" 2> "$4"' _ "$compiler" "$flags" "$corpus/sqlite/sqlite3.c" "$dir/compile/perf-$side-$round.csv"
    status=$?
    set -e
    echo "perf $side round $round exit $status"
    cat "$dir/compile/perf-$side-$round.csv"
done

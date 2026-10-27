#!/usr/bin/env bash
# One round of the A/B, run under one hold of the 9700X's lock: for each tree, in the order given, benchmark-backend
# (the full run, then the vector path alone) and perf stat of -c sqlite3.c, pinned to CPU 2. Usage: round.sh ROUND TREE...
set -u
cd "$(dirname "$0")"
round="$1"
shift
Q=~/buster-fast-bench/preprocessor-corpora-astra-01a158dd/sqlite
mkdir -p results-final objects-final
for tree in "$@"; do
    taskset -c 2 "./$tree/build/compiler" benchmark-backend > "results-final/backend-$tree-$round.txt" 2>&1
    taskset -c 2 "./$tree/build/compiler" benchmark-backend --only vector > "results-final/backend-vector-$tree-$round.txt" 2>&1
    taskset -c 2 perf stat -r 11 -x, -e instructions:u,cycles:u,task-clock "./$tree/build/compiler" -c -I"$Q" -o "objects-final/sqlite3-$tree.o" "$Q/sqlite3.c" \
        > "results-final/sqlite-$tree-$round.txt" 2>&1
done

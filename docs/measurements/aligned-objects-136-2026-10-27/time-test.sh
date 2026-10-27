#!/usr/bin/env bash
# One hold of the 9700X's lock: one test, by each tree in the order given, on CPUs 0 to 7 one at a time as the 9700X job
# runs its tests (BUSTER_PARALLEL_JOBS=1), from the tree's root, timed by the wall clock into tests-merged/times.txt
# (round, name, tree, exit status, seconds), its output into tests-merged/NAME-TREE-ROUND.log.
# Usage: time-test.sh ROUND NAME "TREE..." ARGUMENT...
set -u
cd "$(dirname "$0")"
round="$1"
name="$2"
trees="$3"
shift 3
mkdir -p tests-merged
for tree in $trees; do
    start=$(date +%s.%N)
    (cd "$tree" && taskset -c 0-7 env BUSTER_PARALLEL_JOBS=1 ./build/compiler "$@") > "tests-merged/$name-$tree-$round.log" 2>&1
    status=$?
    end=$(date +%s.%N)
    echo "$round $name $tree $status $(awk -v a="$start" -v b="$end" 'BEGIN { printf "%.2f", b - a }')" >> tests-merged/times.txt
done

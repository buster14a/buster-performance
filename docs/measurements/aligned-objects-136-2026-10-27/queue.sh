#!/usr/bin/env bash
# The A/B's queue: builds both trees (each build under the lock), then 8 rounds of round.sh, each under one hold of the
# lock, the trees' order alternating, then compares the trees' sqlite3.c objects. Run detached (setsid -f).
set -u
cd "$(dirname "$0")"
export EXCLUSIVE_OWNER=claude-aligned-136 EXCLUSIVE_TITLE="Objects aligned past 16 (#136): main vs head" EXCLUSIVE_LINK="https://github.com/buster14a/buster/issues/136"
lock=~/buster-fast-bench/exclusive.sh
for tree in main head; do
    (cd "$tree" && "$lock" env BUSTER_DEBUG_INFO=0 ./build.sh > build.log 2>&1) || { echo "build $tree failed" >> queue.log; exit 1; }
done
echo "built $(date -Is)" >> queue.log
for tree in main head; do
    nm -S --defined-only "$tree/build/compiler" | awk '{print $4, $2}' | sort > "functions-$tree.txt"
done
comm -3 functions-main.txt functions-head.txt > functions-diff.txt
for round in 1 2 3 4 5 6 7 8; do
    if [ $((round % 2)) -eq 1 ]; then order="main head"; else order="head main"; fi
    "$lock" ./round.sh "$round" $order
    echo "round $round ($order) $(date -Is)" >> queue.log
done
cmp objects/sqlite3-main.o objects/sqlite3-head.o >> queue.log 2>&1 && echo "sqlite3.o identical" >> queue.log
echo "done $(date -Is)" >> queue.log

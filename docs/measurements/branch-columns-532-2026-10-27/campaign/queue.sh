#!/usr/bin/env bash
# #532's campaign on the 9700X: each step takes the lock for itself (exclusive.sh), never around a series.
set -u
cd "$(dirname "$0")"
echo $$ > queue.pid
export EXCLUSIVE_OWNER=claude-532
export EXCLUSIVE_TITLE="#532: Tier 0's branch columns checked alone, x86_validate under --verify"
export EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/532
lock=~/buster-fast-bench/exclusive.sh
mkdir -p logs out
for tree in main head switch; do
    echo "== build $tree $(date -Is)"
    $lock bash -c "cd $tree && BUSTER_DEBUG_INFO=0 ./build.sh" > logs/build-$tree.log 2>&1
    echo "status $?"
done
for step in drive measure-a measure-b measure-c; do
    echo "== $step $(date -Is)"
    $lock ./$step.sh > logs/$step.log 2>&1
    echo "status $?"
done
echo "== done $(date -Is)"

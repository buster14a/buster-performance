#!/usr/bin/env bash
# #1395 / #2606 on the 9700X: each step is its own exclusive.sh hold, timed inside the hold, CPU 2 for timings.
set -u
root=$HOME/buster-fast-bench/1395-claude-2hegka
cd "$root"
echo $$ > queue.pid
mkdir -p logs
export TMPDIR=$root/tmp
export EXCLUSIVE_OWNER=claude-1395
export EXCLUSIVE_TITLE="Issue 1395: host-independent Tier 1 objects"
export EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/1395
X=$HOME/buster-fast-bench/exclusive.sh
step() { echo "== $(date -u +%FT%TZ) $*"; }
for tree in main-65ab5d8f head-1c734269; do
    step "build $tree"
    (cd "$tree" && "$X" env BUSTER_HOST_ARCH=znver5 BUSTER_DEBUG_INFO=0 ./build.sh > "../logs/build-$tree.log" 2>&1)
    echo "status $?"
done
for tree in main-65ab5d8f head-1c734269; do
    step "twins $tree"
    "$X" "$root/bench/twins-run.sh" "$tree" > "logs/twins-$tree.log" 2>&1
    echo "status $?"
done
for tree in main-65ab5d8f head-1c734269; do
    step "chains $tree"
    rm -rf "chains-$tree"; cp -r bench "chains-$tree"
    "$X" bash -c "uname -a; ./chains-$tree/run.sh $root/$tree/build/compiler" > "logs/chains-$tree.log" 2>&1
    echo "status $?"
done
for round in 1 2; do
    for tree in main-65ab5d8f head-1c734269; do
        step "frame benchmark $tree round $round"
        "$X" bash -c "taskset -c 2 $root/$tree/build/compiler benchmark-tier1-frame" > "logs/frame-$tree-$round.log" 2>&1
        echo "status $?"
    done
done
for tree in main-65ab5d8f head-1c734269; do
    step "frame tests $tree"
    "$X" bash -c "$root/$tree/build/compiler test-tier1-frame; $root/$tree/build/compiler test-tier1-frame-execution" > "logs/frame-tests-$tree.log" 2>&1
    echo "status $?"
done
step done

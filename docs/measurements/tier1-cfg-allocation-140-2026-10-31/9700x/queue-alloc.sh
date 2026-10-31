#!/usr/bin/env bash
# queue-alloc.sh MAIN HEAD: benchmark-tier1-allocation, main against head, on the 9700X: HEAD's build, then five rounds
# in alternating order, each round one hold of the shared lock. Logs in logs-alloc-HEAD/.
set -u
cd ~/buster-fast-bench/claude-140-cfg
main=$1
head=$2
logs=logs-alloc-$head
mkdir -p "$logs"
export EXCLUSIVE_OWNER=claude-140-cfg
export EXCLUSIVE_TITLE="Tier 1 CFG allocation #140: allocator A/B"
export EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/140
lock=~/buster-fast-bench/exclusive.sh
"$lock" bash -c "cd $head && BUSTER_DEBUG_INFO=0 ./build.sh > ../$logs/build.log 2>&1; echo \"exit \$?\" >> ../$logs/build.log"
for round in 1 2 3 4 5; do
    if [ $((round % 2)) -eq 1 ]; then order="$main $head"; else order="$head $main"; fi
    "$lock" bash -c "for tree in $order; do (cd \$tree && taskset -c 2 ./build/compiler benchmark-tier1-allocation > ../$logs/allocation-\$tree-$round.log 2>&1; echo \"exit \$?\" >> ../$logs/allocation-\$tree-$round.log); done"
done
echo done > "$logs/done"

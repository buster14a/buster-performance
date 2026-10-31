#!/usr/bin/env bash
# queue-b2.sh BASE HEAD: two more builds of each tree, alternating (BUSTER_DEBUG_INFO=0), each one hold of the shared
# lock, for build.sh's unit times.
set -u
cd ~/buster-fast-bench/claude-140-cfg || exit 1
base=$1
head=$2
logs=$PWD/logs-c-$head
export EXCLUSIVE_OWNER=claude-140-cfg
export EXCLUSIVE_TITLE="Tier 1 --tier1 #140: build times"
export EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/970
lock=~/buster-fast-bench/exclusive.sh
unset CPATH C_INCLUDE_PATH
for round in 2 3; do
    for t in $head $base; do
        "$lock" bash -c "cd $t && BUSTER_DEBUG_INFO=0 ./build.sh > $logs/build-$t-$round.log 2>&1; echo \"exit \$?\" >> $logs/build-$t-$round.log"
    done
done
echo done > $logs/builds-done

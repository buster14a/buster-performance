#!/usr/bin/env bash
# #531: builds main, the branch and both with #520's stage clock, each under the 9700X's lock, then one measurement hold.
set -u
cd "$(dirname "$0")"
echo $$ > run.pid
export EXCLUSIVE_OWNER=claude-531
export EXCLUSIVE_TITLE="#531 lowering cost: main against the branch"
export EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/531
lock=$HOME/buster-fast-bench/exclusive.sh
for t in ${TREES:-main v1 main520 v1-520}; do
    "$lock" bash -c "cd $t && BUSTER_DEBUG_INFO=0 ./build.sh" > "build-$t.log" 2>&1 || echo "build $t failed"
done
"$lock" ./measure.sh > measure.log 2>&1 || echo "measure failed"
echo done

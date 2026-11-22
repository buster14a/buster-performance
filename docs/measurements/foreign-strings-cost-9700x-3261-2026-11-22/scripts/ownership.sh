#!/bin/bash
# ownership.sh: the final tree's Develop build, then CI's "Check unity fixture ownership" block on it, each under the
# 9700X's lock alone (#3261).
D=~/buster-fast-bench/3044-claude
export EXCLUSIVE_OWNER=claude-3261 EXCLUSIVE_TITLE='PR sweep: #3261 foreign strings cost' EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/3261
cd $D/fix
~/buster-fast-bench/exclusive.sh ./build.sh > $D/results/fix-develop-build.log 2>&1
echo "develop build exit $?"
awk -v re='ownership' -f $D/blocks.awk tools/ci/correctness.tests > $D/results/ownership-block.txt
export PATH="$(bash tools/ci/session-toolchain.sh stage 2>/dev/null):$PATH"
BUSTER_COMPILER=$D/fix/build/compiler ~/buster-fast-bench/exclusive.sh ./build/compiler parallel --jobs 2 --timeout 600 < $D/results/ownership-block.txt > $D/results/ownership.log 2>&1
echo "ownership exit $?"
tail -3 $D/results/ownership.log

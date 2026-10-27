#!/bin/bash
# #592: build main and the head under the 9700X's lock, each in a hold of its own, then A/B them in one hold.
cd ~/buster-fast-bench/sparse-592-claude
echo $$ > run-final.pid
export EXCLUSIVE_OWNER=claude-592 EXCLUSIVE_TITLE="#592 sparse passes: final A/B against main" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/592
for tree in main2 head; do
    (cd "$tree" && BUSTER_DEBUG_INFO=0 ~/buster-fast-bench/exclusive.sh ./build.sh) > "build-$tree.log" 2>&1
    echo "build exit $?" >> "build-$tree.log"
done
PERF_ROUNDS=4 ~/buster-fast-bench/exclusive.sh ./ab.sh final 15 main2 head > ab-final.log 2>&1
echo "ab exit $?" >> ab-final.log
echo done > run-final.done

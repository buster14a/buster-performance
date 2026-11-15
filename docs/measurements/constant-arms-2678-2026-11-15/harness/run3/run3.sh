#!/bin/bash
# #2678's follow-up on the 9700X: main 1b6461b7's (with #2838) and head 947ff144's Release builds (no debug info), each
# a hold of its own; then the kernels' A/B (11 rounds), the compile A/B (CI's frozen corpus in this task's directory,
# 3 rounds) and the trees' manifests, each run a hold of its own (bench3/lock.sh).
B=~/buster-fast-bench/2678-claude
export EXCLUSIVE_OWNER=claude-2678 EXCLUSIVE_TITLE="Solve 2678 (integer arms only, out of line)" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2678
for tree in main-1b6461b7 head-947ff144; do
    cd $B/$tree && BUSTER_DEBUG_INFO=0 ~/buster-fast-bench/exclusive.sh timeout -k 5 900 ./build.sh --config Release > build.log 2>&1
    echo "$tree exit $? $(tail -2 build.log | head -1)"
    sha256sum $B/$tree/build/compiler
done > $B/bench3/builds.log 2>&1
main=$B/main-1b6461b7/build/compiler
head=$B/head-947ff144/build/compiler
cd $B/bench3
./ab.sh $main $head 11 > ab.txt 2>&1
echo "ab exit $?" >> ab.txt
./compile-ab.sh $main $head $B/corpus 3 > compile.txt 2>&1
echo "compile exit $?" >> compile.txt
./lock.sh manifests ./host-manifests.sh > manifests.txt 2>&1
echo "finished" >> compile.txt

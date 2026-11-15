#!/bin/bash
# #2678's second part on the 9700X: main's and head's Release builds (no debug info), each a hold of its own; then the
# kernels' A/B (11 rounds), the compile A/B (CI's frozen corpus in this task's directory, 3 rounds) and the trees'
# manifests, each run a hold of its own (bench2/lock.sh).
B=~/buster-fast-bench/2678-claude
export EXCLUSIVE_OWNER=claude-2678 EXCLUSIVE_TITLE="Solve 2678 (conditionals' constant arms)" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2678
for tree in main-d356f725 head-d68ae342; do
    cd $B/$tree && BUSTER_DEBUG_INFO=0 ~/buster-fast-bench/exclusive.sh timeout -k 5 900 ./build.sh --config Release > build.log 2>&1
    echo "$tree exit $? $(tail -2 build.log | head -1)"
    sha256sum $B/$tree/build/compiler
done > $B/bench2/builds.log 2>&1
main=$B/main-d356f725/build/compiler
head=$B/head-d68ae342/build/compiler
cd $B/bench2
./ab.sh $main $head 11 > ab.txt 2>&1
echo "ab exit $?" >> ab.txt
./compile-ab.sh $main $head $B/corpus 3 > compile.txt 2>&1
echo "compile exit $?" >> compile.txt
./lock.sh manifests ./host-manifests.sh > manifests.txt 2>&1
echo "finished" >> compile.txt

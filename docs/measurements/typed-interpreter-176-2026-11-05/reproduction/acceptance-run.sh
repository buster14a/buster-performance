#!/bin/bash
set -u
cd /home/david/buster-fast-bench/176-codex-01a1ac7e/tree || exit 1
export EXCLUSIVE_OWNER=codex-176 EXCLUSIVE_TITLE='Issue 176 complete acceptance' EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/1331
export BUSTER_COMPILER="$PWD/build/cmake/native-g0/Release/compiler"
export LD_LIBRARY_PATH=/home/david/buster-fast-bench/176-codex-01a1ac7e/tools/lib
while [ ! -f ../acceptance-build.status ]; do sleep 2; done
[ "$(cat ../acceptance-build.status)" = 0 ] || exit 1
~/buster-fast-bench/exclusive.sh "$BUSTER_COMPILER" parallel --jobs 4 < ../acceptance.tests > ../acceptance-tests.log 2>&1
echo "suites: $?" >> ../acceptance.status
~/buster-fast-bench/exclusive.sh env BUSTER_DEBUG_INFO=0 ./build.sh check-call-graph --jobs 8 > ../acceptance-call-graph.log 2>&1
echo "call graph: $?" >> ../acceptance.status
~/buster-fast-bench/exclusive.sh "$BUSTER_COMPILER" test-differential --buster "$BUSTER_COMPILER" --tier0-default --tier1-arg --tier1 --interpreter --csmith /home/david/buster-fast-bench/codex138-tools/bin/csmith --csmith-include /home/david/buster-fast-bench/codex138-tools/include --yarpgen /home/david/buster-fast-bench/codex138-tools/bin/yarpgen --clang /usr/bin/clang --generator both --seed 176 --count 2 --timeout-ms 120000 --revision 4813ca6fe55ec242e7f796a2e0094ed6c34c9f31 --generator-revision 'csmith-0cdc710315cfee9035e22ef4363ca479270d1934;yarpgen-1adb290f453505838f3aa33dc571f292b0c1810f' --output /home/david/buster-fast-bench/176-codex-01a1ac7e/differential > ../acceptance-differential.log 2>&1
echo "differential: $?" >> ../acceptance.status

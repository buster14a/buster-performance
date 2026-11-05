#!/bin/bash
set -u
cd /home/david/buster-fast-bench/176-codex-01a1ac7e/tree || exit 1
export EXCLUSIVE_OWNER=codex-176 EXCLUSIVE_TITLE='Issue 176 current-main acceptance' EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/1331
export LD_LIBRARY_PATH=/home/david/buster-fast-bench/176-codex-01a1ac7e/tools/lib
~/buster-fast-bench/exclusive.sh env BUSTER_DEBUG_INFO=0 ./build.sh > ../post-merge-build.log 2>&1
built=$?
echo "release build: $built" > ../post-merge-checks.status
[ "$built" = 0 ] || exit 1
export BUSTER_COMPILER="$PWD/build/cmake/native-g0/Release/compiler"
~/buster-fast-bench/exclusive.sh "$BUSTER_COMPILER" parallel --jobs 4 < ../acceptance.tests > ../post-merge-tests.log 2>&1
echo "release suites: $?" >> ../post-merge-checks.status
~/buster-fast-bench/exclusive.sh "$BUSTER_COMPILER" parallel --jobs 4 < ../final.tests > ../post-merge-weak-tests.log 2>&1
echo "release weak-symbol suites: $?" >> ../post-merge-checks.status
~/buster-fast-bench/exclusive.sh env BUSTER_DEBUG_INFO=0 ./build.sh check-call-graph --jobs 8 > ../post-merge-call-graph.log 2>&1
echo "call graph: $?" >> ../post-merge-checks.status
~/buster-fast-bench/exclusive.sh "$BUSTER_COMPILER" test-differential --buster "$BUSTER_COMPILER" --tier0-default --tier1-arg --tier1 --interpreter --csmith /home/david/buster-fast-bench/codex138-tools/bin/csmith --csmith-include /home/david/buster-fast-bench/codex138-tools/include --csmith-arg --max-funcs --csmith-arg 4 --csmith-arg --max-block-depth --csmith-arg 2 --csmith-arg --max-expr-complexity --csmith-arg 6 --yarpgen /home/david/buster-fast-bench/codex138-tools/bin/yarpgen --clang /usr/bin/clang --generator both --seed 176 --count 1 --timeout-ms 30000 --revision 3f2750451ed333940551ffe840e54993b4f5589a --generator-revision 'csmith-0cdc710315cfee9035e22ef4363ca479270d1934;yarpgen-1adb290f453505838f3aa33dc571f292b0c1810f' --output /home/david/buster-fast-bench/176-codex-01a1ac7e/differential > ../post-merge-differential.log 2>&1
echo "differential: $?" >> ../post-merge-checks.status
~/buster-fast-bench/exclusive.sh env BUSTER_DEBUG_INFO=0 BUSTER_SANITIZER=address BUSTER_SANITIZER_OPTIMIZATION=1 ./build.sh > ../post-merge-sanitizer-build.log 2>&1
built=$?
echo "sanitizer build: $built" >> ../post-merge-checks.status
[ "$built" = 0 ] || exit 1
export BUSTER_COMPILER="$PWD/build/cmake/native-address-O1/Release/compiler"
export ASAN_OPTIONS=detect_leaks=1:halt_on_error=1 UBSAN_OPTIONS=halt_on_error=1:print_stacktrace=1
~/buster-fast-bench/exclusive.sh "$BUSTER_COMPILER" parallel --jobs 4 < ../sanitizer.tests > ../post-merge-sanitizer-tests.log 2>&1
echo "sanitizer suites: $?" >> ../post-merge-checks.status
~/buster-fast-bench/exclusive.sh "$BUSTER_COMPILER" parallel --jobs 4 < ../final.tests > ../post-merge-weak-sanitizer-tests.log 2>&1
echo "sanitizer weak-symbol suites: $?" >> ../post-merge-checks.status
sha256sum build/cmake/native-g0/Release/compiler build/cmake/native-address-O1/Release/compiler > ../post-merge-binary-sha256.txt

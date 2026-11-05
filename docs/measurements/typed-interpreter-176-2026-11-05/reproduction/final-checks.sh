#!/bin/bash
set -u
cd /home/david/buster-fast-bench/176-codex-01a1ac7e/tree || exit 1
export EXCLUSIVE_OWNER=codex-176 EXCLUSIVE_TITLE='Issue 176 final weak-symbol regression' EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/1331
~/buster-fast-bench/exclusive.sh env BUSTER_DEBUG_INFO=0 ./build.sh > ../final-build.log 2>&1
built=$?
echo "release build: $built" > ../final-checks.status
[ "$built" = 0 ] || exit 1
export BUSTER_COMPILER="$PWD/build/cmake/native-g0/Release/compiler"
~/buster-fast-bench/exclusive.sh "$BUSTER_COMPILER" parallel --jobs 4 < ../final.tests > ../final-tests.log 2>&1
echo "release suites: $?" >> ../final-checks.status
~/buster-fast-bench/exclusive.sh env BUSTER_DEBUG_INFO=0 BUSTER_SANITIZER=address BUSTER_SANITIZER_OPTIMIZATION=1 ./build.sh > ../final-sanitizer-build.log 2>&1
built=$?
echo "sanitizer build: $built" >> ../final-checks.status
[ "$built" = 0 ] || exit 1
export BUSTER_COMPILER="$PWD/build/cmake/native-address-O1/Release/compiler"
export ASAN_OPTIONS=detect_leaks=1:halt_on_error=1 UBSAN_OPTIONS=halt_on_error=1:print_stacktrace=1
~/buster-fast-bench/exclusive.sh "$BUSTER_COMPILER" parallel --jobs 4 < ../final.tests > ../final-sanitizer-tests.log 2>&1
echo "sanitizer suites: $?" >> ../final-checks.status
sha256sum build/cmake/native-g0/Release/compiler build/cmake/native-address-O1/Release/compiler > ../final-binary-sha256.txt

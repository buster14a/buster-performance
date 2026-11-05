#!/bin/bash
set -u
cd /home/david/buster-fast-bench/176-codex-01a1ac7e/tree || exit 1
export EXCLUSIVE_OWNER=codex-176 EXCLUSIVE_TITLE='Issue 176 ignored x87 review fix qualification' EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/1331
~/buster-fast-bench/exclusive.sh env BUSTER_DEBUG_INFO=0 ./build.sh > ../review-fixed-build.log 2>&1
built=$?
echo "release build: $built" > ../review-fixed.status
[ "$built" = 0 ] || exit 1
export BUSTER_COMPILER="$PWD/build/cmake/native-g0/Release/compiler"
~/buster-fast-bench/exclusive.sh "$BUSTER_COMPILER" parallel --jobs 4 < ../review-checks.tests > ../review-fixed-tests.log 2>&1
tested=$?
echo "release suites: $tested" >> ../review-fixed.status
[ "$tested" = 0 ] || exit 1
~/buster-fast-bench/exclusive.sh env BUSTER_DEBUG_INFO=0 BUSTER_SANITIZER=address BUSTER_SANITIZER_OPTIMIZATION=1 ./build.sh > ../review-fixed-sanitizer-build.log 2>&1
built=$?
echo "sanitizer build: $built" >> ../review-fixed.status
[ "$built" = 0 ] || exit 1
export BUSTER_COMPILER="$PWD/build/cmake/native-address-O1/Release/compiler"
export ASAN_OPTIONS=detect_leaks=1:halt_on_error=1 UBSAN_OPTIONS=halt_on_error=1:print_stacktrace=1
~/buster-fast-bench/exclusive.sh "$BUSTER_COMPILER" parallel --jobs 4 < ../review-checks.tests > ../review-fixed-sanitizer-tests.log 2>&1
tested=$?
echo "sanitizer suites: $tested" >> ../review-fixed.status
sha256sum build/cmake/native-g0/Release/compiler build/cmake/native-address-O1/Release/compiler > ../review-fixed-binary-sha256.txt
exit "$tested"

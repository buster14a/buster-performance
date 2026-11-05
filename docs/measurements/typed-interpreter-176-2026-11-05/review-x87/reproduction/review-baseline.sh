#!/bin/bash
set -u
cd /home/david/buster-fast-bench/176-codex-01a1ac7e/tree || exit 1
export EXCLUSIVE_OWNER=codex-176 EXCLUSIVE_TITLE='Issue 176 ignored x87 review regression before fix' EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/1331
~/buster-fast-bench/exclusive.sh env BUSTER_DEBUG_INFO=0 ./build.sh > ../review-baseline-build.log 2>&1
built=$?
echo "build: $built" > ../review-baseline.status
[ "$built" = 0 ] || exit 1
~/buster-fast-bench/exclusive.sh ./build/cmake/native-g0/Release/compiler test-interpreter-native > ../review-baseline-test.log 2>&1
echo "native regression: $?" >> ../review-baseline.status

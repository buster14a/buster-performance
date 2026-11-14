#!/bin/bash
# Waits for both trees' builds, then measures #1382's kernels (5 rounds) and sqlite3.c's --tier1 -c (11 runs each).
cd "$(dirname "$0")"
base=~/buster-fast-bench/1382-claude
main=$base/main-b7a95eed
head=$base/head-d6d8d4bb
until grep -q "^build exit" $main/build.log 2>/dev/null && grep -q "^build exit" $head/build.log 2>/dev/null; do sleep 10; done
grep -q "^build exit 0" $main/build.log && grep -q "^build exit 0" $head/build.log || { echo "a build failed"; exit 1; }
./measure.sh $main $head 5 > measure.log 2>&1
./compile.sh $main $head 11 > compile.log 2>&1
echo all done

#!/bin/bash
# tests3.sh: after round 3, the checker's tests of head-647ff951 in one hold (parallel, 8 jobs).
set -u
cd ~/buster-fast-bench/claude-628 || exit 1
./build.sh head-647ff951
cd head-647ff951
[ -d build/c-testsuite/tests ] || { git init -q --template= build/c-testsuite && git -C build/c-testsuite fetch -q --depth 1 https://github.com/c-testsuite/c-testsuite 5c7275656d751de0e68b2d340a95b5681858ed07 && git -C build/c-testsuite checkout -q FETCH_HEAD; }
export EXCLUSIVE_OWNER=claude-628 EXCLUSIVE_TITLE="Problem 628 529" EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/1166
~/buster-fast-bench/exclusive.sh ./build/compiler parallel --jobs 8 --timeout 600 ../tests3.list > ../tests4.log 2>&1
echo "tests4 status $?" >> ../tests4.log

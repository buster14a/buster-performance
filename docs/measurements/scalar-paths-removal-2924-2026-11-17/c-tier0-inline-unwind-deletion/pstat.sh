#!/bin/bash
# Exact user instructions of test-tier0-inline on buster's main.c (87 spliced bodies) and of the fixture, base and head.
cd ~/buster-fast-bench/2924-c-df-claude/c8a || exit 1
export EXCLUSIVE_OWNER=claude-2924 EXCLUSIVE_TITLE="Scalar paths removed: C8a splice instructions" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2924
L=~/buster-fast-bench/exclusive.sh
for side in base head; do
    $L perf stat -x, -e instructions:u -r 3 taskset -c 2 compilers/$side test-tier0-inline -march=znver5 -Isrc-base/src -fwrapv -funsigned-char -fno-strict-aliasing src-base/src/buster/compiler/main.c > /dev/null 2> logs/prof/stat-main-$side.txt
    $L perf stat -x, -e instructions:u -r 3 taskset -c 2 compilers/$side -c --lanes 1 -march=znver5 -Isrc-base/src -fwrapv -funsigned-char -fno-strict-aliasing --tier0-no-inline src-base/src/buster/compiler/main.c -o /dev/shm/claude-c8a-ni.o > /dev/null 2> logs/prof/stat-noinline-$side.txt
done
rm -f /dev/shm/claude-c8a-ni.o
for f in logs/prof/stat-*.txt; do echo "$f: $(tail -1 $f)"; done

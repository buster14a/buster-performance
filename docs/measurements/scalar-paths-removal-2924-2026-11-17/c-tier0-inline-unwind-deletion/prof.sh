#!/bin/bash
# Instructions by symbol of -c --lanes 1 of buster's main.c, base and head (#2924 C8a), under the lock on CPU 2.
cd ~/buster-fast-bench/2924-c-df-claude/c8a || exit 1
export EXCLUSIVE_OWNER=claude-2924 EXCLUSIVE_TITLE="Scalar paths removed: C8a instructions by symbol" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2924
L=~/buster-fast-bench/exclusive.sh
mkdir -p logs/prof
for side in base head; do
    $L perf record -q -e instructions:u -c 20011 -o /dev/shm/claude-c8a-$side.data taskset -c 2 compilers/$side -c --lanes 1 -march=znver5 -Isrc-base/src -fwrapv -funsigned-char -fno-strict-aliasing src-base/src/buster/compiler/main.c -o /dev/shm/claude-c8a-$side.o > logs/prof/record-$side.log 2>&1
    perf report -q -i /dev/shm/claude-c8a-$side.data --sort symbol --stdio 2>/dev/null | head -60 > logs/prof/symbols-$side.txt
    rm -f /dev/shm/claude-c8a-$side.data /dev/shm/claude-c8a-$side.o
done
echo done > logs/prof/.done

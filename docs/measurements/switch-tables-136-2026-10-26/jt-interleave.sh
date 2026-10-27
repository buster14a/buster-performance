#!/bin/bash
# The jump tables' cost on the switched executable, interleaved in one hold of the lock (about 12 s), pinned to CPU 2,
# so that a drift of the machine's state between holds reaches both modes alike: eight rounds of sqlite3.c's -c, each
# round a perf stat -r 3 of each mode, the first of them alternating by round.
export EXCLUSIVE_OWNER=claude-switch-136 EXCLUSIVE_TITLE="Solve 133 136 137 145" EXCLUSIVE_LINK="https://github.com/buster14a/buster/issues/136"
unset CPATH C_INCLUDE_PATH
B=~/buster-fast-bench
D=$B/jump-136-toggle
$B/exclusive.sh bash -c '
    B=~/buster-fast-bench
    D=$B/jump-136-toggle
    Q=$B/preprocessor-corpora-astra-01a158dd/sqlite
    cd $D || exit 1
    for round in 1 2 3 4 5 6 7 8; do
        if [ $((round % 2)) = 1 ]; then order="off on"; else order="on off"; fi
        for mode in $order; do
            if [ $mode = off ]; then e="env BUSTER_NO_JUMP_TABLES=1"; else e="env -u BUSTER_NO_JUMP_TABLES"; fi
            taskset -c 2 $e perf stat -r 3 -x, -e instructions:u,cycles:u ./build/compiler -c -I$Q -o $D/interleave-$mode.o $Q/sqlite3.c 2> $D/interleave.tmp
            echo "$round $mode $(grep instructions:u $D/interleave.tmp | cut -d, -f1) $(grep cycles:u $D/interleave.tmp | cut -d, -f1)"
        done
    done
    rm -f $D/interleave.tmp
' 2>&1 | grep -v "^exclusive.sh\|^  title:\|^  link:\|^  pull request:" | grep -E "^[0-9]+ (on|off) [0-9]+ [0-9]+$|^done"
echo done

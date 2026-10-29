#!/bin/bash
# #764: thprace with --keep (every round's huge pages from the free lists, none the round before freed) on 1, 2, 4 and
# 8 threads, in one lock hold.
D=~/buster-fast-bench/claude-764
L="$D/logs/thprace.txt"
{
    sha256sum "$D/tools/thprace.c" "$D/tools/thprace"
    for cpus in 2 2,0 2,0,1,3 2,0,1,3,4,5,6,7; do
        echo "== $(date -Is) thprace --cpus $cpus --keep"
        "$D/tools/thprace" --cpus "$cpus" --rounds 64 --spin 3 --keep distinct same same-zero base-same base-same-zero
        echo "exit=$?"
    done
} >> "$L" 2>&1

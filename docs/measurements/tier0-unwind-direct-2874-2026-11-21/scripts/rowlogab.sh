#!/bin/bash
# Usage: rowlogab.sh BINARY TAG PAIRS: -c sqlite3.c with BUSTER_ROW_LOG on CPU 2, the descriptor from the frame (d) and
# from frame events (BUSTER_EXP_FRAME_EVENTS=1, e) in turn, ABBA, PAIRS of each; each run's object and stage clock kept.
set -u
D=~/buster-fast-bench/onecore-front-claude
C=$D/corpus
BIN=$1; TAG=$2; PAIRS=${3:-5}
FLAGS="--predefines $C/provenance/gnu17-pinned-predefines.txt -march=znver5 -std=gnu17 -nostdinc -isystem $C/headers/usr/lib/clang/23/include -isystem $C/headers/usr/local/include -isystem $C/headers/usr/include"
mkdir -p $D/results/$TAG
cd $D/results/$TAG
rm -f rowlog-*.tsv
ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | head -6 > busy-before.txt; cat /proc/loadavg >> busy-before.txt
run() {
    mode=$1; i=$2
    if [ $mode = e ]; then
        BUSTER_EXP_FRAME_EVENTS=1 BUSTER_ROW_LOG=$D/results/$TAG/rowlog-$mode-$i.tsv taskset -c 2 $BIN -c $FLAGS $C/sqlite/sqlite3.c -o $D/results/$TAG/sqlite3-$mode.o --time-stages 2> stages-$mode-$i.txt
    else
        BUSTER_ROW_LOG=$D/results/$TAG/rowlog-$mode-$i.tsv taskset -c 2 $BIN -c $FLAGS $C/sqlite/sqlite3.c -o $D/results/$TAG/sqlite3-$mode.o --time-stages 2> stages-$mode-$i.txt
    fi
    echo "run $mode $i exit $?"
}
for i in $(seq 1 $PAIRS); do
    if [ $((i % 2)) = 1 ]; then run d $i; run e $i; else run e $i; run d $i; fi
done
cmp sqlite3-d.o sqlite3-e.o && echo "objects d and e the same"
cmp sqlite3-d.o $D/results/main/sqlite3.o && echo "object the same as main's"
ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | head -6 > busy-after.txt; cat /proc/loadavg >> busy-after.txt

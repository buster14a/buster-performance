#!/bin/bash
# Usage: rowlog3.sh EXPERIMENT MAIN TAG ROUNDS: -c sqlite3.c with BUSTER_ROW_LOG on CPU 2: the experiment's descriptor from
# the frame (d), its frame events (BUSTER_EXP_FRAME_EVENTS=1, e) and main's row-log build (m), ROUNDS of each, the order
# turned each round; each run's object and stage clock kept.
set -u
D=~/buster-fast-bench/onecore-front-claude
C=$D/corpus
BIN=$1; MAIN=$2; TAG=$3; ROUNDS=${4:-5}
FLAGS="--predefines $C/provenance/gnu17-pinned-predefines.txt -march=znver5 -std=gnu17 -nostdinc -isystem $C/headers/usr/lib/clang/23/include -isystem $C/headers/usr/local/include -isystem $C/headers/usr/include"
mkdir -p $D/results/$TAG
cd $D/results/$TAG
rm -f rowlog-*.tsv
ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | head -6 > busy-before.txt; cat /proc/loadavg >> busy-before.txt
run() {
    mode=$1; i=$2
    case $mode in
        d) BUSTER_ROW_LOG=$D/results/$TAG/rowlog-d-$i.tsv taskset -c 2 $BIN -c $FLAGS $C/sqlite/sqlite3.c -o sqlite3-d.o --time-stages 2> stages-d-$i.txt ;;
        e) BUSTER_EXP_FRAME_EVENTS=1 BUSTER_ROW_LOG=$D/results/$TAG/rowlog-e-$i.tsv taskset -c 2 $BIN -c $FLAGS $C/sqlite/sqlite3.c -o sqlite3-e.o --time-stages 2> stages-e-$i.txt ;;
        m) BUSTER_ROW_LOG=$D/results/$TAG/rowlog-m-$i.tsv taskset -c 2 $MAIN -c $FLAGS $C/sqlite/sqlite3.c -o sqlite3-m.o --time-stages 2> stages-m-$i.txt ;;
    esac
    echo "run $mode $i exit $?"
}
for i in $(seq 1 $ROUNDS); do
    case $((i % 3)) in
        1) order="d e m" ;;
        2) order="m d e" ;;
        0) order="e m d" ;;
    esac
    for mode in $order; do run $mode $i; done
done
cmp sqlite3-d.o sqlite3-e.o && echo "objects d and e the same"
cmp sqlite3-d.o sqlite3-m.o && echo "objects d and m the same"
cmp sqlite3-d.o $D/results/main/sqlite3.o && echo "object the same as main's"
ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | head -6 > busy-after.txt; cat /proc/loadavg >> busy-after.txt

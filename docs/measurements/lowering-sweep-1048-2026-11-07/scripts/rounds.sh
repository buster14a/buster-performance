#!/bin/bash
# #1048 statement sweep: interleaved rounds of sqlite3.c's -c with --time-stages, three variants of one build:
# the tasks (BUSTER_NO_SWEEP_EXPERIMENT), the sweep, and the sweep's walk without its rules ahead of the tasks
# (BUSTER_SWEEP_SKELETON, which discards the walk and lets the tasks lower every statement).
set -u
B=./build/compiler
S=$HOME/buster-fast-bench/1048-opencode/inputs/sqlite-amalgamation-3530400
O="-DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -I$S $S/sqlite3.c"
for round in 1 2 3 4 5 6 7; do
  for v in tasks sweep walk; do
    unset BUSTER_NO_SWEEP_EXPERIMENT BUSTER_SWEEP_SKELETON
    [ $v = tasks ] && export BUSTER_NO_SWEEP_EXPERIMENT=1
    [ $v = walk ] && export BUSTER_SWEEP_SKELETON=1
    out=$(taskset -c 2 $B -c $O -o /tmp/1048-opencode.o --time-stages 2>&1)
    st=$(echo "$out" | awk -F'\t' '$2=="lower.statements" {print $3}')
    lo=$(echo "$out" | awk -F'\t' '$2=="lower" {print $3}')
    t0=$(echo "$out" | awk -F'\t' '$2=="tier0" {print $3}')
    sw=$(echo "$out" | grep -o 'swept=[0-9]*' | head -1)
    echo "round=$round variant=$v lower=$lo statements=$st tier0=$t0 $sw"
  done
done

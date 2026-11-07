#!/bin/bash
# Synth's peak by 8 lanes: main's with and without the board (BUSTER_TEST_NO_UNITS_BOARD, the test hook that stands for
# its allocation failing), #763's, and one synth unit's -c alone by each tree; one time-runs, CPUs 0 to 7.
# Usage: peaks.sh TREE BASE
. $(dirname $0)/common.sh
TREE=${1:?tree}
BASE=${2:?base tree}
H=$W/$TREE/build/compiler
B=$W/$BASE/build/compiler
d=$W/peaks-$TREE
rm -rf $d && mkdir -p $d/1 $d/2 $d/3 $d/4 $d/5 && cd $d
P="taskset -c 0-7"
src=$HOME/buster-fast-bench/units-152-claude/explore/synth
files=$(ls $src/unit_*.c | tr '\n' ' ')
echo "lists: 1 synth --lanes 8 by $TREE; 2 the same without the board; 3 synth --lanes 8 by $BASE; 4 -c of unit_0.c by $TREE; 5 by $BASE"
lists=()
lists+=(--list -c "cd $d/1 && $P $H --lanes 8 -o synth $files")
lists+=(--list -c "cd $d/2 && BUSTER_TEST_NO_UNITS_BOARD=1 $P $H --lanes 8 -o synth $files")
lists+=(--list -c "cd $d/3 && $P $B --lanes 8 -o synth $files")
lists+=(--list -c "cd $d/4 && rm -f unit_0.o && $P $H -c $src/unit_0.c && test -s unit_0.o")
lists+=(--list -c "cd $d/5 && rm -f unit_0.o && $P $B -c $src/unit_0.c && test -s unit_0.o")
lock $H time-runs --executable /bin/sh --runs ${RUNS:-7} "${lists[@]}" > runs.log 2>&1
statuses runs.log; results < runs.log
for x in 1 2 3; do ./$x/synth | tail -1; done
cmp 1/synth 2/synth && echo "with and without the board: the same executable"
echo peaks-finished

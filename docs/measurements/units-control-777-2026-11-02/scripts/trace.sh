#!/bin/bash
# #777's attribution: the trace build's per-unit and per-lane times of the one command, by default lanes.
set -u
W=$HOME/buster-fast-bench/777-claude
TREE=${1:?tree}
T=$W/$TREE
export TMPDIR=$W/tmp
lock() { EXCLUSIVE_OWNER=claude-777 EXCLUSIVE_TITLE="solve 777" EXCLUSIVE_LINK="https://github.com/buster14a/buster/issues/777" ~/buster-fast-bench/exclusive.sh "$@"; }
echo "tree $TREE commit $(cat $T/COMMIT)"
if [ ! -x $T/build/compiler ]; then
    (cd $T && BUSTER_DEBUG_INFO=0 lock ./build.sh 2>&1 | tail -2)
fi
C=$T/build/compiler
[ -x $C ] || { echo "the build of $TREE failed"; exit 1; }
sha256sum $C
S=$HOME/buster-fast-bench/claude-linker-80/inputs/sqlite-amalgamation-3530400
OUT=$W/trace-$TREE
rm -rf $OUT && mkdir -p $OUT
cd $OUT
lock bash -c "for i in 1 2 3 4 5 6 7; do rm -f *.o; BUSTER_777_TRACE=1 taskset -c 0-7 $C --time-stages -c $S/sqlite3.c $S/shell.c 2> one-\$i.txt; echo one \$?; done"
for i in 1 2 3 4 5 6 7; do echo "-- one $i"; grep -E '^trace777' one-$i.txt | tr '\t' ' '; grep -E '^time-stage (setup|lanes|release|total) ' <(tr '\t' ' ' < one-$i.txt); done
echo trace-finished

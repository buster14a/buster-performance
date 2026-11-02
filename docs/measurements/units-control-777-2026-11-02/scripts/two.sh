#!/bin/bash
# #777's attribution: --time-stages of each of the two units' processes run at once (main's build), against the one
# command's per-unit stages (trace.sh): how much each unit's stages grow beside the other in two processes.
set -u
W=$HOME/buster-fast-bench/777-claude
TREE=${1:?tree}
C=$W/$TREE/build/compiler
export TMPDIR=$W/tmp
lock() { EXCLUSIVE_OWNER=claude-777 EXCLUSIVE_TITLE="solve 777" EXCLUSIVE_LINK="https://github.com/buster14a/buster/issues/777" ~/buster-fast-bench/exclusive.sh "$@"; }
echo "tree $TREE commit $(cat $W/$TREE/COMMIT)"
sha256sum $C
S=$HOME/buster-fast-bench/claude-linker-80/inputs/sqlite-amalgamation-3530400
OUT=$W/two-$TREE
rm -rf $OUT && mkdir -p $OUT
cd $OUT
lock bash -c "for i in 1 2 3 4 5 6 7; do rm -f *.o; taskset -c 0-7 $C --time-stages -c $S/sqlite3.c 2> sqlite-\$i.txt & a=\$!; taskset -c 0-7 $C --time-stages -c $S/shell.c 2> shell-\$i.txt & b=\$!; wait \$a; sa=\$?; wait \$b; sb=\$?; echo two \$i \$sa \$sb; test -s sqlite3.o && test -s shell.o && echo fresh; done"
for i in 1 2 3 4 5 6 7; do for u in sqlite shell; do echo "-- $u $i"; tr '\t' ' ' < $u-$i.txt | grep -E '^time-stage (setup|preprocess|parse|check-input|check-expressions|check-declarations|check-program|select|lower|emit-setup|lanes|code-atoms|release|total) '; done; done
echo two-finished

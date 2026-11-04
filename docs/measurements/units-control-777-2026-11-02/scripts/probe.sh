#!/bin/bash
# #777's attribution on the 9700X: perf stat of the one command and of the two processes at once (each child's status
# checked, outputs removed before and required after), and --time-stages of the one command and of each unit alone.
set -u
W=$HOME/buster-fast-bench/777-claude
TREE=${1:?tree}
RUNS=${2:-11}
T=$W/$TREE
export TMPDIR=$W/tmp
lock() { EXCLUSIVE_OWNER=claude-777 EXCLUSIVE_TITLE="solve 777" EXCLUSIVE_LINK="https://github.com/buster14a/buster/issues/777" ~/buster-fast-bench/exclusive.sh "$@"; }
C=$T/build/compiler
[ -x $C ] || { echo "no compiler in $TREE"; exit 1; }
echo "tree $TREE commit $(cat $T/COMMIT)"
sha256sum $C
S=$HOME/buster-fast-bench/claude-linker-80/inputs/sqlite-amalgamation-3530400
OUT=$W/probe-$TREE
rm -rf $OUT && mkdir -p $OUT/one $OUT/two $OUT/alone
cd $OUT
cat > one.sh <<E2
cd $OUT/one && rm -f sqlite3.o shell.o && taskset -c 0-7 $C -c $S/sqlite3.c $S/shell.c && test -s sqlite3.o && test -s shell.o
E2
cat > two.sh <<E2
cd $OUT/two && rm -f sqlite3.o shell.o && { taskset -c 0-7 $C -c $S/sqlite3.c & a=\$!; taskset -c 0-7 $C -c $S/shell.c & b=\$!; wait \$a; sa=\$?; wait \$b; sb=\$?; test \$sa = 0 && test \$sb = 0; } && test -s sqlite3.o && test -s shell.o
E2
ev=task-clock,cycles:u,instructions:u,cycles:k,instructions:k,context-switches,cpu-migrations,page-faults
for arm in one two one two; do
    lock bash -c "perf stat -x, -e $ev -r $RUNS /bin/sh $OUT/$arm.sh 2> $OUT/perf-$arm.txt; echo $arm status \$?"
    sed 's/^/  /' $OUT/perf-$arm.txt
done
echo "== --time-stages: the one command, sqlite3.c alone, shell.c alone"
lock bash -c "cd $OUT/one; for i in 1 2 3 4 5; do rm -f *.o; taskset -c 0-7 $C --time-stages -c $S/sqlite3.c $S/shell.c 2> stages-one-\$i.txt; echo one \$?; cd ../alone; rm -f *.o; taskset -c 0-7 $C --time-stages -c $S/sqlite3.c 2> stages-sqlite-\$i.txt; echo sqlite \$?; rm -f *.o; taskset -c 0-7 $C --time-stages -c $S/shell.c 2> stages-shell-\$i.txt; echo shell \$?; cd ../one; done"
for f in one/stages-one-*.txt alone/stages-sqlite-*.txt alone/stages-shell-*.txt; do echo "-- $f"; grep -E '^time-stage' $f | awk '$3 > 0.5' | tr '\t' ' '; done
echo probe-finished

#!/bin/bash
# #777's verified control on the 9700X: SQLite 3.53.4's sqlite3.c and shell.c as one command against the two units'
# processes at once, with -c and linked, each process's exit status checked and every output removed before each run
# and required after it. Every build and measurement holds the host's lock for itself.
set -u
W=$HOME/buster-fast-bench/777-claude
TREE=${1:?tree}
RUNS=${2:-21}
T=$W/$TREE
export TMPDIR=$W/tmp
mkdir -p $TMPDIR
lock() { EXCLUSIVE_OWNER=claude-777 EXCLUSIVE_TITLE="solve 777" EXCLUSIVE_LINK="https://github.com/buster14a/buster/issues/777" ~/buster-fast-bench/exclusive.sh "$@"; }
echo "== receipts"
uname -a; clang --version | head -1; perf --version
for c in 0 1 2 3 4 5 6 7; do echo "cpu$c $(cat /sys/devices/system/cpu/cpu$c/cpufreq/scaling_governor) $(cat /sys/devices/system/cpu/cpu$c/cpufreq/energy_performance_preference)"; done
echo "tree $TREE commit $(cat $T/COMMIT)"
if [ ! -x $T/build/compiler ]; then
    (cd $T && BUSTER_DEBUG_INFO=0 lock ./build.sh 2>&1 | tail -2)
fi
[ -x $T/build/compiler ] || { echo "the build of $TREE failed"; exit 1; }
C=$T/build/compiler
sha256sum $C
S=$HOME/buster-fast-bench/claude-linker-80/inputs/sqlite-amalgamation-3530400
sha256sum $S/sqlite3.c $S/shell.c
OUT=$W/ctl-$TREE
rm -rf $OUT && mkdir -p $OUT/ref/one $OUT/ref/two $OUT/one $OUT/two $OUT/alone $OUT/link1 $OUT/link2
cd $OUT
echo "== outputs, outside the timing"
lock bash -c "cd ref/one && taskset -c 0-7 $C -c --shared-parts $S/sqlite3.c $S/shell.c 2>&1 | tail -2; echo one-c status \$?; cd ../two && taskset -c 0-7 $C -c $S/sqlite3.c; echo sqlite3 status \$?; taskset -c 0-7 $C -c $S/shell.c; echo shell status \$?"
cmp ref/one/sqlite3.o ref/two/sqlite3.o && cmp ref/one/shell.o ref/two/shell.o && echo "one command's objects: each its unit's alone"
echo "lists: 1 -c of both, one command; 2 -c of each, two processes at once; 3 -c of sqlite3.c alone; 4 -c of shell.c alone;"
echo "       5 linked, one command; 6 -c of each at once, then cc's link"
both="test \$sa = 0 && test \$sb = 0"
lists=()
lists+=(--list -c "cd $OUT/one && rm -f sqlite3.o shell.o && taskset -c 0-7 $C -c $S/sqlite3.c $S/shell.c && test -s sqlite3.o && test -s shell.o")
lists+=(--list -c "cd $OUT/two && rm -f sqlite3.o shell.o && { taskset -c 0-7 $C -c $S/sqlite3.c & a=\$!; taskset -c 0-7 $C -c $S/shell.c & b=\$!; wait \$a; sa=\$?; wait \$b; sb=\$?; $both; } && test -s sqlite3.o && test -s shell.o")
lists+=(--list -c "cd $OUT/alone && rm -f sqlite3.o && taskset -c 0-7 $C -c $S/sqlite3.c && test -s sqlite3.o")
lists+=(--list -c "cd $OUT/alone && rm -f shell.o && taskset -c 0-7 $C -c $S/shell.c && test -s shell.o")
lists+=(--list -c "cd $OUT/link1 && rm -f sq && taskset -c 0-7 $C -o sq $S/sqlite3.c $S/shell.c -lm && test -x sq")
lists+=(--list -c "cd $OUT/link2 && rm -f sqlite3.o shell.o sq && { taskset -c 0-7 $C -c $S/sqlite3.c & a=\$!; taskset -c 0-7 $C -c $S/shell.c & b=\$!; wait \$a; sa=\$?; wait \$b; sb=\$?; $both; } && taskset -c 0-7 cc -o sq sqlite3.o shell.o -lm && test -x sq")
lock $C time-runs --executable /bin/sh --runs $RUNS "${lists[@]}" > runs.log 2>&1
echo "time-runs status $?"
grep -c 'status 0$' runs.log
grep -E 'FAILED|status [1-9]' runs.log | head
sed -n '/^list [0-9]* \[/p; /^time-runs:/p' runs.log
echo "== outputs after the runs"
for d in one two; do cmp $d/sqlite3.o ref/two/sqlite3.o && cmp $d/shell.o ref/two/shell.o && echo "$d: the reference objects"; done
cmp alone/sqlite3.o ref/two/sqlite3.o && cmp alone/shell.o ref/two/shell.o && echo "alone: the reference objects"
cmp link2/sqlite3.o ref/two/sqlite3.o && cmp link2/shell.o ref/two/shell.o && echo "link2: the reference objects"
echo "select 6 * 7;" | ./link1/sq; echo "select 6 * 7;" | ./link2/sq
echo ctl-finished

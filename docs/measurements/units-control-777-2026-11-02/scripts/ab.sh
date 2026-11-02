#!/bin/bash
# #777's A/B on the 9700X: the one command (-c and linked) by each tree, against the two units' processes at once by
# the first tree (each child's status checked, outputs removed before each run and required after it), interleaved
# (time-runs), CPUs 0 to 7.
set -u
W=$HOME/buster-fast-bench/777-claude
NAME=${1:?name}
RUNS=${2:?runs}
shift 2
export TMPDIR=$W/tmp
lock() { EXCLUSIVE_OWNER=claude-777 EXCLUSIVE_TITLE="solve 777" EXCLUSIVE_LINK="https://github.com/buster14a/buster/issues/777" ~/buster-fast-bench/exclusive.sh "$@"; }
S=$HOME/buster-fast-bench/claude-linker-80/inputs/sqlite-amalgamation-3530400
OUT=$W/ab-$NAME
rm -rf $OUT && mkdir -p $OUT/ref
for TREE in "$@"; do
    T=$W/$TREE
    if [ ! -x $T/build/compiler ]; then
        (cd $T && BUSTER_DEBUG_INFO=0 lock ./build.sh 2>&1 | tail -2)
    fi
    [ -x $T/build/compiler ] || { echo "the build of $TREE failed"; exit 1; }
    echo "tree $TREE commit $(cat $T/COMMIT)"
    sha256sum $T/build/compiler
done
FIRST=$W/$1/build/compiler
cd $OUT
lock bash -c "cd ref && taskset -c 0-7 $FIRST -c $S/sqlite3.c; echo sqlite3 status \$?; taskset -c 0-7 $FIRST -c $S/shell.c; echo shell status \$?"
lists=()
n=0
legend=""
for TREE in "$@"; do
    C=$W/$TREE/build/compiler
    n=$((n + 1)); mkdir -p c$n; legend="$legend $n: -c one command by $TREE;"
    lists+=(--list -c "cd $OUT/c$n && rm -f sqlite3.o shell.o && taskset -c 0-7 $C -c $S/sqlite3.c $S/shell.c && test -s sqlite3.o && test -s shell.o")
done
n=$((n + 1)); mkdir -p c$n; legend="$legend $n: -c two processes by $1;"
lists+=(--list -c "cd $OUT/c$n && rm -f sqlite3.o shell.o && { taskset -c 0-7 $FIRST -c $S/sqlite3.c & a=\$!; taskset -c 0-7 $FIRST -c $S/shell.c & b=\$!; wait \$a; sa=\$?; wait \$b; sb=\$?; test \$sa = 0 && test \$sb = 0; } && test -s sqlite3.o && test -s shell.o")
for TREE in "$@"; do
    C=$W/$TREE/build/compiler
    n=$((n + 1)); mkdir -p c$n; legend="$legend $n: linked one command by $TREE;"
    lists+=(--list -c "cd $OUT/c$n && rm -f sq && taskset -c 0-7 $C -o sq $S/sqlite3.c $S/shell.c -lm && test -x sq")
done
n=$((n + 1)); mkdir -p c$n; legend="$legend $n: two processes by $1, then cc's link"
lists+=(--list -c "cd $OUT/c$n && rm -f sqlite3.o shell.o sq && { taskset -c 0-7 $FIRST -c $S/sqlite3.c & a=\$!; taskset -c 0-7 $FIRST -c $S/shell.c & b=\$!; wait \$a; sa=\$?; wait \$b; sb=\$?; test \$sa = 0 && test \$sb = 0; } && taskset -c 0-7 cc -o sq sqlite3.o shell.o -lm && test -x sq")
echo "lists:$legend"
lock $FIRST time-runs --executable /bin/sh --runs $RUNS "${lists[@]}" > runs.log 2>&1
echo "time-runs status $?"
echo "runs with status 0: $(grep -c 'status 0$' runs.log)"
grep -E 'FAILED|status [1-9]' runs.log | head
sed -n '/^list [0-9]* \[/p; /^time-runs:/p' runs.log
for d in c*; do for o in sqlite3.o shell.o; do [ -f $d/$o ] && { cmp $d/$o ref/$o && echo "$d/$o: the reference"; }; done; [ -x $d/sq ] && echo "$d/sq: $(echo 'select 6 * 7;' | ./$d/sq)"; done
echo ab-finished

#!/bin/bash
# #147's transparent unions PR, its review's fix (head 86467e46), against its main parent 2ae4fa82 over the checker
# unit's placements and fresh copies (#509's method): -c of the frozen sqlite3.c, pinned to CPU 2, ab taking the lock
# for each time-runs process; main's executables again as an A/A control. It waits for the #840 campaign (../pr4's
# shifts6.sh) to end first. Before the rounds a drive check (both trees' objects) and each tree's instructions for
# -fsyntax-only and -c, three runs each, the trees in turn.
echo $$ > ~/buster-fast-bench/solve147-claude/pr3c/shifts3c.pid
export EXCLUSIVE_OWNER=claude-solve-147 EXCLUSIVE_TITLE="solve 147 (transparent unions)" EXCLUSIVE_LINK="https://github.com/buster14a/buster/pull/801"
unset CPATH C_INCLUDE_PATH
B=~/buster-fast-bench
D=$B/solve147-claude/pr3c
Q=$B/preprocessor-corpora-astra-01a158dd/sqlite
while kill -0 $(cat $B/solve147-claude/pr4/shifts6.pid) 2>/dev/null; do sleep 30; done
echo "started after shifts6"
shifts="0 704 1408 2112 2816 3520"
base=base-2ae4fa82
head=head-86467e46
for tree in $base $head; do
    (cd $D/$tree && BUSTER_DEBUG_INFO=0 $B/exclusive.sh ./build.sh shifts $D/shifts/$tree main_unit_checker.c $shifts > $D/shifts-$tree.log 2>&1) || { echo "shifts $tree failed"; exit 1; }
    echo "shifted $tree"
done
for tree in $base $head; do
    $B/exclusive.sh taskset -c 2 $D/shifts/$tree/compiler-0 -c -I$Q -o $D/drive-$tree.o $Q/sqlite3.c > $D/drive-$tree.log 2>&1
    echo "drive $tree status $?"
done
cmp $D/drive-$base.o $D/drive-$head.o && echo "objects identical"
for run in 1 2 3; do
    for tree in $base $head; do
        $B/exclusive.sh taskset -c 2 perf stat -x, -e instructions:u -o $D/perf-syntax-$tree-$run.txt $D/shifts/$tree/compiler-0 -fsyntax-only -I$Q $Q/sqlite3.c
        $B/exclusive.sh taskset -c 2 perf stat -x, -e instructions:u -o $D/perf-c-$tree-$run.txt $D/shifts/$tree/compiler-0 -c -I$Q -o $D/perf-out.o $Q/sqlite3.c
    done
done
echo "counted"
builds=()
for b in base:$base head:$head base-again:$base; do
    for s in $shifts; do builds+=(--build "${b%%:*}" "$D/shifts/${b#*:}/compiler-$s"); done
done
mkdir -p $D/copies
$D/$head/build/compiler ab --rounds 3 --cpu 2 --lock $B/exclusive.sh $D/$head/build/compiler \
    -- time-runs --runs 3 --copies 3 --directory $D/copies "${builds[@]}" --list -c -I$Q -o $D/shifts-out.o $Q/sqlite3.c > $D/shifts-ab.log 2>&1
echo "ab status $?"
grep -E "^  (head|base-again): " $D/shifts-ab.log
echo done

#!/bin/bash
# #152's second round on the 9700X, for the head with the arenas' pool (ae5fb51e, tree-pool): its build, the units'
# tests and the call graph check; the scaling (measure2.sh); the stages (--time-stages); and the one-file perf stat A/B
# against main (9bb5060e, tree-main2) with an A/A copy of main's executable. Each step is one hold of the lock.
set -u
W=$HOME/buster-fast-bench/units-152-claude
echo $$ > $W/final2.pid
E=$W/exp
export TMPDIR=$W/tmp
lock() { EXCLUSIVE_OWNER=claude-152 EXCLUSIVE_TITLE="solve #152 multi-file driver (pooled head)" EXCLUSIVE_LINK="https://github.com/buster14a/buster/issues/152" ~/buster-fast-bench/exclusive.sh "$@"; }
(cd $E/tree-pool && rm -rf build && BUSTER_DEBUG_INFO=0 lock ./build.sh 2>&1 | tail -1)
H=$E/tree-pool/build/compiler
M=$E/tree-main2/build/compiler
sha256sum $H $M
echo "== tests"
cd $E/tree-pool && lock bash -c "set -o pipefail; timeout 400 ./build/compiler test-check-units 2>&1 | tail -6; echo status=\$?; timeout 300 ./build/compiler test-check-units --corpus $W/inputs/c-testsuite/tests/single-exec 2>&1 | tail -3; echo status=\$?; ./build.sh check-call-graph 2>&1 | tail -1; echo status=\$?"
RUNS=5 $W/measure2.sh $H $W/final3 lua synth musl
echo "== stages"
mkdir -p $W/final3/stages && cd $W/final3/stages
lock bash -c "set -o pipefail; for r in 1 2 3; do for lanes in 8 1; do echo \"synth link, --lanes \$lanes, run \$r\"; taskset -c 0-7 $H --time-stages --lanes \$lanes -o synth $W/explore/synth/unit_*.c 2>&1 | grep -E '^time-stage|^time-process'; echo status=\$?; done; done"
echo "== one file: perf stat"
D=$W/final3/ab && mkdir -p $D && cd $D && cp $M $D/main-copy
SQ=$HOME/buster-fast-bench/refine-claude/inputs/sqlite3.c
CT=$W/inputs/c-testsuite/tests/single-exec/00220.c
sha256sum $D/main-copy
names=(main copy head)
paths=($M $D/main-copy $H)
one() {
    local name=$1 path=$2 what=$3
    shift 3
    taskset -c 2 perf stat -x, -e instructions:u,cycles:u,task-clock -r 11 -o $D/perf-$what-$name-r$round.csv "$path" "$@" > /dev/null 2> $D/stderr-$what-$name.txt
    echo "$what $name round $round status=$?"
}
export -f one; export D
for round in 1 2 3; do
    export round
    script=""
    for k in 0 1 2; do
        i=$(( (round - 1 + k) % 3 ))
        script+="one ${names[$i]} ${paths[$i]} c -c -o $D/out-${names[$i]}.o $SQ; "
        script+="one ${names[$i]} ${paths[$i]} syntax -fsyntax-only $SQ; "
        script+="one ${names[$i]} ${paths[$i]} exe -o $D/exe-${names[$i]} $CT; "
    done
    lock bash -c "$script"
done
cmp out-main.o out-head.o && echo "objects: main's and the head's -c of sqlite3.c the same bytes"
for f in perf-*.csv; do echo "$f: $(grep -v '^#' $f | grep -v '^$' | cut -d, -f1,3 | tr '\n' ' ')"; done
echo final2-finished

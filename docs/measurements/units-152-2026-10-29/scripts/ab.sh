#!/bin/bash
# #152's one-file A/B: main (9bb5060e), an A/A copy of main's executable, and the PR's code head (64984fac), by
# perf stat -r 11 on CPU 2, in three rounds of a rotating order; each round one hold of the lock.
set -u
W=$HOME/buster-fast-bench/units-152-claude
E=$W/exp
D=$W/final/ab
mkdir -p $D && cd $D
cp $E/tree-main2/build/compiler $D/main-copy
lock() { EXCLUSIVE_OWNER=claude-152 EXCLUSIVE_TITLE="solve #152 multi-file driver (one-file A/B)" EXCLUSIVE_LINK="https://github.com/buster14a/buster/issues/152" ~/buster-fast-bench/exclusive.sh "$@"; }
SQ=$HOME/buster-fast-bench/refine-claude/inputs/sqlite3.c
CT=$W/inputs/c-testsuite/tests/single-exec/00220.c
sha256sum $E/tree-main2/build/compiler $D/main-copy $E/tree-head/build/compiler
names=(main copy head)
paths=($E/tree-main2/build/compiler $D/main-copy $E/tree-head/build/compiler)
one() {
    local name=$1 path=$2 what=$3
    shift 3
    taskset -c 2 perf stat -x, -e instructions:u,cycles:u,task-clock -r 11 -o $D/perf-$what-$name-r$round.csv "$path" "$@" > /dev/null 2> $D/stderr-$what-$name.txt
    echo "$what $name round $round status=$?"
}
for round in 1 2 3; do
    export round
    order=$(( (round - 1) % 3 ))
    script=""
    for k in 0 1 2; do
        i=$(( (order + k) % 3 ))
        script+="one ${names[$i]} ${paths[$i]} c -c -o $D/out-${names[$i]}.o $SQ; "
        script+="one ${names[$i]} ${paths[$i]} syntax -fsyntax-only $SQ; "
        script+="one ${names[$i]} ${paths[$i]} exe -o $D/exe-${names[$i]} $CT; "
    done
    export -f one; export D
    lock bash -c "$script"
done
cmp out-main.o out-head.o && echo "objects: main's and the head's -c of sqlite3.c the same bytes"
for f in perf-*.csv; do echo "$f: $(grep -v '^#' $f | grep -v '^$' | cut -d, -f1,3 | tr '\n' ' ')"; done
echo ab-finished

#!/bin/bash
# Parallel native generation (600292da on PR #2056's fa6254e0) against fa6254e0 on the 9700X: each build its own hold.
d=$HOME/buster-fast-bench/2056-claude
cd "$d" || exit 2
echo $$ > queue2.pid
while kill -0 "$(cat queue.pid 2>/dev/null)" 2>/dev/null; do sleep 10; done
mkdir -p logs
export EXCLUSIVE_OWNER=claude-pr2056-split EXCLUSIVE_TITLE="Parallel native generation A/B on PR 2056" EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/2056
H=head-fa6254e0; P=split-600292da
results=$d/results2.txt
one() { ~/buster-fast-bench/exclusive.sh env RESULTS="$results" "$d/run2.sh" "$@"; }
one $P warm - 0
for rep in 1 2 3; do
    if [ $((rep % 2)) = 1 ]; then one $H fresh - $rep; one $P fresh - $rep; else one $P fresh - $rep; one $H fresh - $rep; fi
done
for rep in 1 2 3; do
    for c in main:main.c input:c_check_input.c dataflow:ir_dataflow.c tier0:tier0.c; do
        IFS=: read -r name file <<< "$c"
        if [ $((rep % 2)) = 1 ]; then one $H $name $file $rep; one $P $name $file $rep; else one $P $name $file $rep; one $H $name $file $rep; fi
    done
done
# Runtime: the two compilers, whole compiles in a Williams order, on the performance core.
mkdir -p runtime && cp ~/buster-fast-bench/frontend-baseline-claude/baseline/sqlite3.c runtime/sqlite3.c
~/buster-fast-bench/exclusive.sh bash -c "cd $d/runtime && taskset -c 2 $d/$P/build/compiler time-runs --runs 21 --warmups 3 --build head $d/$H/build/compiler --build split $d/$P/build/compiler --list -c sqlite3.c -o sqlite3.o --list -fsyntax-only -march=native -I$d/$H/src -fwrapv -funsigned-char $d/$H/src/buster/compiler/main_unit_checker.c > $d/runtime/time-runs.txt 2>&1"
echo done >> "$results"

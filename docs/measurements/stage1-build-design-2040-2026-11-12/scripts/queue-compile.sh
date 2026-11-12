#!/bin/bash
# After the baseline scenarios: the tree restored and rebuilt, then the single compiles of the three largest units
# (compile.sh), each its own hold of the lock, and the reductions between them.
d=$HOME/buster-fast-bench/2040-claude
cd "$d" || exit 2
echo $$ > queue-compile.pid
while kill -0 "$(cat queue-base.pid 2>/dev/null)" 2>/dev/null; do sleep 5; done
lock() { scripts/lock.sh "$@"; }
lock bash -c "cd $d/src && git diff --stat > $d/logs/base-edits.diffstat && git checkout -q -- src"
lock scripts/run.sh base src restore none - 0
lock scripts/build-tools.sh > logs/build-tools.log 2>&1
units="main_unit_checker main_unit_backend main_unit_frontend"
for unit in $units; do lock scripts/compile.sh src $unit unoptimized; done
lock scripts/maps.sh $units > logs/maps.log 2>&1
for unit in $units; do lock scripts/compile.sh src $unit trace; done
for unit in $units; do
    lock bash -c "python3 $d/tools/trace_functions.py $d/results/compile/$unit-trace.json $d/results/maps/$unit.functions.tsv $d/results/maps/$unit.trace > $d/results/maps/$unit.trace.txt 2>&1"
done
for unit in $units; do lock scripts/compile.sh src $unit tests-optnone; done
for unit in $units; do lock scripts/compile.sh src $unit official; done
for unit in c_parser_benchmark tier1_select_benchmark; do
    lock scripts/compile.sh src $unit plain
    lock scripts/compile.sh src $unit official
done
echo done >> results/compile.txt

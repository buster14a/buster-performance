#!/bin/bash
# After the queue named by $1 ends: every unit's function map (maps-all.sh), the traces of the two longest benchmark
# units by function, and the code sizes of the checker's and the backend's units by whose function it is.
d=$HOME/buster-fast-bench/2040-claude
cd "$d" || exit 2
echo $$ > queue-extra.pid
while kill -0 "$(cat "${1:-queue-configs}.pid" 2>/dev/null)" 2>/dev/null; do sleep 5; done
lock() { scripts/lock.sh "$@"; }
lock scripts/maps-all.sh > logs/maps-all.log 2>&1
for unit in c_parser_benchmark tier1_select_benchmark; do
    lock scripts/compile.sh src $unit trace
    lock bash -c "python3 $d/tools/trace_functions.py $d/results/compile/$unit-trace.json $d/results/maps-all/$unit.functions.tsv $d/results/maps/$unit.trace > $d/results/maps/$unit.trace.txt 2>&1"
done
lock bash -c "for unit in main_unit_checker main_unit_backend; do $d/tools/object_functions $d/src/build/cmake/native/Release/codegen/\$unit/native.o > $d/results/maps/\$unit.code.tsv; done; $d/tools/object_functions $d/src/build/cmake/native/CMakeFiles/buster_main_unit_frontend.dir/Release/src/buster/compiler/main_unit_frontend.c.o > $d/results/maps/main_unit_frontend.code.tsv"
echo done >> results/compile.txt

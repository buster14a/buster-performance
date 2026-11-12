#!/bin/bash
# code.sh NAME TREE: object_functions of the three largest units of TREE as it is now built (each function with a hash
# of its machine code), into results/maps/UNIT.NAME.code.tsv, to be run inside the lock right after the build it reads.
d=$HOME/buster-fast-bench/2040-claude
name=$1; tree=$d/$2/build/cmake/native
for unit in main_unit_checker main_unit_backend main_unit_frontend; do
    object=$tree/Release/codegen/$unit/native.o
    [ -f "$object" ] || object=$tree/CMakeFiles/buster_$unit.dir/Release/src/buster/compiler/$unit.c.o
    "$d/tools/object_functions" "$object" > "$d/results/maps/$unit.$name.code.tsv"
done
wc -l "$d"/results/maps/*."$name".code.tsv

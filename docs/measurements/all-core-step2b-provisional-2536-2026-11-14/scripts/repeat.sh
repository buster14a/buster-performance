#!/bin/bash
# repeat.sh NAME DIRECTORY FILE OPTIONS...: FILE by -c and by --provisional-selection -c, alternating, 7 runs each on CPU 2
# from DIRECTORY, each counted by perf stat: out/NAME.plain.N.csv and out/NAME.provisional.N.csv (TSC ticks, task clock,
# user cycles and instructions), and whether the last two objects are the same bytes.
set -u
name=$1 directory=$2 file=$3
shift 3
compiler=$PWD/compiler-head
out=$PWD/out
cd "$directory" || exit 1
for run in 1 2 3 4 5 6 7; do
    perf stat -x, -e msr/tsc/,task-clock,cycles:u,instructions:u -o "$out/$name.plain.$run.csv" taskset -c 2 "$compiler" --lanes 1 "$@" -c "$file" -o "$out/o/$name.plain.o" 2> /dev/null < /dev/null
    perf stat -x, -e msr/tsc/,task-clock,cycles:u,instructions:u -o "$out/$name.provisional.$run.csv" taskset -c 2 "$compiler" --provisional-selection --lanes 1 "$@" -c "$file" -o "$out/o/$name.provisional.o" 2> /dev/null < /dev/null
done
cmp "$out/o/$name.plain.o" "$out/o/$name.provisional.o" > "$out/$name.same.txt" 2>&1
echo "cmp status $?" >> "$out/$name.same.txt"

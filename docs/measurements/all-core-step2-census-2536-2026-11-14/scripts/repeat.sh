#!/bin/bash
# repeat.sh NAME DIRECTORY FILE OPTIONS...: FILE's census and plain -c, alternating, 7 runs each on CPU 2 from DIRECTORY:
# out/NAME.repeat.txt has the census's reports, out/NAME.plain.N.csv perf stat's TSC ticks, task clock and user cycles
# and instructions of plain run N.
set -u
name=$1 directory=$2 file=$3
shift 3
compiler=$PWD/compiler-head
out=$PWD/out
: > "$out/$name.repeat.txt"
cd "$directory" || exit 1
for run in 1 2 3 4 5 6 7; do
    taskset -c 2 "$compiler" --selection-census --lanes 1 "$@" -c "$file" -o "$out/o/$name.census.o" 2> "$out/o/$name.err" < /dev/null
    grep '^selection-census' "$out/o/$name.err" >> "$out/$name.repeat.txt"
    perf stat -x, -e msr/tsc/,task-clock,cycles:u,instructions:u -o "$out/$name.plain.$run.csv" taskset -c 2 "$compiler" --lanes 1 "$@" -c "$file" -o "$out/o/$name.plain.o" 2> /dev/null < /dev/null
done
cmp "$out/o/$name.census.o" "$out/o/$name.plain.o" > "$out/$name.same.txt" 2>&1
echo "cmp status $?" >> "$out/$name.same.txt"

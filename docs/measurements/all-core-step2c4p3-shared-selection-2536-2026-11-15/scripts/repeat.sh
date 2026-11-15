#!/bin/bash
# repeat.sh NAME DIRECTORY FILE OPTIONS...: FILE from DIRECTORY on CPU 2, 7 rounds of each build's -c,
# --provisional-selection -c and --windowed-loop -c, BASE first in odd rounds and HEAD first in even ones.
# out/NAME.SIDE.MODE.N.csv has perf stat's TSC ticks, task clock and user cycles and instructions of round N.
set -u
name=$1 directory=$2 file=$3
shift 3
here=$PWD
out=$PWD/out
mkdir -p "$out/o"
cd "$directory" || exit 1
stat()
{
    local side=$1 mode=$2 run=$3
    shift 3
    perf stat -x, -e msr/tsc/,task-clock,cycles:u,instructions:u -o "$out/$name.$side.$mode.$run.csv" taskset -c 2 "$here/compiler-$side" --lanes 1 "$@" -c "$file" -o "$out/o/$name.$side.$mode.o" 2> /dev/null < /dev/null
}
for run in 1 2 3 4 5 6 7; do
    order="base head"
    [ $((run % 2)) -eq 0 ] && order="head base"
    for side in $order; do
        stat "$side" plain "$run" "$@"
        stat "$side" provisional "$run" --provisional-selection "$@"
        stat "$side" windowed "$run" --windowed-loop "$@"
    done
done
for side in base head; do
    for mode in provisional windowed; do
        cmp "$out/o/$name.$side.plain.o" "$out/o/$name.$side.$mode.o" > "$out/$name.$side.$mode.same.txt" 2>&1
        echo "cmp status $?" >> "$out/$name.$side.$mode.same.txt"
    done
done
cmp "$out/o/$name.base.plain.o" "$out/o/$name.head.plain.o" > "$out/$name.sides.same.txt" 2>&1
echo "cmp status $?" >> "$out/$name.sides.same.txt"

#!/bin/bash
# repeat.sh NAME DIRECTORY FILE OPTIONS...: FILE from DIRECTORY on CPU 2, 7 rounds of each build's --selection-census -c,
# -c and --provisional-selection -c, BASE first in odd rounds and HEAD first in even ones. out/NAME.repeat.txt has the
# censuses' ticks, a line a run; out/NAME.SIDE.MODE.N.csv perf stat's TSC ticks, task clock and user cycles and
# instructions of round N's -c (MODE plain) and --provisional-selection -c (MODE provisional).
set -u
name=$1 directory=$2 file=$3
shift 3
here=$PWD
out=$PWD/out
mkdir -p "$out/o"
: > "$out/$name.repeat.txt"
cd "$directory" || exit 1
for run in 1 2 3 4 5 6 7; do
    order="base head"
    [ $((run % 2)) -eq 0 ] && order="head base"
    for side in $order; do
        taskset -c 2 "$here/compiler-$side" --selection-census --lanes 1 "$@" -c "$file" -o "$out/o/$name.$side.census.o" 2> "$out/o/$name.$side.err" < /dev/null
        printf '%s\t%s\t%s\n' "$side" "$run" "$(grep '^selection-census-ticks' "$out/o/$name.$side.err" | cut -f2-)" >> "$out/$name.repeat.txt"
    done
    for side in $order; do
        perf stat -x, -e msr/tsc/,task-clock,cycles:u,instructions:u -o "$out/$name.$side.plain.$run.csv" taskset -c 2 "$here/compiler-$side" --lanes 1 "$@" -c "$file" -o "$out/o/$name.$side.plain.o" 2> /dev/null < /dev/null
        perf stat -x, -e msr/tsc/,task-clock,cycles:u,instructions:u -o "$out/$name.$side.provisional.$run.csv" taskset -c 2 "$here/compiler-$side" --provisional-selection --lanes 1 "$@" -c "$file" -o "$out/o/$name.$side.provisional.o" 2> /dev/null < /dev/null
    done
done
for side in base head; do
    cmp "$out/o/$name.$side.plain.o" "$out/o/$name.$side.provisional.o" > "$out/$name.$side.same.txt" 2>&1
    echo "cmp status $?" >> "$out/$name.$side.same.txt"
done
cmp "$out/o/$name.base.plain.o" "$out/o/$name.head.plain.o" > "$out/$name.sides.same.txt" 2>&1
echo "cmp status $?" >> "$out/$name.sides.same.txt"

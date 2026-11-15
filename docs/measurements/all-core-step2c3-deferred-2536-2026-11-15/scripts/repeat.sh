#!/bin/bash
# repeat.sh NAME DIRECTORY FILE OPTIONS...: FILE from DIRECTORY on CPU 2, 7 rounds of BASE's and HEAD's -c and HEAD's
# --deferred-lowering -c, BASE first in odd rounds and HEAD first in even ones. out/NAME.SIDE.N.csv has perf stat's TSC
# ticks, task clock and user cycles and instructions of round N's run (SIDE base, head or deferred).
set -u
name=$1 directory=$2 file=$3
shift 3
here=$PWD
out=$PWD/out
mkdir -p "$out/o"
cd "$directory" || exit 1
for run in 1 2 3 4 5 6 7; do
    order="base head deferred"
    [ $((run % 2)) -eq 0 ] && order="deferred head base"
    for side in $order; do
        exe=$here/compiler-$side extra=
        [ "$side" = deferred ] && exe=$here/compiler-head extra=--deferred-lowering
        perf stat -x, -e msr/tsc/,task-clock,cycles:u,instructions:u -o "$out/$name.$side.$run.csv" taskset -c 2 "$exe" $extra --lanes 1 "$@" -c "$file" -o "$out/o/$name.$side.o" 2> /dev/null < /dev/null
    done
done
for pair in "base head" "head deferred"; do
    set -- $pair
    cmp "$out/o/$name.$1.o" "$out/o/$name.$2.o" > "$out/$name.$1-$2.same.txt" 2>&1
    echo "cmp status $?" >> "$out/$name.$1-$2.same.txt"
done

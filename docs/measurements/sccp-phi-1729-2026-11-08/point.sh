#!/bin/bash
# One lock hold: ROUNDS alternating whole-process compiles of INPUT by bin/$A and bin/$B (base and head by default),
# pinned to CPU 2. Prints "LABEL binary round microseconds status" lines. Run under exclusive.sh.
set -u
label=$1; rounds=$2; shift 2
A=${A:-base}; B=${B:-head}
D=$HOME/buster-fast-bench/1729-opencode
for round in $(seq 1 "$rounds"); do
    if [ $((round % 2)) -eq 1 ]; then order="$A $B"; else order="$B $A"; fi
    for b in $order; do
        s=$(date +%s%N)
        taskset -c 2 "$D/bin/$b" "$@" -o "$D/out/$label.$b.o" > /dev/null 2> "$D/out/$label.$b.err"
        status=$?
        e=$(date +%s%N)
        echo "$label $b $round $(( (e - s) / 1000 )) $status"
    done
done

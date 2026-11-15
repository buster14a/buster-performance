#!/usr/bin/env bash
# repeat-kernel.sh MARCH KERNEL ROUNDS NAME_A NAME_B: one kernel's two builds at every placement, alternating build by
# build and placement by placement for ROUNDS rounds, in one lock hold on CPU 2, with perf's user cycles and
# instructions per run. Lines as run-pair.sh's, with the round last. For a kernel whose one-sample ratio was close to 1.
set -u
MARCH=$1
K=$2
ROUNDS=$3
A=$4
B=$5
cd "$(dirname "$0")"
O=out/$MARCH
head -1 /var/lib/buster-9700x/owner >> holds.txt
for round in $(seq 1 "$ROUNDS"); do
    for PAD in 0 16 32 48; do
        if [ $((round % 2)) = 0 ]; then order="$B $A"; else order="$A $B"; fi
        for NAME in $order; do
            H=$O/p$PAD-$NAME
            line=$(taskset -c 2 $H "$K" 0 2>&1)
            status=$?
            reps=$(echo "$line" | cut -d' ' -f3)
            taskset -c 2 perf stat -x, -e cycles:u,instructions:u -o $O/perfN.txt -- $H "$K" "$reps" > /dev/null 2>&1
            sN=$?
            cN=$(grep cycles $O/perfN.txt | cut -d, -f1); iN=$(grep instructions $O/perfN.txt | cut -d, -f1)
            echo "$MARCH $NAME pad$PAD $line | status $status | perf $reps $cN $iN status $sN | round $round"
        done
    done
done

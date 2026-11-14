#!/usr/bin/env bash
# run-one.sh MARCH NAME PAD: every kernel of one build at one placement, pinned to CPU 2. Run under the lock.
# A line per kernel: MARCH NAME padP <harness line> | <innermost loop>; at pad 0 also a "perf" line with user
# cycles and instructions of a 1-repetition run and of a run of the calibrated repetitions.
set -u
MARCH=$1
NAME=$2
PAD=$3
cd "$(dirname "$0")"
O=out/$MARCH
H=$O/p$PAD-$NAME
head -1 /var/lib/buster-9700x/owner >> holds.txt
for k in $($H list); do
    line=$(taskset -c 2 $H "$k" 0 2>&1)
    status=$?
    loop=$(grep "^k_$k " $H.loops)
    echo "$MARCH $NAME pad$PAD $line | $loop | status $status"
    if [ "$PAD" = 0 ]; then
        reps=$(echo "$line" | cut -d' ' -f3)
        taskset -c 2 perf stat -x, -e cycles:u,instructions:u -o $O/perf1.txt -- $H "$k" 1 > /dev/null 2>&1
        s1=$?
        taskset -c 2 perf stat -x, -e cycles:u,instructions:u -o $O/perfN.txt -- $H "$k" "$reps" > /dev/null 2>&1
        sN=$?
        c1=$(grep cycles $O/perf1.txt | cut -d, -f1); i1=$(grep instructions $O/perf1.txt | cut -d, -f1)
        cN=$(grep cycles $O/perfN.txt | cut -d, -f1); iN=$(grep instructions $O/perfN.txt | cut -d, -f1)
        echo "perf $MARCH $NAME $k 1 $c1 $i1 $reps $cN $iN status $s1 $sN"
    fi
done

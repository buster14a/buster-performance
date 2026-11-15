#!/usr/bin/env bash
# run-pair.sh MARCH NAME_A NAME_B PAD: two builds' kernels at one placement in one lock hold, pinned to CPU 2, the
# builds alternating kernel by kernel (A first on even kernels, B first on odd ones), so that a pair's two runs see the
# same machine state. Lines as run-one.sh's: MARCH NAME padP <harness line> | <innermost loop> | status S, and a perf
# line per run with the placement last. Run under the lock.
set -u
MARCH=$1
A=$2
B=$3
PAD=$4
cd "$(dirname "$0")"
O=out/$MARCH
head -1 /var/lib/buster-9700x/owner >> holds.txt
one()
{
    NAME=$1
    k=$2
    H=$O/p$PAD-$NAME
    line=$(taskset -c 2 $H "$k" 0 2>&1)
    status=$?
    loop=$(grep "^k_$k " $H.loops)
    echo "$MARCH $NAME pad$PAD $line | $loop | status $status"
    reps=$(echo "$line" | cut -d' ' -f3)
    taskset -c 2 perf stat -x, -e cycles:u,instructions:u -o $O/perf1.txt -- $H "$k" 1 > /dev/null 2>&1
    s1=$?
    taskset -c 2 perf stat -x, -e cycles:u,instructions:u -o $O/perfN.txt -- $H "$k" "$reps" > /dev/null 2>&1
    sN=$?
    c1=$(grep cycles $O/perf1.txt | cut -d, -f1); i1=$(grep instructions $O/perf1.txt | cut -d, -f1)
    cN=$(grep cycles $O/perfN.txt | cut -d, -f1); iN=$(grep instructions $O/perfN.txt | cut -d, -f1)
    echo "perf $MARCH $NAME $k 1 $c1 $i1 $reps $cN $iN status $s1 $sN pad$PAD"
}
n=0
for k in $($O/p$PAD-$A list); do
    if [ $((n % 2)) = 0 ]; then
        one $A $k
        one $B $k
    else
        one $B $k
        one $A $k
    fi
    n=$((n + 1))
done

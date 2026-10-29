#!/bin/bash
# benchmark-x86-semantics of main and head on CPU 2, five rounds, each one hold of the lock (about 20 s) that runs both
# trees in an order alternating by round: the full run, then the effects and choice loops alone (--only), back to back
# and after 200 ms of their scalar twins.
. "$(dirname "$0")/env.sh"
mkdir -p $M/sem
round() { # r first second
    local r=$1
    shift
    for t in "$@"; do
        taskset -c 2 $T/$t/build/compiler benchmark-x86-semantics > $M/sem/full-$t-$r.log 2>&1
        for only in effects-avx512 choose-avx512; do
            taskset -c 2 $T/$t/build/compiler benchmark-x86-semantics --only $only > $M/sem/$only-$t-$r.log 2>&1
            taskset -c 2 $T/$t/build/compiler benchmark-x86-semantics --only $only --after-scalar 200 > $M/sem/$only-after-$t-$r.log 2>&1
        done
    done
}
export -f round
export T M
for r in 1 2 3 4 5; do
    if [ $((r % 2)) -eq 1 ]; then $X bash -c "round $r main head"; else $X bash -c "round $r head main"; fi
done
echo "sem done $(date -Is)"

#!/bin/bash
# benchmark-x86-semantics of main and head on CPU 2, five rounds, each one hold of the lock that runs both trees in an
# order alternating by round: the full run, then the effects and choice loops alone (--only), back to back and after
# 200 ms of their scalar twins; the head's opmask loop too.
. "$(dirname "$0")/env.sh"
mkdir -p $M/sem
round() { # r first second
    local r=$1
    shift
    for t in "$@"; do
        taskset -c 2 $T/$t/build/compiler benchmark-x86-semantics > $M/sem/full-$t-$r.log 2>&1; echo "$? sem/full-$t-$r.log" >> $M/sem/status.txt
        for only in effects-avx512 choose-avx512; do
            taskset -c 2 $T/$t/build/compiler benchmark-x86-semantics --only $only > $M/sem/$only-$t-$r.log 2>&1; echo "$? sem/$only-$t-$r.log" >> $M/sem/status.txt
            taskset -c 2 $T/$t/build/compiler benchmark-x86-semantics --only $only --after-scalar 200 > $M/sem/$only-after-$t-$r.log 2>&1; echo "$? sem/$only-after-$t-$r.log" >> $M/sem/status.txt
        done
    done
    taskset -c 2 $T/$HEAD/build/compiler benchmark-x86-semantics --only effects-opmasks > $M/sem/effects-opmasks-$HEAD-$r.log 2>&1; echo "$? sem/effects-opmasks-$HEAD-$r.log" >> $M/sem/status.txt
    taskset -c 2 $T/$HEAD/build/compiler benchmark-x86-semantics --only effects-opmasks --after-scalar 200 > $M/sem/effects-opmasks-after-$HEAD-$r.log 2>&1; echo "$? sem/effects-opmasks-after-$HEAD-$r.log" >> $M/sem/status.txt
}
export -f round
export T M HEAD
for r in 1 2 3 4 5; do
    if [ $((r % 2)) -eq 1 ]; then $X bash -c "round $r $MAIN $HEAD"; else $X bash -c "round $r $HEAD $MAIN"; fi
done
echo "sem done $(date -Is)"

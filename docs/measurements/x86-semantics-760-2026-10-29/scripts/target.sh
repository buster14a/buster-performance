#!/bin/bash
# benchmark-x86-target of main and head on CPU 2, five rounds, each one hold running both trees in an order alternating
# by round: the AVX-512 builder alone, and one table after 100 ms of predefines.
. "$(dirname "$0")/env.sh"
mkdir -p $M/target
round() { # r first second
    local r=$1
    shift
    for t in "$@"; do
        taskset -c 2 $T/$t/build/compiler benchmark-x86-target --only avx512 > $M/target/avx512-$t-$r.log 2>&1; echo "$? target/avx512-$t-$r.log" >> $M/target/status.txt
        taskset -c 2 $T/$t/build/compiler benchmark-x86-target --after-predefines 100 > $M/target/after-$t-$r.log 2>&1; echo "$? target/after-$t-$r.log" >> $M/target/status.txt
    done
}
export -f round
export T M
for r in 1 2 3 4 5; do
    if [ $((r % 2)) -eq 1 ]; then $X bash -c "round $r $MAIN $HEAD"; else $X bash -c "round $r $HEAD $MAIN"; fi
done
echo "target done $(date -Is)"

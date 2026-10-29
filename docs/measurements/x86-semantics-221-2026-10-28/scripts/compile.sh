#!/bin/bash
# -c of the frozen sqlite3.c by main and head on CPU 2, with the 9700X job's compile-time options, perf stat's 11 runs
# each, five rounds, each one hold running both trees in an order alternating by round; then each output's hash.
. "$(dirname "$0")/env.sh"
mkdir -p $M/compile
round() { # r first second
    local r=$1
    shift
    for t in "$@"; do
        taskset -c 2 perf stat -r 11 -x, -e task-clock,cycles:u,instructions:u -o $M/compile/$t-$r.csv $T/$t/build/compiler -o $M/compile/$t.o "${COMPILE[@]}" > $M/compile/$t-$r.out 2>&1
    done
}
export -f round
for r in 1 2 3 4 5; do
    if [ $((r % 2)) -eq 1 ]; then $X bash -c ". $B/env.sh; round $r main head"; else $X bash -c ". $B/env.sh; round $r head main"; fi
done
sha256sum $M/compile/*.o
echo "compile done $(date -Is)"

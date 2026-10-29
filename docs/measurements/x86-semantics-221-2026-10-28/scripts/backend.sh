#!/bin/bash
# benchmark-backend-source on the frozen sqlite3.c, three rounds, each one hold running main and head in an order
# alternating by round, then the head's choice alone after 200 ms of its scalar twin.
. "$(dirname "$0")/env.sh"
mkdir -p $M/backend
round() { # r first second
    local r=$1
    shift
    for t in "$@"; do
        taskset -c 2 $T/$t/build/compiler benchmark-backend-source "${SQLITE[@]}" > $M/backend/$t-$r.log 2>&1
    done
    taskset -c 2 $T/head/build/compiler benchmark-backend-source --only choose --after-scalar 200 "${SQLITE[@]}" > $M/backend/choose-after-head-$r.log 2>&1
}
export -f round
export T M
export SQLITE_LINE="${SQLITE[*]}"
for r in 1 2 3; do
    if [ $((r % 2)) -eq 1 ]; then $X bash -c ". $B/env.sh; round $r main head"; else $X bash -c ". $B/env.sh; round $r head main"; fi
done
echo "backend done $(date -Is)"

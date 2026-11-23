#!/usr/bin/env bash
# run-short.sh MARCH NAME: every kernel of one build at the short trip counts (short.c), as linked, pinned to CPU 2.
# Run under the lock. A line per kernel and trip count: short MARCH NAME <short's line> status S.
set -u
MARCH=$1
NAME=$2
cd "$(dirname "$0")"
O=out/$MARCH
S=$O/s-$NAME
head -1 /var/lib/buster-9700x/owner >> holds.txt
for k in $($S list); do
    out=$(taskset -c 2 $S "$k" 2>&1)
    status=$?
    echo "$out" | while read -r line; do echo "short $MARCH $NAME $line status $status"; done
done

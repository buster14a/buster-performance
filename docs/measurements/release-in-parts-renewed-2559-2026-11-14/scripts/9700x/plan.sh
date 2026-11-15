#!/bin/bash
# The A/B's queue from the calibration (results/calibrate.txt, the last line of each benchmark): plan.sh ROUND > QUEUE
# Each hold runs 3 builds (base, head, base-again) at its placements, a warm-up and RUNS runs each, about 150 s or
# less: a benchmark of up to 2 s takes all four placements and 3 runs; up to 6 s, all four and 1 run; up to 12 s, two
# holds of two placements; longer, a hold a placement. One of up to 0.5 s takes 11 runs. ROUND only names the round in the queue's comments.
set -u
d=$HOME/buster-fast-bench/2559-step5b-claude
b=$d/scripts/bench.sh
echo "# round $1"
awk -F'\t' '{ t[$1] = $3 + 0 } END { for (n in t) print n, t[n] }' "$d/results/calibrate.txt" | sort |
while read -r name seconds; do
    if awk -v s="$seconds" 'BEGIN { exit !(s <= 0.5) }'; then
        echo "$b $name 11"
    elif awk -v s="$seconds" 'BEGIN { exit !(s <= 2) }'; then
        echo "$b $name 3"
    elif awk -v s="$seconds" 'BEGIN { exit !(s <= 6) }'; then
        echo "$b $name 1"
    elif awk -v s="$seconds" 'BEGIN { exit !(s <= 12) }'; then
        echo "$b $name 1 0 2112"
        echo "$b $name 1 1088 3136"
    else
        for p in 0 1088 2112 3136; do echo "$b $name 1 $p"; done
    fi
done

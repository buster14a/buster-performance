#!/bin/bash
# job31.sh: where do the shadow's own sweeps' cycles go, u3 against w2 (job30: X reads about 6% more cycles a node on
# sqlite3.c for the same instructions)? Three rounds of sweeps-events.sh, the labels in turn, 40 passes, no front.
set -u
cd "$(dirname "$0")"
for round in 1 2 3; do
    for label in u3 w2; do
        ./sweeps-events.sh $label plain $round 40
    done
done
python3 sweeps-events.py results plain u3 w2 > results/sweeps-events-plain-u3-w2.txt 2>&1
echo "job31 done $(date -u +%FT%TZ)" >> results/job31.log

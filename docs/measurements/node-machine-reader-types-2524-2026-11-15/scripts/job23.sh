#!/bin/bash
# job23.sh: what moves the loads' kernel on sqlite3.c with the windows packed (job22: 11.07 against 11.79 cycles a taken
# leaf or lookup, the same instructions)? m14 and u3 in turn, three rounds of facts-events.sh at 160 passes: counters
# of the whole process and its cycles by symbol. Then the same for the whole kernel in bodies (22.88 against 23.16).
set -u
cd "$(dirname "$0")"
log=results/job23.log
for round in 1 2 3; do
    for label in m14 u3; do
        ./facts-events.sh $label loadspacked $round 160 --facts-loads --facts-packed
    done
done
python3 facts-events.py results loadspacked m14 u3 > results/facts-events-loadspacked-m14-u3.txt 2>&1
echo "loadspacked done $(date -u +%T)" >> $log
for round in 1 2 3; do
    for label in m14 u3; do
        ./facts-events.sh $label body $round 160
    done
done
python3 facts-events.py results body m14 u3 > results/facts-events-body-m14-u3.txt 2>&1
echo "job23 done $(date -u +%FT%TZ)" >> $log

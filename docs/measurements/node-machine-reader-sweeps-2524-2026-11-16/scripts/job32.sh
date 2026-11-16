#!/bin/bash
# job32.sh: is the shadow's own sweeps' cost in w2 (cycles +1.3% to +1.7% on u3's for 0.5 fewer instructions a node,
# store-to-load interference +60%) where the machine's structure falls on the stack? w3 is w2 with 4,072 bytes of padding
# after the structure's three new fields, so that it is a page (4,096 bytes) larger than u3's instead of 24 bytes: what is
# below it on the stack is then at u3's place in its page. Built; then three rounds of sweeps-events.sh (40 passes, no
# front) and seven of the timed sweeps (seven passes), u3, w2 and w3 in turn.
set -u
cd "$(dirname "$0")"
log=results/job32.log
./build-label.sh w3 be6515fba w3.patch > results/w3-build.out 2>&1 || { echo "w3 build failed" >> $log; exit 1; }
echo "built $(date -u +%T)" >> $log
for round in 4 5 6; do
    for label in u3 w2 w3; do
        ./sweeps-events.sh $label plain $round 40
    done
done
python3 sweeps-events.py results plain u3 w3 > results/sweeps-events-plain-u3-w3.txt 2>&1
python3 sweeps-events.py results plain u3 w2 > results/sweeps-events-plain-u3-w2-six.txt 2>&1
echo "events done $(date -u +%T)" >> $log
./types-o2.sh -v 1 7 "u3 plain7 --passes 7" "w2 plain7 --passes 7" "w3 plain7 --passes 7"
echo "job32 done $(date -u +%FT%TZ)" >> $log

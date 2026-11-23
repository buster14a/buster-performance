#!/bin/bash
# job-z1-nets.sh: the size cut: the producer against the oracle, the corpora's objects (plain, -fPIC, -Wall -Wextra), the
# units, the option sets' sweep, the producer's test part, the driver's eight parts, main.c compiled by itself.
export PATH="$HOME/dev/scripts:$PATH"
B=/tmp/claude-1000/lazy/b3
L=https://github.com/buster14a/buster/issues/2850
N=${1:-z1}
cc=$B/snap-$N/build/cmake/native/Develop/compiler
( CORES_TITLE="#2850: the producer on the corpora against the oracle (the size cut)" CORES_LINK=$L cores -n 1 -- bash /tmp/claude-1000/lazy/b2/produce-run.sh "$cc" $B/produce-$N; echo "oracle: $(grep -c ' exit 0' $B/produce-$N/reduced.txt) of $(grep -c ' exit ' $B/produce-$N/reduced.txt) status 0; $(grep -h 'outside=' $B/produce-$N/reduced.txt | grep -o 'outside=[0-9]*' | sort | uniq -c | tr '\n' ' ')" ) &
( CORES_TITLE="#2850: the corpora's objects with and without --node-bodies (the size cut)" CORES_LINK=$L cores -n 1 -- bash $B/h2/corpus-objects.sh "$cc" $B/h2/objects-$N > $B/h2/objects-$N.log 2>&1; grep "units=" $B/h2/objects-$N.log | awk '{print "plain", $1, $4, $5, $6, $7, $9}' ) &
( CORES_TITLE="#2850: the corpora's objects, -fPIC (the size cut)" CORES_LINK=$L cores -n 1 -- bash $B/h2/corpus-objects.sh "$cc" $B/h2/objects-$N-pic -fPIC > $B/h2/objects-$N-pic.log 2>&1; grep "units=" $B/h2/objects-$N-pic.log | awk '{print "pic", $1, $4, $5, $6, $7, $9}' ) &
( CORES_TITLE="#2850: the corpora's objects, -Wall -Wextra (the size cut)" CORES_LINK=$L cores -n 1 -- bash $B/h2/corpus-objects.sh "$cc" $B/h2/objects-$N-wall -Wall -Wextra > $B/h2/objects-$N-wall.log 2>&1; grep "units=" $B/h2/objects-$N-wall.log | awk '{print "wall", $1, $4, $5, $6, $7, $9}' ) &
( for u in units3 units4; do taskset -c 1 python3 $B/loud/run.py "$cc" $B/loud/$u $B/loud/$N-$u 2>&1 | grep "units; flagged" | cut -c1-40; done ) &
wait
CORES_TITLE="#2850: units under each option set (the size cut)" CORES_LINK=$L cores -n 6 -- bash $B/h2/sweep.sh "$cc" $B/h2/sweep-$N > $B/h2/sweep-$N.out 2>&1
grep -v "^cores:" $B/h2/sweep-$N.out | head -2
echo nets-complete

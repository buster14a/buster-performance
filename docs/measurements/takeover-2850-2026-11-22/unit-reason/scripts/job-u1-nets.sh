#!/bin/bash
# job-u1-nets.sh: the cut of a unit's fixed cost at b0ee1afaa: the producer against the oracle, the corpora's objects
# (plain, -fPIC, -Wall -Wextra), the units, the option sets' sweep, the producer's test part.
export PATH="$HOME/dev/scripts:$PATH"
B=/tmp/claude-1000/lazy/b3
L=https://github.com/buster14a/buster/issues/2850
cc=$B/snap-u1/build/cmake/native/Develop/compiler
( CORES_TITLE="#2850: the producer on the corpora against the oracle (the unit's cut)" CORES_LINK=$L cores -n 1 -- bash /tmp/claude-1000/lazy/b2/produce-run.sh "$cc" $B/produce-u1; echo "oracle: $(grep -c ' exit 0' $B/produce-u1/reduced.txt) of $(grep -c ' exit ' $B/produce-u1/reduced.txt) status 0; $(grep -h 'outside=' $B/produce-u1/reduced.txt | grep -o 'outside=[0-9]*' | sort | uniq -c | tr '\n' ' ')" ) &
( CORES_TITLE="#2850: the corpora's objects with and without --node-bodies (the unit's cut)" CORES_LINK=$L cores -n 1 -- bash $B/h2/corpus-objects.sh "$cc" $B/h2/objects-u1 > $B/h2/objects-u1.log 2>&1; grep "units=" $B/h2/objects-u1.log | awk '{print "plain", $1, $4, $5, $6, $7, $9}' ) &
( CORES_TITLE="#2850: the corpora's objects, -fPIC (the unit's cut)" CORES_LINK=$L cores -n 1 -- bash $B/h2/corpus-objects.sh "$cc" $B/h2/objects-u1-pic -fPIC > $B/h2/objects-u1-pic.log 2>&1; grep "units=" $B/h2/objects-u1-pic.log | awk '{print "pic", $1, $4, $5, $6, $7, $9}' ) &
( CORES_TITLE="#2850: the corpora's objects, -Wall -Wextra (the unit's cut)" CORES_LINK=$L cores -n 1 -- bash $B/h2/corpus-objects.sh "$cc" $B/h2/objects-u1-wall -Wall -Wextra > $B/h2/objects-u1-wall.log 2>&1; grep "units=" $B/h2/objects-u1-wall.log | awk '{print "wall", $1, $4, $5, $6, $7, $9}' ) &
( for u in units3 units4; do taskset -c 1 python3 $B/loud/run.py "$cc" $B/loud/$u $B/loud/u1-$u 2>&1 | grep "units; flagged" | cut -c1-40; done ) &
wait
CORES_TITLE="#2850: units under each option set (the unit's cut)" CORES_LINK=$L cores -n 6 -- bash $B/h2/sweep.sh "$cc" $B/h2/sweep-u1 > $B/h2/sweep-u1.out 2>&1
grep -v "^cores:" $B/h2/sweep-u1.out | head -2
cd $HOME/.cache/claude-2850/wt-h1 && CORES_TITLE="buster #2850: the producer's fixtures" CORES_LINK=$L cores -n 1 -- ./build/cmake/native/Develop/compiler test-checker --part 45/64 2>&1 | tail -1
echo job-complete

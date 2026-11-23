#!/bin/bash
# job-c1-extra.sh: two clauses of C1 on the corpora at 4fcadeb45: -Wall -Wextra (no body taken), and each half of the
# producer's bodies; and the units under -Wall -Wextra.
export PATH="$HOME/dev/scripts:$PATH"
B=/tmp/claude-1000/lazy/b3
L=https://github.com/buster14a/buster/issues/2850
cc2=$B/snap-y2/build/cmake/native/Develop/compiler
( CORES_TITLE="#2850: the corpora's objects with --node-bodies, -Wall -Wextra" CORES_LINK=$L cores -n 1 -- bash $B/h2/corpus-objects.sh "$cc2" $B/h2/objects-y2-wall -Wall -Wextra > $B/h2/objects-y2-wall.log 2>&1 ) &
( SELECT=2:0 CORES_TITLE="#2850: the corpora's objects with half of the producer's bodies taken (2:0)" CORES_LINK=$L cores -n 1 -- bash $B/h2/corpus-objects-select.sh "$cc2" $B/h2/objects-y2-20 > $B/h2/objects-y2-20.log 2>&1 ) &
( SELECT=2:1 CORES_TITLE="#2850: the corpora's objects with half of the producer's bodies taken (2:1)" CORES_LINK=$L cores -n 1 -- bash $B/h2/corpus-objects-select.sh "$cc2" $B/h2/objects-y2-21 > $B/h2/objects-y2-21.log 2>&1 ) &
( mkdir -p $B/h2/sweep-wall; ls $B/loud/units3/*.c $B/loud/units4/*.c $B/h2/sweep.c $B/h2/fixture.c $B/h2/splice.c > $B/h2/sweep-wall/sources.txt; CORES_TITLE="#2850: units under -Wall -Wextra with and without --node-bodies" CORES_LINK=$L cores -n 1 -- bash $B/h2/sweep-one.sh "$cc2" $B/h2/sweep-wall 0 -Wall -Wextra > $B/h2/sweep-wall.out 2>&1 ) &
wait
for f in objects-y2-wall objects-y2-20 objects-y2-21; do echo "== $f"; grep "units=" $B/h2/$f.log | awk '{print $1, $2, $4, $5, $6, $7, $9}'; done
grep -v "^cores:" $B/h2/sweep-wall.out
echo job-complete

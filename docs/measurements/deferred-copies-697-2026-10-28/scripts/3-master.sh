#!/bin/bash
# Item 2's builds, its tests, then campaign A3: record A2's grid of the 43 units on item2 (2, 3, 4 and 8 lanes, with
# every lane, and 2 and 8 warm) and main3 (2 and 8), three rounds, 11 jobs a lock hold, 30 s apart. Arguments: MAIN.
D=/home/david/buster-fast-bench/697-cloud
cd "$D" || exit 1
echo $$ > "$D/3-master.pid"
"$D/3-build.sh" "$1" item2 || { echo "master builds failed $(date -Is)" >> "$D/chain.out"; exit 1; }
"$D/3-tests.sh" item2 3-tests.txt
"$D/3-queue.sh" 3-jobsA.txt 3-logA.txt 1 0 3 11 30
echo "3-master done $(date -Is)" >> "$D/chain.out"

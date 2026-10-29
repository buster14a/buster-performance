#!/bin/bash
# The final tree's tests and campaign A4: final4 (main3 with final4.diff: item 2 with the deferred state's own arenas in
# base pages and a lane's per-name columns committed for the names a reading has; built by 3-diag7.sh) tested
# (4-tests.txt); then record A2's grid of the 43 units on final4 (2, 3, 4 and 8 lanes, with every lane, and 2 and 8
# warm), main3 and main3-nothp (2 and 8), three rounds, 11 jobs a lock hold, 30 s apart (4-logA.txt).
D=/home/david/buster-fast-bench/697-cloud
cd "$D" || exit 1
echo $$ > "$D/4-master.pid"
[ -x "$D/final4/build/compiler" ] && [ -x "$D/main3/build/compiler" ] && [ -x "$D/main3-nothp/build/compiler" ] || { echo "4-master trees missing $(date -Is)" >> "$D/chain.out"; exit 1; }
"$D/3-tests.sh" final4 4-tests.txt
"$D/3-queue.sh" 4-jobsA.txt 4-logA.txt 1 0 3 11 30
echo "4-master done $(date -Is)" >> "$D/chain.out"

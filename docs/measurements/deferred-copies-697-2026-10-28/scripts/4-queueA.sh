#!/bin/bash
# Campaign A4 (4-master.sh queue, started apart from its tests so that the two queue at once): record A2 grid of the
# 43 units on final4, main3 and main3-nothp, three rounds, 11 jobs a lock hold, 30 s apart (4-logA.txt).
D=/home/david/buster-fast-bench/697-cloud
cd "$D" || exit 1
"$D/3-queue.sh" 4-jobsA.txt 4-logA.txt 1 0 3 11 30
echo "4-master done $(date -Is)" >> "$D/chain.out"

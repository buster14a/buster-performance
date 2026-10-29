#!/bin/bash
# Campaign S4, started beside A4 since no refit of the rule changes it (every rule gives sqlite3.c eight lanes): the
# frozen sqlite3.c by main3's rule and final4's on eight lanes, 24 passes a process, six rounds, a process a hold, their
# order alternating by round, for item 1's phases after items 2 and 4 (4-logS.txt; 4-chainB.sh's S4 with final4).
D=/home/david/buster-fast-bench/697-cloud
cd "$D" || exit 1
export EXCLUSIVE_OWNER=claude-697-cloud
export EXCLUSIVE_TITLE="#697 deferred bodies (cloud session): item 1's phases after items 2 and 4 on the 9700X"
export EXCLUSIVE_LINK="https://github.com/buster14a/buster/issues/697"
unset CPATH C_INCLUDE_PATH
export SOURCE_DATE_EPOCH=1792454400
corpus=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
for round in 1 2 3 4 5 6; do
    if [ $((round % 2)) = 0 ]; then order=(final4:8 main3:8); else order=(main3:8 final4:8); fi
    for run in "${order[@]}"; do
        ~/buster-fast-bench/exclusive.sh "$D/3-runs.sh" "$D/4-logS.txt" "$round" sqlite "$corpus/sqlite/sqlite3.c" 24 "$run" > /dev/null 2>> "$D/3-queue.lock.txt"
        sleep 10
    done
done
echo done >> "$D/4-logS.txt"
echo "4-S4 done $(date -Is)" >> "$D/chain.out"

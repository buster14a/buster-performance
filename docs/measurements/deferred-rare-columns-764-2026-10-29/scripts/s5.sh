#!/bin/bash
# Campaign S5 (#764): the frozen sqlite3.c by each tree's rule on up to 8 lanes, 24 passes, six processes of each tree,
# their order alternating by round, a pair a lock hold, 30 s apart, into logs/S5.txt (record S4's 4-S4.sh).
# Arguments: TREE TREE.
. ~/buster-fast-bench/claude-764/scripts/env.sh
for round in 1 2 3 4 5 6; do
    if [ $((round % 2)) = 1 ]; then
        order="$1:8 $2:8"
    else
        order="$2:8 $1:8"
    fi
    ~/buster-fast-bench/exclusive.sh "$D/scripts/runs.sh" "$D/logs/S5.txt" "$round" sqlite 24 $order > /dev/null 2>> "$D/logs/queue.lock.txt"
    sleep 30
done
echo "s5 done $(date -Is)" >> "$D/logs/S5.txt"

#!/bin/bash
# E2 for #874: every unit of the list, each tree's cold reading, one lock hold per process. Arguments: UNIT...
. ~/buster-fast-bench/874-verify/scripts/env.sh
for unit in "$@"; do
    for tree in fix control; do
        ~/buster-fast-bench/exclusive.sh "$D/scripts/e2-one.sh" "$unit" "$tree" > /dev/null 2>> "$D/logs/queue.lock.txt"
    done
done
echo "e2 done $(date -Is)" >> "$D/logs/chain.txt"

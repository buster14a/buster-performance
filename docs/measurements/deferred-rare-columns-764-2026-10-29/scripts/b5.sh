#!/bin/bash
# Campaign B5 (#764): A2's 43 units, each tree by its rule on up to 8 lanes (no --every-lane) against one lane in the same
# process, five rounds, 22 jobs a lock hold, 30 s apart, into logs/B5.txt (record #769's campaign B4). Arguments: TREE...
. ~/buster-fast-bench/claude-764/scripts/env.sh
runs=""
for tree in "$@"; do
    runs="$runs $tree:8"
done
"$D/scripts/make-jobs.sh" "$D/scripts/b5.jobs" $runs
"$D/scripts/queue.sh" scripts/b5.jobs logs/B5.txt 1 0 5 22 30
echo "b5 done $(date -Is)" >> "$D/logs/chain.txt"

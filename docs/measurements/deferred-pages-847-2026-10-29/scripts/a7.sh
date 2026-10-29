#!/bin/bash
# Campaign A7 (#847): the lane rule's grid for the claim tree as it is (a unit below the size threshold in huge pages
# that its lanes claim, a large one in base pages where more than one lane reads), A2's 43 units on 2, 3, 4 and 8 lanes
# with every lane (each process also reads the unit on one lane), five rounds, 11 jobs a lock hold, 30 s apart, into
# logs/A7.txt, cold (a process per reading's lanes). Arguments: TREE.
. ~/buster-fast-bench/claude-764/scripts/env.sh
tree="$1"
"$D/scripts/make-jobs.sh" "$D/scripts/a7.jobs" "$tree:2:every" "$tree:3:every" "$tree:4:every" "$tree:8:every"
"$D/scripts/queue847.sh" scripts/a7.jobs logs/A7.txt 1 0 5 11 30
echo "a7 done $(date -Is)" >> "$D/logs/chain.txt"

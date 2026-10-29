#!/bin/bash
# Campaign A5 (#764): A2's 43 units, the chosen tree on 2, 3, 4 and 8 lanes with every lane, beside the base-page
# control and main on 8 lanes, five rounds, 11 jobs a lock hold, 30 s apart, into logs/A5.txt. Arguments: CHOSEN CONTROL
# MAIN (tree names).
. ~/buster-fast-bench/claude-764/scripts/env.sh
chosen="$1"
control="$2"
main="$3"
runs="$chosen:2:every $chosen:3:every $chosen:4:every $chosen:8:every $control:8:every $main:8:every"
if [ "$chosen" = "$control" ]; then
    runs="$chosen:2:every $chosen:3:every $chosen:4:every $chosen:8:every $main:8:every"
fi
"$D/scripts/make-jobs.sh" "$D/scripts/a5.jobs" $runs
"$D/scripts/queue.sh" scripts/a5.jobs logs/A5.txt 1 0 5 11 30
echo "a5 done $(date -Is)" >> "$D/logs/chain.txt"

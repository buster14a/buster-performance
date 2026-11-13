#!/bin/bash
# Runs QUEUE's lines in order, each one lock hold (lock.sh); start, end and status to results/queue.txt.
# Run detached: setsid nohup ./queue.sh QUEUE > logs/queue-NAME.log 2>&1 < /dev/null &
set -u
d=$HOME/buster-fast-bench/2559-release-claude
queue=$1
echo $$ > "$d/$(basename "$queue").pid"
while IFS= read -r line; do
    [ -n "$line" ] || continue
    case $line in \#*) continue ;; esac
    start=$(date -u +%FT%TZ)
    eval "$d/scripts/lock.sh $line"
    rc=$?
    printf '%s\t%s\trc=%s\t%s\n' "$start" "$(date -u +%FT%TZ)" "$rc" "$line" >> "$d/results/queue.txt"
done < "$queue"
echo "done $(basename "$queue")" >> "$d/results/queue.txt"

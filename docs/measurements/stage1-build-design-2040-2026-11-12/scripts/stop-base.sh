#!/bin/bash
# Ends the baseline queue once the checker's third rebuild is recorded: the other scenarios keep two rounds.
d=$HOME/buster-fast-bench/2040-claude
until grep -q '^checker src 3 ' "$d/results/base.txt" 2> /dev/null; do sleep 5; done
kill "$(cat "$d/queue-base.pid")"
echo "stopped after the checker's third round" >> "$d/logs/queue-base.out"

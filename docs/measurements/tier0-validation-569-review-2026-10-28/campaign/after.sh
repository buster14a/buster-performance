#!/usr/bin/env bash
# Runs queue2.sh once queue.sh (its PID in queue.pid) has ended.
D=$HOME/buster-fast-bench/validate-569-claude
echo $$ > "$D/after.pid"
while kill -0 "$(cat "$D/queue.pid")" 2>/dev/null; do sleep 15; done
exec "$D/campaign/queue2.sh"

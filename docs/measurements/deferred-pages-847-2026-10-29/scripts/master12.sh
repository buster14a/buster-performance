#!/bin/bash
# #847: after master11 (its PID in logs/master11.pid), E2 on four units whose lanes raced in main and two that didn't,
# then source order's instructions (soi847.sh, one lock hold) of the claim tree, #791's head and main.
# Arguments: TREE MAIN HEAD.
. ~/buster-fast-bench/claude-764/scripts/env.sh
echo $$ > "$D/logs/master12.pid"
tree="$1"
main="$2"
head="$3"
while kill -0 "$(cat "$D/logs/master11.pid")" 2> /dev/null; do
    sleep 30
done
"$D/scripts/e2.sh" "$tree" "$main" b16x77 h16x77 l16x38f384 h16x154 h16x10 l16x19f192
~/buster-fast-bench/exclusive.sh "$D/scripts/soi847.sh" "$tree" "$head" "$main" > /dev/null 2>> "$D/logs/queue.lock.txt"
echo "master12 done $(date -Is)" >> "$D/logs/chain.txt"

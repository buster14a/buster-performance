#!/bin/bash
# #847: after master12 (its PID in logs/master12.pid), campaign M7 (the two mains), then campaign A7 (the claim tree's
# lane grid). Arguments: TREE MAIN OLD.
. ~/buster-fast-bench/claude-764/scripts/env.sh
echo $$ > "$D/logs/master13.pid"
tree="$1"
main="$2"
old="$3"
while kill -0 "$(cat "$D/logs/master12.pid")" 2> /dev/null; do
    sleep 30
done
"$D/scripts/m7.sh" "$main" "$old"
"$D/scripts/a7.sh" "$tree"
echo "master13 done $(date -Is)" >> "$D/logs/chain.txt"

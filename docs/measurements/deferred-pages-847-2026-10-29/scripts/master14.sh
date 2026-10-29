#!/bin/bash
# #847: after master13 (its PID in logs/master13.pid), test-checker-corpus --deferred 8 of the claim tree on
# c-testsuite and sqlite3.c (corpus.sh, a lock hold each). Arguments: TREE.
. ~/buster-fast-bench/claude-764/scripts/env.sh
echo $$ > "$D/logs/master14.pid"
tree="$1"
while kill -0 "$(cat "$D/logs/master13.pid")" 2> /dev/null; do
    sleep 30
done
"$D/scripts/corpus.sh" "$tree"
echo "master14 done $(date -Is)" >> "$D/logs/chain.txt"

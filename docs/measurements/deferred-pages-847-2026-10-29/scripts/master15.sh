#!/bin/bash
# #847: after master14 (its PID in logs/master14.pid), build TREE, run its test-checker-deferred (a lock hold), then
# campaign B8. Arguments: TREE PREVIOUS MAIN HEAD.
. ~/buster-fast-bench/claude-764/scripts/env.sh
echo $$ > "$D/logs/master15.pid"
tree="$1"
while kill -0 "$(cat "$D/logs/master14.pid")" 2> /dev/null; do
    sleep 30
done
"$D/scripts/build.sh" "$tree"
if [ ! -x "$D/trees/$tree/build/compiler" ]; then
    echo "master15: $tree has no build $(date -Is)" >> "$D/logs/chain.txt"
    exit 1
fi
"$D/scripts/tests.sh" "$tree"
if ! tail -1 "$D/logs/tests-$tree.txt" | grep -q "^exit=0 "; then
    echo "master15: $tree's tests failed $(date -Is)" >> "$D/logs/chain.txt"
    exit 1
fi
"$D/scripts/b8.sh" "$@"
echo "master15 done $(date -Is)" >> "$D/logs/chain.txt"

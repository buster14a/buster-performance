#!/bin/bash
# #764's second chain, on the PR's head: waits for master1c (its PID, the argument), builds head-3b87d0c9, runs its
# test-checker-deferred (a lock hold), then campaign A5 (A2's 43 units: head-3b87d0c9 on 2, 3, 4 and 8 lanes with every lane,
# beside the base-page control, PR #791's first head, and main on 8 lanes, five rounds).
. ~/buster-fast-bench/claude-764/scripts/env.sh
while kill -0 "$1" 2>/dev/null; do sleep 10; done
"$D/scripts/build.sh" head-3b87d0c9
if [ ! -x "$D/trees/head-3b87d0c9/build/compiler" ]; then
    echo "master2b: head-3b87d0c9 has no build $(date -Is)" >> "$D/logs/chain.txt"
    exit 1
fi
"$D/scripts/tests.sh" head-3b87d0c9
if ! tail -1 "$D/logs/tests-head-3b87d0c9.txt" | grep -q "^exit=0 "; then
    echo "master2b: head-3b87d0c9's tests failed $(date -Is)" >> "$D/logs/chain.txt"
    exit 1
fi
"$D/scripts/a5.sh" head-3b87d0c9 pr791-561e5f1c main-bc11fddb
echo "master2b done $(date -Is)" >> "$D/logs/chain.txt"

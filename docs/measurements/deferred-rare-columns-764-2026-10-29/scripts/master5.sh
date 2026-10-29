#!/bin/bash
# #764's fifth chain, on the refitted rule: waits for master4 (its PID, the argument), builds head-62142bec, runs its
# test-checker-deferred (a lock hold), then campaign B5 (each tree by its rule) against main.
. ~/buster-fast-bench/claude-764/scripts/env.sh
while kill -0 "$1" 2>/dev/null; do sleep 10; done
"$D/scripts/build.sh" head-62142bec
if [ ! -x "$D/trees/head-62142bec/build/compiler" ]; then
    echo "master5: head-62142bec has no build $(date -Is)" >> "$D/logs/chain.txt"
    exit 1
fi
"$D/scripts/tests.sh" head-62142bec
if ! tail -1 "$D/logs/tests-head-62142bec.txt" | grep -q "^exit=0 "; then
    echo "master5: head-62142bec's tests failed $(date -Is)" >> "$D/logs/chain.txt"
    exit 1
fi
"$D/scripts/b5.sh" head-62142bec main-bc11fddb
echo "master5 done $(date -Is)" >> "$D/logs/chain.txt"

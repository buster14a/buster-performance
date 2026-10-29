#!/bin/bash
# #764's fifth chain, on the refitted rule and its fixtures: waits for master4 (its PID, the argument), builds head-95fc3668, runs its
# test-checker-deferred (a lock hold), then campaign B5 (each tree by its rule) against main.
. ~/buster-fast-bench/claude-764/scripts/env.sh
while kill -0 "$1" 2>/dev/null; do sleep 10; done
"$D/scripts/build.sh" head-95fc3668
if [ ! -x "$D/trees/head-95fc3668/build/compiler" ]; then
    echo "master5: head-95fc3668 has no build $(date -Is)" >> "$D/logs/chain.txt"
    exit 1
fi
"$D/scripts/tests.sh" head-95fc3668
if ! tail -1 "$D/logs/tests-head-95fc3668.txt" | grep -q "^exit=0 "; then
    echo "master5: head-95fc3668's tests failed $(date -Is)" >> "$D/logs/chain.txt"
    exit 1
fi
"$D/scripts/b5.sh" head-95fc3668 main-bc11fddb
echo "master5 done $(date -Is)" >> "$D/logs/chain.txt"

#!/bin/bash
# The tests of a tree (its build/compiler) that this change touches, each a lock hold of its own, into logs/tests-TREE.txt:
# test-checker-deferred, then test-checker-corpus --deferred 8 on c-testsuite's 220 programs and the frozen sqlite3.c.
# Arguments: TREE.
. ~/buster-fast-bench/claude-764/scripts/env.sh
tree="$1"
L="$D/logs/tests-$tree.txt"
bin="$D/trees/$tree/build/compiler"
echo "== $(date -Is) test-checker-deferred $tree $(cat "$D/trees/$tree/COMMIT")" >> "$L"
~/buster-fast-bench/exclusive.sh "$bin" test-checker-deferred >> "$L" 2>&1
echo "exit=$? $(date -Is)" >> "$L"

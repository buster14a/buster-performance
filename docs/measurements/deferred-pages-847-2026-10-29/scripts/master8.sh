#!/bin/bash
# #847's first chain: builds TREE (the first argument, already under trees/), runs its test-checker-deferred (a lock
# hold), then campaign B6 against main-bc11fddb.
. ~/buster-fast-bench/claude-764/scripts/env.sh
tree="$1"
"$D/scripts/build.sh" "$tree"
if [ ! -x "$D/trees/$tree/build/compiler" ]; then
    echo "master8: $tree has no build $(date -Is)" >> "$D/logs/chain.txt"
    exit 1
fi
"$D/scripts/tests.sh" "$tree"
if ! tail -1 "$D/logs/tests-$tree.txt" | grep -q "^exit=0 "; then
    echo "master8: $tree's tests failed $(date -Is)" >> "$D/logs/chain.txt"
    exit 1
fi
"$D/scripts/b6.sh" "$tree" main-bc11fddb
echo "master8 done $(date -Is)" >> "$D/logs/chain.txt"

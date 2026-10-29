#!/bin/bash
# #847's second chain: builds what isn't built of TREE (the claims), MAIN (main as the tree has it) and HEAD (#791's
# head), a lock hold each, runs TREE's test-checker-deferred (a lock hold), then campaign B7 against the fault-in tree
# FAULT, MAIN and HEAD, then master9's region diagnostic (a lock hold). Arguments: TREE FAULT MAIN HEAD.
. ~/buster-fast-bench/claude-764/scripts/env.sh
echo $$ > "$D/logs/master11.pid"
tree="$1"
fault="$2"
main="$3"
head="$4"
for t in "$tree" "$main" "$head"; do
    if [ ! -x "$D/trees/$t/build/compiler" ]; then
        "$D/scripts/build.sh" "$t"
    fi
    if [ ! -x "$D/trees/$t/build/compiler" ]; then
        echo "master11: $t has no build $(date -Is)" >> "$D/logs/chain.txt"
        exit 1
    fi
done
"$D/scripts/tests.sh" "$tree"
if ! tail -1 "$D/logs/tests-$tree.txt" | grep -q "^exit=0 "; then
    echo "master11: $tree's tests failed $(date -Is)" >> "$D/logs/chain.txt"
    exit 1
fi
"$D/scripts/b7.sh" "$tree" "$fault" "$main" "$head"
if [ ! -x "$D/trees/diag847/build/compiler" ]; then
    "$D/scripts/build.sh" diag847
fi
~/buster-fast-bench/exclusive.sh "$D/scripts/diag847.sh" 00204 h16x10 h16x19 l16x19f192 l16x10f384 l8x38f384 d2x1f384s288 l16x19f384 x16x19 d2x1f480s240 > /dev/null 2>> "$D/logs/queue.lock.txt"
echo "master11 done $(date -Is)" >> "$D/logs/chain.txt"

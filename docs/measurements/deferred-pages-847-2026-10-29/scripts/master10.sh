#!/bin/bash
# #847's second chain: builds TREE (the first argument, already under trees/), runs its test-checker-deferred (a lock
# hold), then campaign B7 against the fault-in tree FAULT and main MAIN, then master9's region diagnostic (a lock hold).
# Arguments: TREE FAULT MAIN.
. ~/buster-fast-bench/claude-764/scripts/env.sh
echo $$ > "$D/logs/master10.pid"
tree="$1"
fault="$2"
main="$3"
"$D/scripts/build.sh" "$tree"
if [ ! -x "$D/trees/$tree/build/compiler" ]; then
    echo "master10: $tree has no build $(date -Is)" >> "$D/logs/chain.txt"
    exit 1
fi
"$D/scripts/tests.sh" "$tree"
if ! tail -1 "$D/logs/tests-$tree.txt" | grep -q "^exit=0 "; then
    echo "master10: $tree's tests failed $(date -Is)" >> "$D/logs/chain.txt"
    exit 1
fi
"$D/scripts/b7.sh" "$tree" "$fault" "$main"
if [ ! -x "$D/trees/diag847/build/compiler" ]; then
    "$D/scripts/build.sh" diag847
fi
~/buster-fast-bench/exclusive.sh "$D/scripts/diag847.sh" 00204 h16x10 h16x19 l16x19f192 l16x10f384 l8x38f384 d2x1f384s288 l16x19f384 x16x19 d2x1f480s240 > /dev/null 2>> "$D/logs/queue.lock.txt"
echo "master10 done $(date -Is)" >> "$D/logs/chain.txt"

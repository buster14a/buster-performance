#!/usr/bin/env bash
# Simple invocations from templates (#117): main 205ef0c against the branch claude/117-lean-engine at 3c98454 (the PR's
# head, main merged). Both trees built, then benchmark-preprocessor --history-cost --only scalar (the deferred kernel,
# which the templates take) by turns, four rounds on sqlite3.c and three on main.c; --only vectorized (the history
# recorded, which takes the old paths) three rounds on sqlite3.c; then -E, parse and -fsyntax-only (the checker) of
# sqlite3.c as whole processes (time-runs under ab). Every run takes the lock on its own.
here="$HOME/buster-fast-bench/pp-117-claude"
cd "$here"
. "$here/args.sh"
# main-205ef0c was built by a first start of this queue, stopped before it measured anything.
for tree in cand-3c98454; do
    ./build.sh $tree > results/build19-$tree.txt 2>&1
done
for round in 1 2 3 4; do
    for tree in main-205ef0c cand-3c98454; do
        ./bench.sh $tree sqlite --history-cost --only scalar > results/ab19-deferred-sqlite-$tree-$round.txt 2>&1
    done
done
for round in 1 2 3; do
    for tree in main-205ef0c cand-3c98454; do
        ./bench.sh $tree main --history-cost --only scalar > results/ab19-deferred-main-$tree-$round.txt 2>&1
    done
done
for round in 1 2 3; do
    for tree in main-205ef0c cand-3c98454; do
        ./bench.sh $tree sqlite --only vectorized > results/ab19-recorded-sqlite-$tree-$round.txt 2>&1
    done
done
"$here/cand-3c98454/build/compiler" ab --rounds 3 --cpu 2 --lock "$here/locked.sh" "$here/main-205ef0c" "$here/cand-3c98454" \
    -- time-runs --runs 21 --list -E "${sqlite[@]}" -o /dev/null --list parse -fsyntax-only "${sqlite[@]}" --list -fsyntax-only "${sqlite[@]}" \
    > results/drivers19-sqlite.txt 2>&1
echo done > results/queue19.done

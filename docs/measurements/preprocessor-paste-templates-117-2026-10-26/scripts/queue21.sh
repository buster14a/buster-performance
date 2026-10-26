#!/usr/bin/env bash
# Templates for ## and # (#117): main at MAIN against the PR's head at CAND (main merged). Both trees built, then
# benchmark-preprocessor --history-cost --only scalar (the deferred kernel, which the templates take) by turns, four
# rounds on sqlite3.c and three on main.c; --only vectorized (the history recorded, which takes the old paths) three
# rounds on sqlite3.c; then -E, parse and -fsyntax-only (the checker) of sqlite3.c as whole processes (time-runs under
# ab). Every run takes the lock on its own.
set -u
main_tree=$1
cand_tree=$2
here="$HOME/buster-fast-bench/pp-117-templates"
cd "$here"
. "$here/args.sh"
mkdir -p results
for tree in "$main_tree" "$cand_tree"; do
    ./build.sh $tree > results/build21-$tree.txt 2>&1
done
for round in 1 2 3 4; do
    for tree in "$main_tree" "$cand_tree"; do
        ./bench.sh $tree sqlite --history-cost --only scalar > results/ab21-deferred-sqlite-$tree-$round.txt 2>&1
    done
done
for round in 1 2 3; do
    for tree in "$main_tree" "$cand_tree"; do
        ./bench.sh $tree main --history-cost --only scalar > results/ab21-deferred-main-$tree-$round.txt 2>&1
    done
done
for round in 1 2 3; do
    for tree in "$main_tree" "$cand_tree"; do
        ./bench.sh $tree sqlite --only vectorized > results/ab21-recorded-sqlite-$tree-$round.txt 2>&1
    done
done
"$here/$cand_tree/build/compiler" ab --rounds 3 --cpu 2 --lock "$here/locked.sh" "$here/$main_tree" "$here/$cand_tree" \
    -- time-runs --runs 21 --list -E "${sqlite[@]}" -o /dev/null --list parse -fsyntax-only "${sqlite[@]}" --list -fsyntax-only "${sqlite[@]}" \
    > results/drivers21-sqlite.txt 2>&1
echo done > results/queue21.done

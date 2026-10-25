#!/usr/bin/env bash
# Line ends counted by page (#117): main 4f4a0bf against the branch's a1f8ddf (926cc3e, the fix that gives units the pages, and whole blocks counted by their newlines). The candidate built (main was in queue15), then
# benchmark-preprocessor --only vectorized by turns, four rounds on sqlite3.c and three on main.c (the main loop's
# __LINE__ lookups against the directive tables' counting), then -E and parse of sqlite3.c as whole processes (time-runs
# under ab). Every run takes the lock on its own.
here="$HOME/buster-fast-bench/pp-117-claude"
cd "$here"
. "$here/args.sh"
for tree in cand-a1f8ddf; do
    ./build.sh $tree > results/build17-$tree.txt 2>&1
done
for round in 1 2 3 4; do
    for tree in main-4f4a0bf cand-a1f8ddf; do
        ./bench.sh $tree sqlite --only vectorized > results/ab17-sqlite-$tree-$round.txt 2>&1
    done
done
for round in 1 2 3; do
    for tree in main-4f4a0bf cand-a1f8ddf; do
        ./bench.sh $tree main --only vectorized > results/ab17-main-$tree-$round.txt 2>&1
    done
done
"$here/cand-a1f8ddf/build/compiler" ab --rounds 3 --cpu 2 --lock "$here/locked.sh" "$here/main-4f4a0bf" "$here/cand-a1f8ddf" \
    -- time-runs --runs 21 --list -E "${sqlite[@]}" -o /dev/null --list parse -fsyntax-only "${sqlite[@]}" \
    > results/drivers17-sqlite.txt 2>&1
echo done > results/queue17.done

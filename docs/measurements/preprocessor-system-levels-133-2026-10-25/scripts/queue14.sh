#!/usr/bin/env bash
# The history replay's last steps (#117, #133): #412's head 9d16823 and the system levels' branch 4ef0652 by turns in
# the preprocessor's benchmark (both record the history there: the runs' cost in the main loop); then whole drivers, a
# fresh process each run (time-runs under ab), on sqlite3.c: -E, parse and the checker's -fsyntax-only. Main 7c428ce
# records the history in all three, #412's head defers it in -E and parse, and the branch in the checker too. Every run
# takes the lock on its own.
here="$HOME/buster-fast-bench/pp-117-claude"
cd "$here"
. "$here/args.sh"
for round in 1 2 3 4; do
    for tree in cand-9d16823 cand-4ef0652; do
        ./bench.sh $tree sqlite --only vectorized > results/ab14-sqlite-$tree-$round.txt 2>&1
    done
done
"$here/cand-4ef0652/build/compiler" ab --rounds 5 --cpu 2 --lock "$here/locked.sh" "$here/main-7c428ce" "$here/cand-9d16823" "$here/cand-4ef0652" \
    -- time-runs --runs 21 --list -E "${sqlite[@]}" -o /dev/null --list parse -fsyntax-only "${sqlite[@]}" --list -fsyntax-only "${sqlite[@]}" \
    > results/drivers14-sqlite.txt 2>&1
echo done > results/queue14.done

#!/usr/bin/env bash
# History replay (#117): main 7c428ce (with #410) against the replay's commit a964539. First both recording the history,
# as the checker's driver does (interleaved rounds, the main loop's cost of the replay's bookkeeping); then the replay's
# --history-cost (recorded against deferred, as -E and parse run it); then whole drivers, a fresh process each run
# (time-runs under ab): -E and parse on sqlite3.c, main's recording against the replay's deferring. Every run takes the
# lock on its own.
here="$HOME/buster-fast-bench/pp-117-claude"
cd "$here"
. "$here/args.sh"
for round in 1 2 3 4; do
    for tree in main-7c428ce cand-a964539; do
        ./bench.sh $tree sqlite --only vectorized > results/ab13-sqlite-$tree-$round.txt 2>&1
    done
done
for round in 1 2 3; do
    for tree in main-7c428ce cand-a964539; do
        ./bench.sh $tree main --only vectorized > results/ab13-main-$tree-$round.txt 2>&1
    done
done
for round in 1 2 3 4; do
    ./bench.sh cand-a964539 sqlite --history-cost > results/hc13-sqlite-$round.txt 2>&1
done
for round in 1 2 3; do
    ./bench.sh cand-a964539 main --history-cost > results/hc13-main-$round.txt 2>&1
done
"$here/cand-a964539/build/compiler" ab --rounds 5 --cpu 2 --lock "$here/locked.sh" "$here/main-7c428ce" "$here/cand-a964539" \
    -- time-runs --runs 21 --list -E "${sqlite[@]}" -o /dev/null --list parse -fsyntax-only "${sqlite[@]}" \
    > results/drivers13-sqlite.txt 2>&1
echo done > results/queue13.done

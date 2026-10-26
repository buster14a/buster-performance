#!/usr/bin/env bash
# The checker's integer literals written straight into their result (literal.patch) on main and on #473's head, against
# both as they are: built, then -fsyntax-only of sqlite3.c by perf stat (user and kernel cycles) and as whole processes
# (time-runs under ab). Every run takes the lock on its own.
set -u
here="$HOME/buster-fast-bench/pp-117-templates"
cd "$here"
. "$here/args.sh"
for tree in main-dd982df cand-5d2c540; do
    rm -rf $tree-lit; cp -r $tree $tree-lit; rm -rf $tree-lit/build
    (cd $tree-lit && patch -p1 < "$here/literal.patch") > results/patch23-$tree.txt 2>&1
    ./build.sh $tree-lit > results/build23-$tree-lit.txt 2>&1
done
trees="main-dd982df cand-5d2c540 main-dd982df-lit cand-5d2c540-lit"
for round in 1 2; do
    for tree in $trees; do
        "$here/locked.sh" taskset -c 2 perf stat -r 21 -x, -e cycles:u,cycles:k,instructions:u,page-faults,task-clock "$here/$tree/build/compiler" -fsyntax-only "${sqlite[@]}" \
            > /dev/null 2> results/stat23-$tree-$round.txt
    done
done
"$here/cand-5d2c540/build/compiler" ab --rounds 3 --cpu 2 --lock "$here/locked.sh" $(for t in $trees; do echo "$here/$t"; done) \
    -- time-runs --runs 21 --list -fsyntax-only "${sqlite[@]}" > results/drivers23-sqlite.txt 2>&1
echo done > results/queue23.done

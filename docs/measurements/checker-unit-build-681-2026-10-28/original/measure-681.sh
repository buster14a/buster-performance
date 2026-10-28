#!/usr/bin/env bash
# #681 on the 9700X: build.sh on main and on the branch, twice each, alternating (CI's way: BUSTER_DEBUG_INFO=0, CPUs
# 0-7), then -c of the frozen sqlite3.c by both builds in rotation (time-runs, CPU 2). Every run takes the lock alone.
set -e
dir=$HOME/buster-fast-bench/ci-681-claude
cd "$dir"
if [ ! -d main ]; then git clone -q https://github.com/buster14a/buster main; fi
git -C main fetch -q origin 716c980d7c2a1f0e1f5d6e1a7e8b0d2e1d4c3b2a 2>/dev/null || true
git -C main fetch -q origin main claude/681-checker-unit-build
git -C main checkout -q --detach origin/main~0 2>/dev/null || true
git -C main checkout -q --detach "$(git -C main rev-parse origin/claude/681-checker-unit-build~1)"
if [ ! -d head ]; then git -C main worktree add -q --detach ../head origin/claude/681-checker-unit-build; fi
git -C head checkout -q --detach origin/claude/681-checker-unit-build
echo "main $(git -C main rev-parse --short HEAD) head $(git -C head rev-parse --short HEAD)"
export EXCLUSIVE_OWNER=ci-681-claude EXCLUSIVE_TITLE="CI performance optimization: #681 build times" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/681
lock=$HOME/buster-fast-bench/exclusive.sh
for round in 1 2; do
    for tree in main head; do
        report="$(cd "$dir/$tree" && BUSTER_DEBUG_INFO=0 "$lock" taskset -c 0-7 ./build.sh 2>&1 | grep 'sources compiled')"
        echo "round $round $tree: $report"
        cp "$dir/$tree/build/compiler" "$dir/compiler-$tree"
    done
done
sqlite=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
"$lock" taskset -c 2 "$dir/compiler-main" time-runs --runs 21 --warmups 3 --build main "$dir/compiler-main" --build head "$dir/compiler-head" \
    --list -c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$sqlite" "$sqlite/sqlite3.c" -o "$dir/sqlite3.o"
echo "measure-681 done"

#!/usr/bin/env bash
set -euo pipefail
cd "$HOME/buster-fast-bench/1219-codex"
export EXCLUSIVE_OWNER=codex-1219 EXCLUSIVE_TITLE='Issue 1219 current-head qualification' EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/1419
while [ ! -f affine-recheck.done ]; do sleep 2; done
test "$(cat affine-recheck.done)" = 0
for suite in test-tier1-emit test-tier1-pipeline; do
    args=()
    [ "$suite" != test-tier1-pipeline ] || args=(--cross-check)
    (cd affine && "$HOME/buster-fast-bench/exclusive.sh" ./build/compiler "$suite" "${args[@]}") > "affine-$suite.log" 2>&1
    printf '%s 0\n' "$suite" >> affine-qualification.status
done
"$HOME/buster-fast-bench/exclusive.sh" taskset -c 2 affine/build/compiler measure-tier1-programs --runs 11 --warmups 1 --clang /usr/bin/clang --sqlite "$PWD/corpus/sqlite" --speedtest "$PWD/inputs/st" --lua "$PWD/inputs/lua/lua-5.4.8/src" --scripts "$PWD/inputs/lua" --directory /dev/shm --keep > affine-runtime.log 2>&1
printf 'runtime 0\n' >> affine-qualification.status
"$HOME/buster-fast-bench/exclusive.sh" taskset -c 2 base/build/compiler time-runs --runs 11 --warmups 1 --build baseline "$PWD/base/build/compiler" --build candidate "$PWD/affine/build/compiler" --list --tier1 -fno-asynchronous-unwind-tables -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -I"$PWD/corpus/sqlite" -c "$PWD/corpus/sqlite/sqlite3.c" -o "$PWD/results/timing/affine-compile.o" > affine-compile-time.log 2>&1
printf 'compile 0\n' >> affine-qualification.status
for build in base affine; do
    (cd "$build" && "$HOME/buster-fast-bench/exclusive.sh" taskset -c 2 ./build/compiler benchmark-tier1-select-source --only select -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -I"$HOME/buster-fast-bench/1219-codex/corpus/sqlite" "$HOME/buster-fast-bench/1219-codex/corpus/sqlite/sqlite3.c") > "affine-selection-$build.log" 2>&1
done
touch affine-qualification.done

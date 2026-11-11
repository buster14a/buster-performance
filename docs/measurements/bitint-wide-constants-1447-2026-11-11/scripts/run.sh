#!/usr/bin/env bash
# #1447 C1: _BitInt constants past 128 bits. -fsyntax-only of sqlite3.c and main.c, main (base) against the PR (head),
# both Release native builds; -c objects compared; whole processes timed by time-runs under ab, the lock per run.
set -u
cd "$(dirname "$0")"
export EXCLUSIVE_OWNER=claude-c1
export EXCLUSIVE_TITLE="C1: _BitInt constants wider than 128 bits (#1447)"
export EXCLUSIVE_LINK=https://claude.ai/code/session_01Egbxndo1Pv4oSXmcci38Vt
BASE=${BASE:-d43c37e}
HEAD_REF=${HEAD_REF:-claude/bitint-wide-constants}
lock=$HOME/buster-fast-bench/exclusive.sh
export TMPDIR=$PWD/tmp
mkdir -p "$TMPDIR" out
for t in base head; do
    [ -d $t ] || git clone -q https://github.com/buster14a/buster $t
done
git -C base fetch -q origin main && git -C base checkout -q --detach "$BASE"
git -C head fetch -q origin "$HEAD_REF" && git -C head checkout -q --detach FETCH_HEAD
git -C base log --oneline -1; git -C head log --oneline -1
for t in base head; do
    "$lock" bash -c "cd $t && BUSTER_DEBUG_INFO=0 ./build.sh" > "build-$t.log" 2>&1 || echo "build $t failed"
done
sq=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
sqlite=(-DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$sq" "$sq/sqlite3.c")
main=(-march=native -I"$PWD/head/src" -fwrapv -funsigned-char "$PWD/head/src/buster/compiler/main.c")
for t in base head; do
    "$lock" taskset -c 2 "./$t/build/compiler" -c "${sqlite[@]}" -o "out/$t-sqlite.o" || echo "compile $t sqlite failed"
    "$lock" taskset -c 2 "./$t/build/compiler" -c "${main[@]}" -o "out/$t-main.o" || echo "compile $t main failed"
done
cmp out/base-sqlite.o out/head-sqlite.o && echo "sqlite object: base == head"
cmp out/base-main.o out/head-main.o && echo "main object: base == head"
./head/build/compiler ab --rounds 7 --cpu 2 --lock "$lock" ./head/build/compiler \
    -- time-runs --runs 5 --build base "$PWD/base/build/compiler" --build head "$PWD/head/build/compiler" --list -fsyntax-only "${sqlite[@]}" > ab-sqlite.log 2>&1 || echo "ab sqlite failed"
./head/build/compiler ab --rounds 7 --cpu 2 --lock "$lock" ./head/build/compiler \
    -- time-runs --runs 5 --build base "$PWD/base/build/compiler" --build head "$PWD/head/build/compiler" --list -fsyntax-only "${main[@]}" > ab-main.log 2>&1 || echo "ab main failed"
echo done

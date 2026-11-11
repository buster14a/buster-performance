#!/bin/bash
# C4b #2326 second A/B: head at 9215ba4d (sugar fields last, builders cold) against base 2d0756cf.
B=~/buster-fast-bench/1447-c4b-claude
export EXCLUSIVE_OWNER=claude-c4b EXCLUSIVE_TITLE="C4b type sugar A/B #2326" EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/2326
(cd $B/head && git fetch -q origin c4b/type-sugar && git checkout -q FETCH_HEAD && git log --oneline -1 && ~/buster-fast-bench/exclusive.sh ./build.sh > build2.log 2>&1; echo "head build exit $?")
cd $B/base
S=~/buster-fast-bench/frontend-baseline-claude/baseline/sqlite3.c
M="-march=native -Isrc -fwrapv -funsigned-char -fno-strict-aliasing src/buster/compiler/main.c"
$B/head/build/compiler ab --rounds 3 --cpu 2 --lock ~/buster-fast-bench/exclusive.sh $B/head/build/compiler \
    -- time-runs --runs 5 --copies 3 --build base $B/base/build/compiler --build head $B/head/build/compiler --build base-again $B/base/build/compiler \
    --list -fsyntax-only $S --list -c $S -o /tmp/c4b-sqlite.o --list -fsyntax-only $M --list -c $M -o /tmp/c4b-main.o
echo "ab exit $?"

#!/bin/bash
# C4b PR #2326 A/B: base 2d0756cf vs head, -fsyntax-only and -c of sqlite3.c and main.c, under the 9700X lock per round.
cd ~/buster-fast-bench/1447-c4b-claude/base
export EXCLUSIVE_OWNER=claude-c4b EXCLUSIVE_TITLE="C4b type sugar A/B #2326" EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/2326
S=~/buster-fast-bench/frontend-baseline-claude/baseline/sqlite3.c
B=~/buster-fast-bench/1447-c4b-claude
M="-march=native -Isrc -fwrapv -funsigned-char -fno-strict-aliasing src/buster/compiler/main.c"
$B/head/build/compiler ab --rounds 3 --cpu 2 --lock ~/buster-fast-bench/exclusive.sh $B/head/build/compiler \
    -- time-runs --runs 5 --copies 3 --build base $B/base/build/compiler --build head $B/head/build/compiler --build base-again $B/base/build/compiler \
    --list -fsyntax-only $S --list -c $S -o /tmp/c4b-sqlite.o --list -fsyntax-only $M --list -c $M -o /tmp/c4b-main.o
echo "ab exit $?"

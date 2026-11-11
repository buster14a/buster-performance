#!/bin/bash
# #1842's 1b A/B: head c4b/1842-padding-sugar against base main a8855682, base-again the floor; each time-runs process
# under the lock, pinned to CPU 2.
B=~/buster-fast-bench/1842-padding-claude
export EXCLUSIVE_OWNER=claude-c4b EXCLUSIVE_TITLE="C4b #1842 1b padding sugar A/B" EXCLUSIVE_LINK=https://claude.ai/code/session_01EgbxnekHxD35FrgfVGaxb1
cd $B/base
S=~/buster-fast-bench/frontend-baseline-claude/baseline/sqlite3.c
M="-march=native -Isrc -fwrapv -funsigned-char -fno-strict-aliasing src/buster/compiler/main.c"
$B/head/build/compiler ab --rounds 3 --cpu 2 --lock ~/buster-fast-bench/exclusive.sh $B/head/build/compiler \
    -- time-runs --runs 5 --copies 3 --build base $B/base/build/compiler --build head $B/head/build/compiler --build base-again $B/base/build/compiler \
    --list -fsyntax-only $S --list -c $S -o /tmp/c4b-1842-sqlite.o --list -fsyntax-only $M --list -c $M -o /tmp/c4b-1842-main.o
echo "ab exit $?"

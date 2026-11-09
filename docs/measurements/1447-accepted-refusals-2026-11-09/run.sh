#!/bin/sh
# One lock hold: time-runs of base (main 4842317c) and head (the four PRs), -fsyntax-only of sqlite3.c and main.c, pinned to CPU 2.
D=~/buster-fast-bench/1447-claude-accepted
cd $D/base
EXCLUSIVE_OWNER=claude-1447-accepted EXCLUSIVE_TITLE="#1447 accepted refusals: base-vs-head -fsyntax-only (one hold)" EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/1902 \
  ~/buster-fast-bench/exclusive.sh taskset -c 2 $D/head/build/compiler time-runs --runs 21 --warmups 3 --build base $D/base/build/compiler --build head $D/head/build/compiler \
  --list -fsyntax-only $D/sqlite3.c --list -fsyntax-only -march=znver5 -Isrc -fwrapv -funsigned-char -fno-strict-aliasing src/buster/compiler/main.c > $D/time-runs.txt 2>&1
echo "rc=$?" >> $D/time-runs.txt

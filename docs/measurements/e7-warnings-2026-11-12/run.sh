#!/bin/bash
# base (8c67a8d6) vs the three heads: -fsyntax-only and -c of sqlite3.c and main.c, one time-runs comparison (Williams
# order) under one hold of the lock, pinned to CPU 2.
D=~/buster-fast-bench/e7-claude
cd $D
export EXCLUSIVE_OWNER=claude-e7 EXCLUSIVE_TITLE='E7: warnings left (#2217 #2218 #2409)' EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/2451
clang -dM -E -march=native -fwrapv -funsigned-char -x c /dev/null > predefines.h
M="-march=native -I$D/base/src -fwrapv -funsigned-char --predefines $D/predefines.h $D/base/src/buster/compiler/main.c"
~/buster-fast-bench/exclusive.sh taskset -c 2 base/build/compiler time-runs --runs 21 --warmups 3 \
  --build base $D/base/build/compiler --build h2217 $D/h2217/build/compiler --build h2218 $D/h2218/build/compiler \
  --build h2409u $D/h2409u/build/compiler \
  --list -fsyntax-only $D/sqlite3.c \
  --list -c -o /dev/null $D/sqlite3.c \
  --list -fsyntax-only $M \
  --list -c -o /dev/null $M
echo "exit $?"

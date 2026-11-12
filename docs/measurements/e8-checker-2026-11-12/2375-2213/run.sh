#!/bin/bash
# base (8c67a8d6) vs #2375 (casts of records) and #2213 (-Welaborated-enum-base): -fsyntax-only and -c of sqlite3.c and
# main.c, one time-runs comparison (Williams order) under one hold of the lock, pinned to CPU 2.
D=~/buster-fast-bench/2375-claude-e8
cd $D
export EXCLUSIVE_OWNER=claude-e8 EXCLUSIVE_TITLE='E8: record casts and enum bases (#2375, #2213)' EXCLUSIVE_LINK=https://claude.ai/code/session_01EgbxngcM2C2LEUmibuXSqa
clang -dM -E -march=native -fwrapv -funsigned-char -x c /dev/null > predefines.h
M="-march=native -I$D/base/src -fwrapv -funsigned-char --predefines $D/predefines.h $D/base/src/buster/compiler/main.c"
~/buster-fast-bench/exclusive.sh taskset -c 2 base/build/compiler time-runs --runs 21 --warmups 3 \
  --build base $D/base/build/compiler --build h2375 $D/h2375/build/compiler --build h2213 $D/h2213/build/compiler \
  --list -fsyntax-only $D/sqlite3.c \
  --list -c -o /dev/null $D/sqlite3.c \
  --list -fsyntax-only $M \
  --list -c -o /dev/null $M
echo "exit $?"

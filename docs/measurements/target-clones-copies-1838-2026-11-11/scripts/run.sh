#!/bin/bash
# base (684f7d4) vs head (2721ddc, target_clones bodies per version, #1838): -c of sqlite3.c and main.c, units without
# multiversioning, one time-runs comparison (Williams order) under one hold of the 9700X lock, pinned to CPU 2.
D=~/buster-fast-bench/1838-claude-b7
cd $D
export EXCLUSIVE_OWNER=claude-b7 EXCLUSIVE_TITLE='B7: GNU multiversioning (#1838)' EXCLUSIVE_LINK=https://claude.ai/code/session_01EgbxndTVe7u8sFsxbDhPmQ
clang -dM -E -march=native -fwrapv -funsigned-char -x c /dev/null > predefines.h
~/buster-fast-bench/exclusive.sh taskset -c 2 base/build/compiler time-runs --runs 21 --warmups 3 \
  --build base $D/base/build/compiler --build head $D/head/build/compiler \
  --list -c -o /dev/null $D/sqlite3.c \
  --list -c -o /dev/null -march=native -I$D/head/src -fwrapv -funsigned-char --predefines $D/predefines.h $D/head/src/buster/compiler/main.c
echo "exit $?"

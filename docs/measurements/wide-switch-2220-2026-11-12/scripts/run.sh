#!/bin/bash
# base (8c67a8d6) vs head (#2220, wide _BitInt switch: case values and conflicts through check_program_case_compare):
# -fsyntax-only and -c of sqlite3.c and main.c, one time-runs comparison (Williams order) under one hold of the lock,
# pinned to CPU 2.
D=~/buster-fast-bench/2220-claude-e2
cd $D
export EXCLUSIVE_OWNER=claude-e2 EXCLUSIVE_TITLE='E2: calling convention, ABI and wide types (#2220)' EXCLUSIVE_LINK=https://claude.ai/code/session_01EgbxngLkubh4Z2ro3Q5ZEQ
clang -dM -E -march=native -fwrapv -funsigned-char -x c /dev/null > predefines.h
M="-march=native -I$D/head/src -fwrapv -funsigned-char --predefines $D/predefines.h $D/head/src/buster/compiler/main.c"
~/buster-fast-bench/exclusive.sh taskset -c 2 base/build/compiler time-runs --runs 21 --warmups 3 \
  --build base $D/base/build/compiler --build head $D/head/build/compiler \
  --list -fsyntax-only $D/sqlite3.c \
  --list -c -o /dev/null $D/sqlite3.c \
  --list -fsyntax-only $M \
  --list -c -o /dev/null $M
echo "exit $?"

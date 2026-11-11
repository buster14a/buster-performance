#!/bin/bash
# base (main d43c37e) vs head (claude/1969-default-error-scopes 4023c4ea): -fsyntax-only of sqlite3.c and main.c, valid units,
# one time-runs comparison (Williams order) under one hold of the 9700X lock, pinned to CPU 2.
D=~/buster-fast-bench/1969-claude
cd $D
export EXCLUSIVE_OWNER=claude-c5 EXCLUSIVE_TITLE='C5: rejected units warnings (#1969)' EXCLUSIVE_LINK=https://claude.ai/code/session_01EgbxneBL4rUaGXcmPE1Coj
clang -dM -E -march=native -fwrapv -funsigned-char -x c /dev/null > predefines.h
~/buster-fast-bench/exclusive.sh taskset -c 2 base/build/compiler time-runs --runs 21 --warmups 3 \
  --build base $D/base/build/compiler --build head $D/head/build/compiler \
  --list -fsyntax-only $D/sqlite3.c \
  --list -fsyntax-only -march=native -I$D/head/src -fwrapv -funsigned-char --predefines $D/predefines.h $D/head/src/buster/compiler/main.c
echo "exit $?"

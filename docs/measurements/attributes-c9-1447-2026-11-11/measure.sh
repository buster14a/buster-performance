#!/bin/bash
D=~/buster-fast-bench/1447-claude-c9
cd $D
export EXCLUSIVE_OWNER=claude-1447-c9
export EXCLUSIVE_TITLE="C9: attributes still refused by name (#1447)"
export EXCLUSIVE_LINK=https://claude.ai/code/session_01Egbxng4aKeNZmJe3C1fFZf
~/buster-fast-bench/exclusive.sh taskset -c 2 base/build/compiler time-runs --runs 21 --warmups 3 --build base $D/base/build/compiler --build head $D/head/build/compiler \
  --list -fsyntax-only $D/sqlite3.c \
  --list -fsyntax-only -march=znver5 -I$D/base/src -fwrapv -funsigned-char -fno-strict-aliasing $D/base/src/buster/compiler/main.c > times-$1.txt 2>&1
echo TIMES-DONE >> times-$1.txt

#!/bin/bash
# run.sh BASE HEAD LINK: build both under the lock (one hold per build), then -fsyntax-only and -c of sqlite3.c and
# main.c, one time-runs comparison (Williams order) under one hold of the lock, pinned to CPU 2.
D=~/buster-fast-bench/e7b-claude
cd $D
export EXCLUSIVE_OWNER=claude-e7b EXCLUSIVE_TITLE='E7b: warnings left' EXCLUSIVE_LINK=$3
for t in $1 $2; do ~/buster-fast-bench/exclusive.sh $D/build.sh $t; done
clang -dM -E -march=native -fwrapv -funsigned-char -x c /dev/null > predefines.h
M="-march=native -I$D/$1/src -fwrapv -funsigned-char --predefines $D/predefines.h $D/$1/src/buster/compiler/main.c"
~/buster-fast-bench/exclusive.sh taskset -c 2 $1/build/compiler time-runs --runs 21 --warmups 3 \
  --build $1 $D/$1/build/compiler --build $2 $D/$2/build/compiler \
  --list -fsyntax-only $D/sqlite3.c \
  --list -c -o /dev/null $D/sqlite3.c \
  --list -fsyntax-only $M \
  --list -c -o /dev/null $M
echo "exit $?"
echo ALLDONE

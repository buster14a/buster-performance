#!/bin/bash
# run4.sh BASE HEAD LINK: BASE, an identical copy of BASE's binary (the noise floor) and HEAD: -fsyntax-only and -c of
# sqlite3.c and main.c, in one time-runs comparison under one hold of the lock, pinned to CPU 2.
D=~/buster-fast-bench/e7b-claude
cd $D
export EXCLUSIVE_OWNER=claude-e7b EXCLUSIVE_TITLE='E7b: #2451 base vs head' EXCLUSIVE_LINK=$3
cp $D/$1/build/compiler $D/$1-copy-compiler
M="-march=native -I$D/$1/src -fwrapv -funsigned-char --predefines $D/predefines.h $D/$1/src/buster/compiler/main.c"
~/buster-fast-bench/exclusive.sh taskset -c 2 $1/build/compiler time-runs --runs 21 --warmups 3 \
  --build $1 $D/$1/build/compiler --build $1-copy $D/$1-copy-compiler --build $2 $D/$2/build/compiler \
  --list -fsyntax-only $D/sqlite3.c \
  --list -c -o /dev/null $D/sqlite3.c \
  --list -fsyntax-only $M \
  --list -c -o /dev/null $M
echo "exit $?"
echo ALLDONE

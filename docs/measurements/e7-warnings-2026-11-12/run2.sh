#!/bin/bash
# base (8c67a8d6) vs #2218's narrowed head: -fsyntax-only and -c of sqlite3.c and main.c, one time-runs comparison
# (Williams order) under one hold of the lock, pinned to CPU 2.
D=~/buster-fast-bench/e7-claude
cd $D
export EXCLUSIVE_OWNER=claude-e7 EXCLUSIVE_TITLE='E7: warnings left (#2218)' EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/2451
git -C h2218 fetch -q origin e7/2218-out-of-range && git -C h2218 checkout -q "$1" && git -C h2218 log -1 --format='h2218 %H'
~/buster-fast-bench/exclusive.sh $D/build.sh h2218
M="-march=native -I$D/base/src -fwrapv -funsigned-char --predefines $D/predefines.h $D/base/src/buster/compiler/main.c"
~/buster-fast-bench/exclusive.sh taskset -c 2 base/build/compiler time-runs --runs 21 --warmups 3 \
  --build base $D/base/build/compiler --build h2218 $D/h2218/build/compiler \
  --list -fsyntax-only $D/sqlite3.c \
  --list -c -o /dev/null $D/sqlite3.c \
  --list -fsyntax-only $M \
  --list -c -o /dev/null $M
echo "exit $?"
echo ALLDONE

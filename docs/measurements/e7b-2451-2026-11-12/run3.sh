#!/bin/bash
# run3.sh BASE HEAD LINK: the noise floor and the warning's own cost. BASE, an identical copy of BASE's binary and HEAD,
# timed in one time-runs comparison under one hold of the lock, pinned to CPU 2: -fsyntax-only and -c of sqlite3.c, each
# with the warning on (the default) and off.
D=~/buster-fast-bench/e7b-claude
cd $D
export EXCLUSIVE_OWNER=claude-e7b EXCLUSIVE_TITLE='E7b: #2451 noise floor' EXCLUSIVE_LINK=$3
cp $D/$1/build/compiler $D/$1-copy-compiler
OFF=-Wno-tautological-constant-out-of-range-compare
~/buster-fast-bench/exclusive.sh taskset -c 2 $1/build/compiler time-runs --runs 21 --warmups 3 \
  --build $1 $D/$1/build/compiler --build $1-copy $D/$1-copy-compiler --build $2 $D/$2/build/compiler \
  --list -fsyntax-only $D/sqlite3.c \
  --list -fsyntax-only $OFF $D/sqlite3.c \
  --list -c -o /dev/null $D/sqlite3.c \
  --list -c -o /dev/null $OFF $D/sqlite3.c
echo "exit $?"
echo ALLDONE

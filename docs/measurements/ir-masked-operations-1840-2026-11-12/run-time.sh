#!/bin/sh
# Base-vs-head compile time of main.c for #1840 item 5 (E1). HEAD is the argument.
set -e
cd ~/buster-fast-bench/1840-claude-e1
export EXCLUSIVE_OWNER=claude-e1 EXCLUSIVE_TITLE="E1: #1840 masked operations' timing" EXCLUSIVE_LINK=https://claude.ai/code/session_01EgbxndWCrfZ3qeELU4Hd1U
HEAD=$1
for t in base head; do
  if [ ! -d $t ]; then git clone -q https://github.com/buster14a/buster $t; fi
done
(cd base && git fetch -q origin main && git checkout -q b935fa309c44)
(cd head && git fetch -q origin e1/1840-masked-op && git checkout -q $HEAD)
echo "builds start $(date -Is)"
(cd base && ~/buster-fast-bench/exclusive.sh ./build.sh > ../build-base.log 2>&1)
(cd head && ~/buster-fast-bench/exclusive.sh ./build.sh > ../build-head.log 2>&1)
clang -dM -E -march=native -fwrapv -funsigned-char -x c /dev/null > predefines.h
S=$PWD/base/src
echo "time start $(date -Is)"
~/buster-fast-bench/exclusive.sh taskset -c 2 base/build/compiler time-runs --runs 21 --warmups 3 --build base $PWD/base/build/compiler --build head $PWD/head/build/compiler \
  --list -c -o /dev/null -march=native -I$S -fwrapv -funsigned-char --predefines $PWD/predefines.h $S/buster/compiler/main.c \
  --list --tier1 -c -o /dev/null -march=native -I$S -fwrapv -funsigned-char --predefines $PWD/predefines.h $S/buster/compiler/main.c > time.txt 2>&1
echo "time done $(date -Is)"

#!/bin/sh
D=~/buster-fast-bench/2216-claude-d2
cd $D/base
export EXCLUSIVE_OWNER=claude-2216-d2 EXCLUSIVE_TITLE="#2216 D2: lanewise entry room, base vs head" EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/2357
mkdir -p $D/copies
{ uname -a; git -C $D/base rev-parse HEAD; git -C $D/head rev-parse HEAD; } > $D/time-runs.txt
~/buster-fast-bench/exclusive.sh taskset -c 2 ./build/compiler time-runs --runs 20 --warmups 3 --copies 2 --directory $D/copies --build base $D/base/build/compiler --build head $D/head/build/compiler --list -c -march=native -Isrc -fwrapv -funsigned-char --predefines $D/predefines.h src/buster/compiler/main.c -o /tmp/2216-d2-main.o >> $D/time-runs.txt 2>&1
echo tr-done >> $D/time-runs.txt

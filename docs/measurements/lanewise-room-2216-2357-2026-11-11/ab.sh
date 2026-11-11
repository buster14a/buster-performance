#!/bin/sh
D=~/buster-fast-bench/2216-claude-d2
cd $D/base
export EXCLUSIVE_OWNER=claude-2216-d2 EXCLUSIVE_TITLE="#2216 D2: lanewise entry room, base vs head" EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/2357
uname -a > $D/ab.txt; git -C $D/base rev-parse HEAD >> $D/ab.txt; git -C $D/head rev-parse HEAD >> $D/ab.txt
./build/compiler ab --rounds 10 --cpu 2 --lock ~/buster-fast-bench/exclusive.sh $D/base $D/head -- -c -march=native -Isrc -fwrapv -funsigned-char --predefines $D/predefines.h src/buster/compiler/main.c -o /tmp/2216-d2-main.o >> $D/ab.txt 2>&1
echo ab-done >> $D/ab.txt

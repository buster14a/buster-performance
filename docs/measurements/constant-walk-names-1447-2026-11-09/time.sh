#!/bin/bash
D=~/buster-fast-bench/1447-claude-constwalk
cd $D
export EXCLUSIVE_OWNER=claude-1447-constwalk EXCLUSIVE_TITLE="#1447: undeclared names in the constant walk" EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/1864
S=$D/base/src
~/buster-fast-bench/exclusive.sh taskset -c 2 $D/head-compiler time-runs --runs 15 --warmups 2 --build base $D/base-compiler --build head $D/head-compiler --list -fsyntax-only $D/sqlite3.c --list -fsyntax-only -march=znver5 -I$S -fwrapv -funsigned-char -fno-strict-aliasing $S/buster/compiler/main.c > $D/time.txt 2>&1
echo "DONE $?" >> $D/time.txt

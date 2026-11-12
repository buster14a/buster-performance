#!/bin/sh
D=~/buster-fast-bench/1447-claude-e6b; cd $D
export EXCLUSIVE_OWNER=claude-e6b EXCLUSIVE_TITLE="E6b typo parameter measurement" EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/2493
~/buster-fast-bench/exclusive.sh taskset -c 2 ./base/build/compiler time-runs --runs 15 --warmups 2 --build base $D/base/build/compiler --build head $D/head/build/compiler --list -fsyntax-only -march=native -fwrapv -funsigned-char $D/sqlite3.c --list -fsyntax-only -march=native -I$D/head/src -fwrapv -funsigned-char $D/head/src/buster/compiler/main.c > tr.log 2>&1
echo DONE >> tr.log

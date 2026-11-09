#!/bin/bash
D=~/buster-fast-bench/1838-claude
export EXCLUSIVE_OWNER=claude-1838 EXCLUSIVE_TITLE="#1838: GNU function multiversioning by target strings (A/B time-runs)" EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/1897
cd $D/head
./build/compiler ab --rounds 5 --cpu 2 --lock ~/buster-fast-bench/exclusive.sh $D/base $D/head -- time-runs --runs 11 --list -fsyntax-only $D/sqlite3.c --list -fsyntax-only -march=znver5 -I$D/head/src -fwrapv -funsigned-char -fno-strict-aliasing $D/head/src/buster/compiler/main.c > $D/ab3.txt 2>&1
echo "DONE $?" >> $D/ab3.txt

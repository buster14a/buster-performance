#!/bin/bash
set -e
D=~/buster-fast-bench/1838-claude
mkdir -p $D
cd $D
export EXCLUSIVE_OWNER=claude-1838 EXCLUSIVE_TITLE="#1838: GNU function multiversioning by target strings" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/1838
for t in base:cb608c1 head:8dce66d; do n=${t%%:*}; r=${t#*:}
  [ -d $n ] || git clone -q https://github.com/buster14a/buster $n
  (cd $n && git fetch -q origin checker/1838-target-versions-sema main && git checkout -q $r)
  (cd $n && BUSTER_HOST_ARCH=znver5 ~/buster-fast-bench/exclusive.sh ./build.sh > build.log 2>&1)
done
cp ~/buster-fast-bench/refine-claude/inputs/sqlite3.c $D/sqlite3.c
cd $D/head
./build/compiler ab --rounds 20 --cpu 2 --lock ~/buster-fast-bench/exclusive.sh $D/base $D/head -- -fsyntax-only $D/sqlite3.c -- -fsyntax-only -march=znver5 -I$D/head/src -fwrapv -funsigned-char -fno-strict-aliasing $D/head/src/buster/compiler/main.c > $D/ab.txt 2>&1
echo DONE >> $D/ab.txt

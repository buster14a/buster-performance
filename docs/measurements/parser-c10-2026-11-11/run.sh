#!/bin/bash
# Base-vs-head benchmark-parser on main.c for #1867 (package C10). Each build and each run takes the lock alone.
set -u
D=~/buster-fast-bench/1867-claude
export EXCLUSIVE_OWNER=claude-c10 EXCLUSIVE_TITLE="C10: typo correction and parser parity (#1447)" EXCLUSIVE_LINK=https://claude.ai/code/session_01Egbxnd17sRFP76u9bZB3kE
L=~/buster-fast-bench/exclusive.sh
mkdir -p $D && cd $D
for t in base head; do
  [ -d $t ] || git clone -q https://github.com/buster14a/buster $t
done
(cd base && git fetch -q origin main && git checkout -q $1)
(cd head && git fetch -q origin $2 && git checkout -q FETCH_HEAD)
for t in base head; do (cd $t && $L ./build.sh 2>&1 | tail -1); done
cd base && clang -dM -E -march=native -fwrapv -funsigned-char -x c /dev/null > ../predefines.h && cd ..
for r in 1 2 3; do for t in base head; do
  echo "== $t round $r"
  (cd $t && $L taskset -c 2 ./build/compiler benchmark-parser -march=native -Isrc -fwrapv -funsigned-char --predefines ../predefines.h src/buster/compiler/main.c 2>&1)
done; done
echo ALLDONE

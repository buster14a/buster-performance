#!/bin/bash
# #1250 on the 9700X: base vs head -fsyntax-only of sqlite3.c and main.c (base's sources for both builds).
set -u
D=~/buster-fast-bench/1250-claude; mkdir -p $D; cd $D
export EXCLUSIVE_OWNER=claude-1250 EXCLUSIVE_TITLE="#1250: __float128 constants keep their binary128 bits" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/1250
X=~/buster-fast-bench/exclusive.sh
BASE=${BASE_REV:?}
HEAD=${HEAD_REV:?}
BRANCH=${BRANCH:?}
SQ=/home/david/buster-fast-bench/1296-codex-20261105/corpus/sqlite
for name in base head; do
  rev=$BASE; [ $name = head ] && rev=$HEAD
  [ -d $name ] || git clone -q https://github.com/buster14a/buster $name
  (cd $name && git fetch -q origin $BRANCH main && git checkout -q -f $rev)
  (cd $name && BUSTER_HOST_ARCH=znver5 BUSTER_DEBUG_INFO=0 $X ./build.sh > ../build-$name.log 2>&1) || { echo "build $name failed"; exit 1; }
done
echo "built base $(git -C base rev-parse --short HEAD) head $(git -C head rev-parse --short HEAD)"
cd base
clang -dM -E -march=native -fwrapv -funsigned-char -x c /dev/null > build/predefines.h
$X taskset -c 2 ../head/build/compiler time-runs --runs 30 --warmups 3 --build base ../base/build/compiler --build head ../head/build/compiler \
  --list -fsyntax-only -w -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -I$SQ $SQ/sqlite3.c \
  --list -fsyntax-only -march=native -Isrc -fwrapv -funsigned-char -fno-strict-aliasing -Wall -Werror src/buster/compiler/main.c > ../results.txt 2>&1
echo "status $?" >> ../results.txt
echo DONE >> ../results.txt

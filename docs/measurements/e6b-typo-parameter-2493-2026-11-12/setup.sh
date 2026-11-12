#!/bin/sh
set -e
D=~/buster-fast-bench/1447-claude-e6b
mkdir -p $D && cd $D
cp ~/buster-fast-bench/1447-claude-c9/sqlite3.c . 2>/dev/null || true
for t in base head; do
  [ -d $t ] || git clone -q https://github.com/buster14a/buster.git $t
done
(cd base && git fetch -q origin main && git checkout -q d40698d8)
(cd head && git fetch -q origin e6b/typo-parameter && git checkout -q FETCH_HEAD)
export EXCLUSIVE_OWNER=claude-e6b EXCLUSIVE_TITLE="E6b typo parameter measurement" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/1447
for t in base head; do (cd $t && ~/buster-fast-bench/exclusive.sh ./build.sh > ../build-$t.log 2>&1); done
echo BUILT

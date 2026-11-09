#!/bin/bash
# #1447 / PR #1820 declaration-specifier recovery: error-free units, main cb608c1f against 00ed85d.
set -u
D=~/buster-fast-bench/1447-claude-declspec
cd $D
export EXCLUSIVE_OWNER=claude-1820-declspec EXCLUSIVE_TITLE="#1820 declaration-specifier recovery base-vs-head" EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/1820
X=~/buster-fast-bench/exclusive.sh
if [ ! -d base ]; then git clone -q https://github.com/buster14a/buster base && git -C base checkout -q cb608c1f616f8fe26234bcaaa869caccc571de63; fi
if [ ! -d head ]; then git clone -q base head; fi
git -C head fetch -q https://github.com/buster14a/buster recovery/1447-file-scope-errors && git -C head checkout -q 00ed85d
for t in base head; do (cd $t && BUSTER_HOST_ARCH=znver5 BUSTER_DEBUG_INFO=0 $X ./build.sh > ../build-$t.log 2>&1; echo "$t build $?"); done
SQL=~/buster-fast-bench/refine-claude/inputs/sqlite3.c
MAIN=$D/base/src/buster/compiler/main.c
F="-march=native -I$D/base/src -fwrapv -funsigned-char"
: > perf.txt
for round in 1 2 3; do
  for t in base head; do
    echo "== round $round $t sqlite" >> perf.txt
    $X taskset -c 2 perf stat -x, -e instructions:u,cycles:u -r 5 $D/$t/build/compiler -fsyntax-only $SQL >> perf.txt 2>&1
    echo "== round $round $t main.c" >> perf.txt
    $X taskset -c 2 perf stat -x, -e instructions:u,cycles:u -r 5 $D/$t/build/compiler -fsyntax-only $F $MAIN >> perf.txt 2>&1
  done
done
echo RUN-DONE

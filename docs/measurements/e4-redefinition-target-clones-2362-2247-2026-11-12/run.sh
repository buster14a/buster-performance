#!/bin/bash
# E4 (#2362, #2247): base 8c67a8d6 vs #2442's head (main with #2423 and #2435 merged, plus #2442).
set -e
export EXCLUSIVE_OWNER=e4-claude EXCLUSIVE_TITLE="E4: #2362/#2247 base-vs-head" EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/2442
D=~/buster-fast-bench/2362-e4-claude
mkdir -p $D && cd $D
for side in base head; do
  [ -d $side ] || git clone -q https://github.com/buster14a/buster $side
done
git -C base fetch -q origin 8c67a8d61 2>/dev/null || git -C base fetch -q origin main
git -C base checkout -q 8c67a8d6
git -C head fetch -q origin e4/2247-label-copies
git -C head checkout -q FETCH_HEAD
git -C base log -1 --format='base %H' > revisions.txt
git -C head log -1 --format='head %H' >> revisions.txt
for side in base head; do
  (cd $side && ~/buster-fast-bench/exclusive.sh ./build.sh > ../build-$side.log 2>&1)
done
corpus=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
sq=(--predefines "$corpus/provenance/gnu17-pinned-predefines.txt" --target=x86_64-linux-gnu -march=znver5 -std=gnu17 -nostdinc -isystem "$corpus/headers/usr/lib/clang/23/include" -isystem "$corpus/headers/usr/local/include" -isystem "$corpus/headers/usr/include" "$corpus/sqlite/sqlite3.c")
mc=(-march=native -I$D/head/src -fwrapv -funsigned-char $D/head/src/buster/compiler/main.c)
~/buster-fast-bench/exclusive.sh taskset -c 2 ./head/build/compiler time-runs --runs 11 --warmups 2 --directory $D/runs \
  --build base $D/base/build/compiler --build head $D/head/build/compiler \
  --list -fsyntax-only "${sq[@]}" \
  --list -c -o /dev/null "${sq[@]}" \
  --list -c -o /dev/null "${mc[@]}" > results.txt 2>&1
echo done >> results.txt

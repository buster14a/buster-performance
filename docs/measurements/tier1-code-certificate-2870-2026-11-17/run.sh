#!/bin/bash
set -u
cd ~/buster-fast-bench/2870-claude
export EXCLUSIVE_OWNER=claude-2870 EXCLUSIVE_TITLE="Issue 2870" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2870
E=~/buster-fast-bench/exclusive.sh
corpus=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
A=(--predefines "$corpus/provenance/gnu17-pinned-predefines.txt" --no-default-config --target=x86_64-linux-gnu -march=znver5 -std=gnu17 -nostdinc -isystem "$corpus/headers/usr/lib/clang/23/include" -isystem "$corpus/headers/usr/local/include" -isystem "$corpus/headers/usr/include" "$corpus/sqlite/sqlite3.c")
for t in main head; do
  (cd $t && timeout 1800 $E ./build.sh --config Release > ../build-$t.log 2>&1) || { echo "build $t failed"; exit 1; }
done
for t in main head; do
  timeout 900 $E taskset -c 2 $t/build/compiler benchmark-tier1-code-certificate "${A[@]}" > bench-$t.log 2>&1; echo "bench $t rc=$?"
done
echo done

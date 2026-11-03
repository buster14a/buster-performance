#!/bin/bash
unset CPATH C_INCLUDE_PATH
export SOURCE_DATE_EPOCH=1792454400
corpus=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
options=(--predefines "$corpus/provenance/gnu17-pinned-predefines.txt" --target=x86_64-linux-gnu -march=znver5 -std=gnu17 -nostdinc -isystem "$corpus/headers/usr/lib/clang/23/include" -isystem "$corpus/headers/usr/local/include" -isystem "$corpus/headers/usr/include")
for b in main head; do
  exe=/home/david/buster-fast-bench/1128-claude/main-703ae9f5/build/compiler; [ $b = head ] && exe=/home/david/buster-fast-bench/1128-claude/head-0c51b8fd/build/compiler
  echo "== benchmark-check-units of $b"
  /home/david/buster-fast-bench/1128-claude/head-0c51b8fd/build/compiler benchmark-check-units --executable $exe --lanes 1,2,4,8 --runs 5 -- "${options[@]}"
  echo "status $?"
done

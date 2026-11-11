#!/bin/bash
set -e
D=~/buster-fast-bench/2301-claude-d6
cd $D
export EXCLUSIVE_OWNER=claude-2301-d6 EXCLUSIVE_TITLE="#2301 D6: GNU cast to a union, base vs head" EXCLUSIVE_LINK=https://claude.ai/code/session_01Egbxngcbuk3PNgFUn7C7Ze
while ! grep -q setup-done setup.log; do sleep 20; done
corpus=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
sqlite=(--predefines "$corpus/provenance/gnu17-pinned-predefines.txt" --target=x86_64-linux-gnu -march=znver5 -std=gnu17 -nostdinc -isystem "$corpus/headers/usr/lib/clang/23/include" -isystem "$corpus/headers/usr/local/include" -isystem "$corpus/headers/usr/include" "$corpus/sqlite/sqlite3.c")
main=(-march=native -Isrc -fwrapv -funsigned-char -fno-strict-aliasing --predefines "$D/predefines.h" src/buster/compiler/main.c)
cd base
./build/compiler ab --rounds 5 --cpu 2 --lock ~/buster-fast-bench/exclusive.sh ../base ../head \
  -- time-runs --runs 11 --list -fsyntax-only "${sqlite[@]}" --list -c -o $D/sqlite.o "${sqlite[@]}" \
     --list -fsyntax-only "${main[@]}" --list -c -o $D/main.o "${main[@]}" > $D/ab.log 2>&1
echo ab-done >> $D/ab.log

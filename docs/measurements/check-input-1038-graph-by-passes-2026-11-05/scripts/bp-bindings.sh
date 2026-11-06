#!/bin/bash
tree="$1"; out="$2"
mkdir -p "$out"
export EXCLUSIVE_OWNER=claude-1038 EXCLUSIVE_TITLE="GitHub issue #1038" EXCLUSIVE_LINK=https://claude.ai/code/session_01TiDLnvzc6A3cz2qD5dSRLw
unset CPATH C_INCLUDE_PATH
export SOURCE_DATE_EPOCH=1792454400
corpus=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
system=(--predefines "$corpus/provenance/gnu17-pinned-predefines.txt" --clang-features --no-default-config --target=x86_64-linux-gnu -march=znver5 -std=gnu17 -nostdinc -isystem "$corpus/headers/usr/lib/clang/23/include" -isystem "$corpus/headers/usr/local/include" -isystem "$corpus/headers/usr/include")
cd "$tree"
~/buster-fast-bench/exclusive.sh taskset -c 2 ./build/compiler benchmark-checker-bindings --passes 5 "${system[@]}" "$corpus/sqlite/sqlite3.c" > "$out/bindings-sqlite.txt" 2>&1
echo done > "$out/done-bindings"

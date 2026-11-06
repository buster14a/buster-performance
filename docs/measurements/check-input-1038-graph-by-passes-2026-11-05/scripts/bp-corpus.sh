#!/bin/bash
# Usage: bp-corpus.sh TREE OUT -- the corpus comparisons and c-testsuite, each under the lock
tree="$1"; out="$2"
mkdir -p "$out"
export EXCLUSIVE_OWNER=claude-1038 EXCLUSIVE_TITLE="GitHub issue #1038" EXCLUSIVE_LINK=https://claude.ai/code/session_01TiDLnvzc6A3cz2qD5dSRLw
cd "$tree"
unset CPATH C_INCLUDE_PATH
export SOURCE_DATE_EPOCH=1792454400
corpus=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
mapfile -d '' -t flags < <(BUSTER_HOST_ARCH=znver5 BUSTER_DEBUG_INFO=0 ./build.sh print-compile-flags)
~/buster-fast-bench/exclusive.sh ./build/compiler test-checker-corpus --clang clang --symbols-minimum 1 "${flags[@]}" src/buster/compiler/main.c > "$out/corpus-main.log" 2>&1
echo "corpus main rc=$?" >> "$out/status"
~/buster-fast-bench/exclusive.sh ./build/compiler test-checker-corpus --clang clang --deferred 8 --symbols --report "$out/checker-sqlite.tsv" --no-default-config --target=x86_64-linux-gnu -march=znver5 -std=gnu17 -nostdinc -isystem "$corpus/headers/usr/lib/clang/23/include" -isystem "$corpus/headers/usr/local/include" -isystem "$corpus/headers/usr/include" "$corpus/sqlite/sqlite3.c" > "$out/corpus-sqlite.log" 2>&1
echo "corpus sqlite rc=$?" >> "$out/status"
~/buster-fast-bench/exclusive.sh ./build/compiler test-checker-corpus --clang clang --semantic-mutations 8 --seed 133 --minimize 0 --no-default-config --target=x86_64-linux-gnu -march=znver5 -std=gnu17 -nostdinc -isystem "$corpus/headers/usr/lib/clang/23/include" -isystem "$corpus/headers/usr/local/include" -isystem "$corpus/headers/usr/include" "$corpus/sqlite/sqlite3.c" > "$out/mutations-sqlite.log" 2>&1
echo "mutations sqlite rc=$?" >> "$out/status"
if [ ! -d build/c-testsuite/tests ]; then
  git init -q --template= build/c-testsuite
  git -C build/c-testsuite fetch -q --depth 1 https://github.com/c-testsuite/c-testsuite 5c7275656d751de0e68b2d340a95b5681858ed07
  git -C build/c-testsuite checkout -q FETCH_HEAD
fi
~/buster-fast-bench/exclusive.sh ./build/compiler test-c-testsuite --cross-check --clang clang --jobs 8 --subset tests/c-testsuite/subset.txt build/c-testsuite > "$out/c-testsuite.log" 2>&1
echo "c-testsuite rc=$?" >> "$out/status"
~/buster-fast-bench/exclusive.sh ./build/compiler test-checker-corpus --clang clang --deferred 8 --id-order 153 build/c-testsuite/tests/single-exec > "$out/corpus-c-testsuite.log" 2>&1
echo "corpus c-testsuite rc=$?" >> "$out/status"
echo done >> "$out/status"

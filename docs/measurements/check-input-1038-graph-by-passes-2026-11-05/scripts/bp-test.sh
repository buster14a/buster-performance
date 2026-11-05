#!/bin/bash
# Usage: bp-test.sh TREE OUT -- build, then the checker's tests and object comparisons, each under the lock
tree="$1"; out="$2"
mkdir -p "$out"
export EXCLUSIVE_OWNER=claude-1038 EXCLUSIVE_TITLE="GitHub issue #1038" EXCLUSIVE_LINK=https://claude.ai/code/session_01TiDLnvzc6A3cz2qD5dSRLw
cd "$tree"
BUSTER_DEBUG_INFO=0 ~/buster-fast-bench/exclusive.sh ./build.sh > build.log 2>&1 || { echo "build failed" > "$out/status"; exit 1; }
corpus=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
sqlite=$corpus/sqlite
options=(-c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$sqlite" "$sqlite/sqlite3.c")
base=~/buster-fast-bench/1038-claude/base/build/compiler
# objects: sqlite3.c and main.c, this tree's default and --scalar against the base's default
~/buster-fast-bench/exclusive.sh bash -c "
  ./build/compiler ${options[*]} -o $out/sqlite-head.o && ./build/compiler --scalar ${options[*]} -o $out/sqlite-head-scalar.o && $base ${options[*]} -o $out/sqlite-base.o
  ./build/compiler -c -march=native -Isrc -fwrapv -funsigned-char -fno-strict-aliasing src/buster/compiler/main.c -o $out/main-head.o
  ./build/compiler --scalar -c -march=native -Isrc -fwrapv -funsigned-char -fno-strict-aliasing src/buster/compiler/main.c -o $out/main-head-scalar.o
  $base -c -march=native -Isrc -fwrapv -funsigned-char -fno-strict-aliasing src/buster/compiler/main.c -o $out/main-base.o
" > "$out/objects.log" 2>&1
for f in sqlite main; do
  cmp "$out/$f-head.o" "$out/$f-base.o" && echo "$f head == base" || echo "$f head != base"
  cmp "$out/$f-head-scalar.o" "$out/$f-base.o" && echo "$f scalar == base" || echo "$f scalar != base"
done > "$out/objects.txt" 2>&1
for part in 1 2 3 4; do
  ~/buster-fast-bench/exclusive.sh ./build/compiler test-checker --seed 133 --part $part/4 > "$out/test-checker-$part.log" 2>&1
  echo "test-checker part $part rc=$?" >> "$out/status"
done
~/buster-fast-bench/exclusive.sh ./build/compiler test-checker-deferred > "$out/test-checker-deferred.log" 2>&1
echo "test-checker-deferred rc=$?" >> "$out/status"
echo done >> "$out/status"

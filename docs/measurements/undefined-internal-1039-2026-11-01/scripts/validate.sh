#!/bin/bash
# validate.sh HEAD BASE OUT: tests and object identity, each command its own lock hold.
set -uo pipefail
. ~/buster-fast-bench/droid-zen5/scripts/env.sh
head=$(realpath "$1"); base=$(realpath "$2"); out=$(realpath -m "$3"); mkdir -p "$out"
ct=$HOME/buster-fast-bench/droid-zen5/ct/c-testsuite
cd "$head"
run() { local name=$1; shift; $lock "$@" > "$out/$name.txt" 2>&1; echo "$name status $?" | tee -a "$out/status.txt"; }
run test-checker ./build/compiler test-checker --seed 133
run c-testsuite ./build/compiler test-c-testsuite --cross-check --clang clang --jobs 8 --subset tests/c-testsuite/subset.txt "$ct"
run c-testsuite-tier1 ./build/compiler test-c-testsuite --tier1 --jobs 8 --subset tests/c-testsuite/subset.txt "$ct"
run checker-driver ./build/compiler test-checker-driver --executable ./build/compiler
(
  unset CPATH C_INCLUDE_PATH; export SOURCE_DATE_EPOCH=1792454400
  run checker-corpus-sqlite ./build/compiler test-checker-corpus --clang clang --deferred 8 --symbols --report "$out/checker-sqlite.tsv" --no-default-config --target=x86_64-linux-gnu -march=znver5 -std=gnu17 -nostdinc -isystem "$corpus/headers/usr/lib/clang/23/include" -isystem "$corpus/headers/usr/local/include" -isystem "$corpus/headers/usr/include" "$corpus/sqlite/sqlite3.c"
)
opts=(-c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$corpus/sqlite" "$corpus/sqlite/sqlite3.c")
run obj-base $base/build/compiler "${opts[@]}" -o "$out/base.o"
run obj-head $head/build/compiler "${opts[@]}" -o "$out/head.o"
run obj-head-scalar $head/build/compiler --scalar "${opts[@]}" -o "$out/head-scalar.o"
run obj-base-scalar $base/build/compiler --scalar "${opts[@]}" -o "$out/base-scalar.o"
cmp "$out/base.o" "$out/head.o" && cmp "$out/base-scalar.o" "$out/head-scalar.o" && echo "objects identical" | tee -a "$out/status.txt" || echo "objects DIFFER" | tee -a "$out/status.txt"
# Warnings on a source with undefined internal functions, both paths and both trees.
printf 'static void missing(void);static int late(void);int f(void){missing();return late();}\n' > "$out/undefined.c"
for t in base head; do for s in "" --scalar; do tree=$([ $t = base ] && echo $base || echo $head); $tree/build/compiler $s -fsyntax-only "$out/undefined.c" > "$out/warn-$t$s.txt" 2>&1; done; done
cat "$out"/warn-*.txt | sort | uniq -c | head -20 > "$out/warnings-summary.txt"
echo validate done

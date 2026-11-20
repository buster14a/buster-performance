#!/usr/bin/env bash
set -euo pipefail
dest=$(realpath -m "$1")
base=$(realpath "$2")
head=$(realpath "$3")
src=/home/david/dev/buster-corpus/sqlite
speed=/home/david/dev/ai/devin/buster/pr-review-data/1927-verify/probes/sqlite-tree2/test/speedtest1.c
cc=/home/david/.cache/buster/toolchain/4444af0bee44de2d/llvm-23.1.4/bin/clang
mkdir -p "$dest"
for v in base head; do
    compiler=$base
    if [[ $v == head ]]; then compiler=$head; fi
    flags=(--tier1 -O2 -march=znver5 --lanes 1 -w -DSQLITE_THREADSAFE=0 -DSQLITE_OMIT_LOAD_EXTENSION -I"$src")
    "$compiler" "${flags[@]}" -c "$src/sqlite3.c" -o "$dest/$v-engine.o"
    "$compiler" "${flags[@]}" -c "$speed" -o "$dest/$v-driver.o"
    "$cc" -no-pie "$dest/$v-driver.o" "$dest/$v-engine.o" -lm -ldl -pthread -o "$dest/$v"
done
for testset in main fp orm cte json; do
    for v in oracle base head; do
        exe="$dest/$v"
        if [[ $v == oracle ]]; then exe=lea-evidence/speedtest-clang; fi
        "$exe" --memdb --verify --size 4 --testset "$testset" > "$dest/$v-$testset.txt"
        rg 'Verification Hash:' "$dest/$v-$testset.txt" > "$dest/$v-$testset.hash"
    done
    cmp "$dest/base-$testset.hash" "$dest/head-$testset.hash"
    cmp "$dest/head-$testset.hash" "$dest/oracle-$testset.hash"
done

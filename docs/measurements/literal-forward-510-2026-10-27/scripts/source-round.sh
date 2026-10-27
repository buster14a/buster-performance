#!/usr/bin/env bash
# source-round.sh ROUND: benchmark-checker-source on the frozen SQLite source (the 9700X job's command) by each tree's
# executable at each shift, the trees' order swapped every round, pinned to CPU 2. Each run takes the lock alone.
set -u
# Only round 1 runs: the lock is contended (about 10 minutes a hold on 2026-10-26).
[ "$1" = 1 ] || exit 0
here="$HOME/buster-fast-bench/literal-510"
cd "$here"
unset CPATH C_INCLUDE_PATH
export SOURCE_DATE_EPOCH=1792454400
corpus=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
source=(--predefines "$corpus/provenance/gnu17-pinned-predefines.txt" --clang-features --no-default-config --target=x86_64-linux-gnu -march=znver5 -std=gnu17 -nostdinc -isystem "$corpus/headers/usr/lib/clang/23/include" -isystem "$corpus/headers/usr/local/include" -isystem "$corpus/headers/usr/include" "$corpus/sqlite/sqlite3.c")
trees=(main head); [ $(($1 % 2)) = 0 ] && trees=(head main)
for s in 0 16 32 48 64 1024; do
    for tree in "${trees[@]}"; do
        ./locked.sh taskset -c 2 "$here/bin/$tree-s$s" benchmark-checker-source "${source[@]}" > results/source-$tree-s$s-$1.txt 2>&1
    done
done

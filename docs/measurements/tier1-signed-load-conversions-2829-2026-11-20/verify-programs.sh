#!/usr/bin/env bash
set -eu
cd "$(dirname "$0")"
for arch in x86-64 znver5; do
    for kernel in $(./programs/clang-O0-$arch list); do
        oracle=$(./programs/clang-O0-$arch "$kernel" 1 | awk '{print $NF}')
        for compiler in base head; do
            for mode in default unroll; do
                for pad in 0 16 32 48; do
                    actual=$(./programs/$compiler-$arch-$mode-p$pad "$kernel" 1 | awk '{print $NF}')
                    printf '%s\t%s\t%s\t%s\t%d\t%s\t%s\n' "$kernel" "$arch" "$compiler" "$mode" "$pad" "$oracle" "$actual"
                    [[ $actual == "$oracle" ]] || exit 1
                done
            done
        done
    done
done

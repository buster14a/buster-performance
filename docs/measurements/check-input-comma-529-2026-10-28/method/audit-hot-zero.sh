#!/usr/bin/env bash
set -euo pipefail
campaign=/home/david/buster-fast-bench/unclaimed-perf-20261028
stage=$campaign/issue-529-b8ee-clang2314
toolroot=$campaign/toolchain-clang2314/buster/benchpress-clang/efdd1dbd089b99bfcfcde7b8eb1236163f2e88df5a981cca4f783ec9cb5e0378
export PATH="$toolroot/bin:$PATH"
clang -O2 -Wall -Wextra -Werror "$stage/method/elf-build-id-only.c" -o "$stage/method/elf-build-id-only"
for role in base head; do
    original=$stage/stage2-base/compiler-native
    if [[ $role == head ]]; then original=$stage/head/build/compiler; fi
    "$stage/method/elf-build-id-only" "$original" "$stage/hot-$role/compiler-zero" > "$stage/hot-$role/zero-byte-analysis.txt"
    cmp "$stage/hot-$role/original-symbols.txt" "$stage/hot-$role/zero-symbols.txt"
    cmp "$stage/hot-$role/original-program-headers.txt" "$stage/hot-$role/zero-program-headers.txt"
done

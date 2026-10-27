#!/usr/bin/env bash
set -eu
root="$HOME/buster-fast-bench/codex-602-20261027"
cd "$root"
clang -std=c17 -O2 -Wall -Wextra -Werror evidence/instrument.c -o instrument
for variant in base head; do
    tree="$root/counts-$variant"
    mkdir -p "$tree/src"
    cp -a "$variant/src/." "$tree/src/"
    ./instrument "$variant" "$tree"
    sed '/#include "buster\/compiler\/c_checker_test.c"/,$d' "$tree/src/buster/compiler/main.c" |
        sed 's/#define BUSTER_ELSEWHERE inline __attribute__((noinline))/#define BUSTER_ELSEWHERE static/' > "$tree/counts.c"
    cat evidence/count-main.c >> "$tree/counts.c"
    clang -O1 -march=native -I"$tree/src" -fwrapv -funsigned-char -fno-strict-aliasing \
        -Wall -Werror -Wno-unused-function "$tree/counts.c" -lm -ldl -pthread -o "$tree/compiler"
    for family in pointer_expression pointer_constant record_expression record_constant; do
        for count in 256 512 1024 2048 4096 8192 10000; do
            printf 'input,%s,%s,%s\n' "$variant" "$family" "$count"
            taskset -c 2 "$tree/compiler" "$root/inputs/"$family"_"$count".c"
        done
    done
done

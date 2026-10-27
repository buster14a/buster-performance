#!/usr/bin/env bash
set -eu
root="$HOME/buster-fast-bench/codex-602-20261027"
cd "$root"
bash evidence/prepare.sh
mkdir -p native
for family in pointer_expression pointer_constant record_expression record_constant; do
    source="$root/inputs/"$family"_10000.c"
    ./head/build/compiler --lanes 1 -c "$source" -o native/vector.o
    ./head/build/compiler --scalar --lanes 1 -c "$source" -o native/scalar.o
    cmp native/vector.o native/scalar.o
    ./base/build/compiler --lanes 1 -c "$source" -o native/base.o
    cmp native/vector.o native/base.o
    clang -no-pie native/vector.o -o native/vector
    clang -std=gnu17 -O0 "$source" -o native/clang
    ./native/vector
    ./native/clang
    printf '%s: base/head and scalar/vector objects identical; native and Clang executables exit 0\n' "$family"
done

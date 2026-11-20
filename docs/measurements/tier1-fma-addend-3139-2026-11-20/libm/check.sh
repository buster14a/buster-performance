#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"
cc=${CC:-clang}
"$cc" -std=gnu11 -D_GNU_SOURCE -O0 -fno-builtin -ffp-model=strict -c check.c -o check.o
for v in parent candidate clang; do
    "$cc" -no-pie check.o "$v/libmath.a" -lm -Wl,-Map="$v.map" -o "$v-test"
    "./$v-test" "$v.bin"
done
sha256sum parent.bin candidate.bin clang.bin
cmp parent.bin candidate.bin

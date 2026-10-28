#!/bin/bash
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Run from the pinned compiler checkout, under the host's CPU budget/lock.
set -euo pipefail
record="$(cd "$(dirname "$0")" && pwd)"
qualification="$(mktemp -d)"
trap 'rm -rf "$qualification"' EXIT
# Grouping all checker code in named sections keeps unrelated commands alive in this one-entry-point
# harness. Disable only the section pragmas, so normal function/data sections can be garbage-collected.
sed '/#pragma clang section/d' src/buster/compiler/main.c > "$qualification/main-batch-test.inc"
cp "$record/guarded-sanitizer.c" "$qualification/guarded-sanitizer.c"
clang -O0 -ffunction-sections -fdata-sections -march=native -Isrc -fwrapv -funsigned-char -fno-strict-aliasing -Wall -Werror \
    -fsanitize=address,undefined -fno-omit-frame-pointer "$qualification/guarded-sanitizer.c" \
    -Wl,--gc-sections -no-pie -lm -ldl -o "$qualification/guarded-sanitizer"
ASAN_OPTIONS=detect_leaks=0 "$qualification/guarded-sanitizer"

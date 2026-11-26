#!/usr/bin/env bash
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Reproduce correctness checks; uses an existing head checkout and a new output directory.
set -euo pipefail
here=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
repo=$(realpath "${1:?usage: bash run-standalone.sh CHECKOUT OUTPUT}")
mkdir -p "${2:?output directory required}"
out=$(realpath "$2")
clang=${BUSTER_VALIDATION_CLANG:-clang}
base=74eacd4744a8131ba4c1a5bd8ad87b89ec0f7dbe
flags=(-std=c17 -O0 -g0 -Xclang -clear-ast-before-backend -D_GNU_SOURCE
       -march=x86-64-v4 -maes -mgfni -mvaes -mavx512vbmi -mavx512vbmi2
       -mavx512vpopcntdq -mavx512bitalg -mavx512vnni
       -I"$repo/src" -I"$repo/src/buster/compiler" -fwrapv -funsigned-char
       -fno-strict-aliasing -Wall -Werror -Wno-unused-function -fno-stack-protector)
"$clang" -std=c11 -O2 -Wall -Wextra -Werror "$here/validate1384.c" -o "$out/validate1384"
cd "$repo"
"$clang" "${flags[@]}" "$here/frame-tests.c" -o "$out/frame-tests-head" -pthread
"$out/validate1384" run "$out/frame-tests-head.json" "$out/frame-tests-head" > "$out/frame-tests-head.run.log" 2>&1
mkdir -p "$out/base-include/buster/compiler"
for source in tier1_select.c tier1_emit.c tier1_emit_cfg.c; do
    git show "$base:src/buster/compiler/$source" > "$out/base-include/buster/compiler/$source"
done
"$clang" -I"$out/base-include" "${flags[@]}" "$here/frame-tests.c" -o "$out/frame-tests-base" -pthread
if "$out/validate1384" run "$out/frame-tests-base.json" "$out/frame-tests-base" > "$out/frame-tests-base.run.log" 2>&1; then
    printf 'Unexpected base success\n' >&2
    exit 1
else
    status=$?
    test "$status" -eq 1
fi
"$clang" "${flags[@]}" "$here/selector-tests.c" -o "$out/selector-tests-head" -pthread
"$out/validate1384" run "$out/selector-tests-head.json" "$out/selector-tests-head" select > "$out/selector-tests-head.run.log" 2>&1
"$out/validate1384" run "$out/emitter-tests-head.json" "$out/selector-tests-head" emit > "$out/emitter-tests-head.run.log" 2>&1
sha256sum "$out/frame-tests-head" "$out/frame-tests-base" "$out/selector-tests-head" > "$out/standalone-binaries.sha256"
printf 'Focused head/base and full selector/emitter results are in %s\n' "$out"

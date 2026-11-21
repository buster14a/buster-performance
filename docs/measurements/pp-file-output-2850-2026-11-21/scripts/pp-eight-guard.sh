#!/bin/bash
set -euo pipefail
cd "$HOME/buster-fast-bench/2850-pp-parser-window";root=$PWD;out=$root/digits8-guard;mkdir -p "$out"
src=$root/trees/digits8/src/buster/compiler/c_check_expression_input.c
until [[ -f "$src" ]];do sleep 1;done
sed -n '/^static inline __m256i check_input_decimal_eight(/,/^}/p' "$src" >"$out/digits8-kernel.h";test -s "$out/digits8-kernel.h"
clang=$(sed -n 's/.*toolchain: clang \([^ ]*\) (.*/\1/p' "$HOME/buster-fast-bench/2850-codex-step2/results/chainprbase6e9/build.log" | head -1)
"$root/lock.sh" taskset -c 2 "$clang" -std=gnu17 -O3 -march=znver5 -I"$out" "$root/pp-eight-guard-main.c" -o "$out/probe" >"$out/build" 2>&1
"$root/lock.sh" taskset -c 2 "$out/probe" >"$out/result" 2>"$out/test";date -u +%FT%TZ >"$out/done"

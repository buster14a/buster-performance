#!/bin/bash
set -euo pipefail
cd "$HOME/buster-fast-bench/2850-pp-parser-window";root=$PWD
until [[ -f results/macrobank/.built ]];do sleep 2;done
out=$root/macrobank-focused;mkdir -p "$out"
clang=$(sed -n 's/.*toolchain: clang \([^ ]*\) (.*/\1/p' "$root/results/macrobank/build.log"|head -1)
"$root/lock.sh" taskset -c 2 "$clang" -std=gnu17 -march=znver5 -O3 -g0 -fwrapv -funsigned-char -I"$root/trees/macrobank/src" pp-macro-guard.c -o "$out/probe" >"$out/build.log" 2>&1
"$root/lock.sh" taskset -c 2 "$out/probe" >"$out/guard.log" 2>&1
"$root/lock.sh" taskset -c 2 env BUSTER_TEST_PP_FILE_MACRO_BANK=1 python3 "$root/pp-macro-edges.py" "$root/results/enumqueuebase/compiler" "$root/results/macrobank/compiler" "$out/edges" >"$out/edges.log" 2>&1
date -u +%FT%TZ >"$out/done"

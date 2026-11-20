#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"
w=$(cd .. && pwd)
cc=/home/david/.cache/buster/toolchain/4444af0bee44de2d/llvm-23.1.4/bin/clang
mkdir -p cases
"$cc" -O2 -ffp-model=strict -fno-builtin -c check.c -o cases/check.o
for mode in clang control legacy vex; do
 case $mode in
   clang) c=$cc; flags=(-fno-vectorize -fno-slp-vectorize);;
   control) c="$w/all-pr-control/build/compiler"; flags=(--tier1 --lanes 1);;
   legacy) c="$w/negate-vex/build/compiler"; flags=(--tier1 --lanes 1);;
   vex) c="$w/negate-vex-full/build/compiler"; flags=(--tier1 --lanes 1);;
 esac
 for arch in x86-64 x86-64-v2 x86-64-v3 znver5; do
   prefix=cases/$mode-$arch
   "$c" "${flags[@]}" -O2 -march="$arch" -c negation.c -o "$prefix.o"
   objdump -d -Mintel --no-show-raw-insn "$prefix.o" > "$prefix.asm"
   "$cc" -no-pie cases/check.o "$prefix.o" -lm -o "$prefix.exe"
   "$prefix.exe" >"$prefix.result"
   cmp "$prefix.result" cases/clang-x86-64.result
 done
done

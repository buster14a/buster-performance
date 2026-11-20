#!/usr/bin/env bash
set -eu
d=$(cd "$(dirname "$0")" && pwd)
cd "$d";mkdir -p objects
cc=/home/david/.cache/buster/toolchain/4444af0bee44de2d/llvm-23.1.4/bin/clang
"$cc" -O2 -march=x86-64 -std=gnu11 -ffp-model=strict -fno-vectorize -fno-slp-vectorize -c oracle.c -o objects/oracle.o
ulimit -c 0
for arch in x86-64 x86-64-v2 x86-64-v3 znver5; do
 "$cc" -O2 -march="$arch" -c leaves.c -o "objects/clang-$arch.o"
 for v in clang parent candidate; do
  prefix="objects/$v-$arch"
  "$cc" -no-pie objects/oracle.o "$prefix.o" -o "$prefix.exe"
  "$prefix.exe" language >"$prefix-language.result"
  cmp objects/clang-x86-64-language.result "$prefix-language.result"
  if [[ $v != clang ]]; then "$prefix.exe" machine >"$prefix-machine.result";cmp objects/parent-x86-64-machine.result "$prefix-machine.result";fi
 done
done

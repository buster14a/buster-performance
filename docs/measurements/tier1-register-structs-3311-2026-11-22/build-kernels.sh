#!/bin/bash
# usage: build-kernels.sh BASE_COMPILER FIX_COMPILER ; builds bin/<kernel>.<variant>
set -euo pipefail
mkdir -p bin
for k in i4 i2 l2; do
  clang -O0 -w -o bin/$k.clang-O0 $k.c
  clang -O2 -w -o bin/$k.clang-O2 $k.c
  "$1" -o bin/$k.base-tier0 $k.c
  "$1" --tier1 -o bin/$k.base-tier1 $k.c
  "$2" -o bin/$k.fix-tier0 $k.c
  "$2" --tier1 -o bin/$k.fix-tier1 $k.c
done
for b in bin/*; do printf '%s %s\n' "$b" "$("./$b")"; done

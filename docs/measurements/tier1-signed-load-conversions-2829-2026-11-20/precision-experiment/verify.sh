#!/usr/bin/env bash
set -euo pipefail
d=$(cd "$(dirname "$0")" && pwd);w=$(cd "$d/.." && pwd)
cc=${CC:-clang}
cd "$d";mkdir -p cases
"$cc" -O2 -ffp-model=strict -std=gnu11 -c oracle.c -o cases/oracle.o
for arch in x86-64 x86-64-v2 x86-64-v3 znver5; do
 for v in clang parent candidate; do
  case $v in clang) c=$cc;flags=(-fno-vectorize -fno-slp-vectorize);; parent) c="${PARENT:-$w/convert/build/compiler}";flags=(--tier1 --lanes 1);; candidate) c="${ZERO:-$w/precision-load/build/compiler}";flags=(--tier1 --lanes 1);; esac
  prefix="cases/$arch-$v"
  "$c" "${flags[@]}" -O2 -march="$arch" -c leaves.c -o "$prefix.o"
  objdump -d -Mintel --no-show-raw-insn "$prefix.o" >"$prefix.asm"
  "$cc" -no-pie cases/oracle.o "$prefix.o" -o "$prefix.exe"
  "$prefix.exe" >"$prefix.result"
  cmp "$prefix.result" cases/x86-64-clang.result
 done
done

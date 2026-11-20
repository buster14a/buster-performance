#!/usr/bin/env bash
set -euo pipefail
w=$(pwd);p="$w/fma-addend-evidence";d="$p/objects";mkdir -p "$d"
cc=/home/david/.cache/buster/toolchain/4444af0bee44de2d/llvm-23.1.4/bin/clang
"$cc" -O1 -ffp-model=strict -march=x86-64-v3 -c "$p/oracle.c" -o "$d/oracle.o"
for arch in x86-64-v3 znver5;do
 for mode in default post;do
  for v in parent head;do
   exe="$w/fma/build/compiler";[[ $v == parent ]] || exe="$w/fma-addend/build/compiler"
   flags=();[[ $mode == default ]] || flags+=(--tier1-schedule=post)
   name="$v-$arch-$mode";"$exe" --tier1 --verify -O2 --lanes 1 -march="$arch" "${flags[@]}" -c "$p/leaves.c" -o "$d/$name.o"
   "$cc" -no-pie "$d/oracle.o" "$d/$name.o" -lm -o "$d/$name"
   objdump -d -Mintel --no-show-raw-insn "$d/$name.o" >"$d/$name.asm"
   "$d/$name" > "$d/$name.result";cat "$d/$name.result"
  done
  cmp "$d/parent-$arch-$mode.result" "$d/head-$arch-$mode.result"
 done
done
python compare-musl.py fma/build/compiler fma-addend/build/compiler "$p/musl"
touch "$p/oracle-musl-passed"

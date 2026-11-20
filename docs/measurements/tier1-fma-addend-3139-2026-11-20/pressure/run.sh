#!/usr/bin/env bash
set -euo pipefail
p=fma-addend-evidence/pressure;c=/home/david/.cache/buster/toolchain/4444af0bee44de2d/llvm-23.1.4/bin/clang
python "$p/generate.py"
"$c" -O1 -march=x86-64-v3 -ffp-model=strict -c "$p/driver.c" -o "$p/driver.o"
for arch in x86-64-v3 znver5;do for mode in default post;do for v in parent candidate;do
 cc=fma/build/compiler;[[ $v == parent ]] || cc=fma-addend/build/compiler;o="$p/$v-$arch-$mode"
 flags=();[[ $mode == default ]] || flags+=(--tier1-schedule=post)
 "$cc" --verify --tier1 --lanes 1 -O2 "-march=$arch" "${flags[@]}" -c "$p/pressure.c" -o "$o.o"
 objdump -d -Mintel "$o.o" >"$o.asm";"$c" -no-pie "$p/driver.o" "$o.o" -o "$o"
 output=$("$o");echo -e "$v\t$arch\t$mode\t$output"
done;done;done
touch "$p/complete"

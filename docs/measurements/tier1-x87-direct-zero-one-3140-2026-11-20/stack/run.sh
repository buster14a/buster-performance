#!/usr/bin/env bash
set -euo pipefail
p=x87-rom-evidence/stack
c=/home/david/.cache/buster/toolchain/4444af0bee44de2d/llvm-23.1.4/bin/clang
"$c" -c "$p/call.S" -o "$p/call.o"; "$c" -O1 -c "$p/harness.c" -o "$p/harness.o"
for arch in x86-64 znver5; do for mode in default post; do for v in parent candidate; do
 exe=x87-double/build/compiler; [[ $v != candidate ]] || exe=x87-rom/build/compiler
 opts=(); [[ $mode != post ]] || opts+=(--tier1-schedule=post)
 o="$p/$v-$arch-$mode"
 "$exe" --tier1 --verify --lanes 1 -O2 -march="$arch" "${opts[@]}" -c "$p/leaves.c" -o "$o.o"
 "$c" -no-pie "$p/call.o" "$p/harness.o" "$o.o" -o "$o"
 out=$("$o"); echo -e "$v\t$arch\t$mode\t$(sha256sum "$o.o" | cut -d' ' -f1)\t$out"
done;done;done
touch "$p/complete"

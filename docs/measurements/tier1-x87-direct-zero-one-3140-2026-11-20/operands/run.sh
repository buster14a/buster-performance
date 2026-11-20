#!/usr/bin/env bash
set -euo pipefail
w=$(cd "$(dirname "$0")/../.." && pwd);d="$w/x87-rom-evidence/operands";cd "$d";ulimit -c 0
cc=/home/david/.cache/buster/toolchain/4444af0bee44de2d/llvm-23.1.4/bin/clang
mkdir -p out
"$cc" -O1 -march=x86-64 -ffp-model=strict -c driver.c -o out/driver.o
for arch in x86-64 x86-64-v2 x86-64-v3 znver5;do
 for v in clang parent candidate;do
  for schedule in default post;do
   target="$v-$arch-$schedule"
   if [[ $v == clang ]]; then
    [[ $schedule == default ]] || continue
    "$cc" -O2 -ffp-model=strict -march="$arch" -c leaves.c -o "out/$target.o"
   else
    exe="$w/x87-double/build/compiler";[[ $v != candidate ]] || exe="$w/x87-rom/build/compiler"
    extra=();[[ $schedule == default ]] || extra+=(--tier1-schedule=post)
    "$exe" --tier1 -O2 --lanes 1 -march="$arch" "${extra[@]}" -c leaves.c -o "out/$target.o"
   fi
   "$cc" -no-pie out/driver.o "out/$target.o" -o "out/$target.exe"
   "out/$target.exe" "out/$target.data" >"out/$target.result"
   printf '%s\t%s\t%s\n' "$target" "$(sha256sum "out/$target.data" | cut -d' ' -f1)" "$(cat "out/$target.result")"
   if [[ $v == candidate ]];then cmp "out/parent-$arch-$schedule.data" "out/$target.data";fi
  done
 done
done

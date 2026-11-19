#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"
export MEASUREMENT_TITLE='Signed-load conversion array kernels (#2829)'
export MEASUREMENT_LINK='https://github.com/buster14a/buster/pull/3120'
arches=(znver5 x86-64)
modes=(unroll default)
pads=(0 16 32 48)
for ((round=0;round<=5;round++)); do
  for ((p=0;p<16;p++)); do
    pos=$(( (p+5*round)%16 )); arch=${arches[pos%2]}; mode=${modes[(pos/2)%2]}; pad=${pads[pos/4]}
    variants=(base head)
    if (( (round+p)%2 )); then variants=(head base); fi
    for v in "${variants[@]}"; do
      build="$v-$arch-$mode-p$pad"; label="$round-$build"
      [[ -s results/$label.stat ]] && continue
      ./when-free.sh timeout -k 2 10 ./measure-kernel.sh "$label" "$build" i32_to_f32 65536
      sleep 1
    done
  done
done

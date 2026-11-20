#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"
export MEASUREMENT_TITLE='Tier 1 scalar FMA kernel measurements (#3122)'
export MEASUREMENT_LINK=https://github.com/buster14a/buster/pull/3122
kernels=(saxpy_f32 dot_f32 matmul_f32)
modes=(unroll default)
pads=(0 16 32 48)
for ((round=0;round<=5;round++)); do
    for ((i=0;i<24;i++)); do
        pos=$(( (i+5*round)%24 ))
        kernel=${kernels[pos%3]}; mode=${modes[(pos/3)%2]}; pad=${pads[pos/6]}
        variants=(base head)
        if (( (round+i)%2 )); then variants=(head base); fi
        for v in "${variants[@]}"; do
            label="$round-$kernel-$mode-p$pad-$v"
            [[ -s results/$label.stat ]] && continue
            read -r program reps < <(awk -v k="$kernel" -v m="$mode" -v p="$pad" -v v="$v" '$1==k && $2==m && $3==p && $4==v{print $5,$7}' cases.tsv)
            ./when-free.sh timeout -k 2 10 ./measure-kernel.sh "$label" "$program" "$kernel" "$reps"
            sleep 2
        done
    done
done

#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"
export MEASUREMENT_TITLE='Native scheduler costs for conversion and FMA memory operands (#2829)'
export MEASUREMENT_LINK=https://github.com/buster14a/buster/issues/2829
mkdir -p results
mapfile -t forms < float-cost-forms.txt
for round in 0 1 2 3; do
    for ((k=0;k<${#forms[@]};k++)); do
        form=${forms[(k+5*round)%${#forms[@]}]}
        label="float-cost-$round-${form/\//-}"
        [[ -s results/$label.out ]] && continue
        ./when-free.sh timeout -k 2 18 taskset -c 2 ./compilers/float-costs measure-x86-zen5 --only "$form" > "results/$label.out.new"
        mv "results/$label.out.new" "results/$label.out"
        sleep 2
    done
done

#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"
mapfile -t forms <model-fma-forms.txt
mkdir -p results
for round in 0 1; do
 for ((i=0;i<${#forms[@]};i++)); do
  form=${forms[(i+3*round)%${#forms[@]}]}; label="model-fma-$round-${form/\//-}"
  [[ -s results/$label.out ]] && continue
  ./when-free.sh timeout -k 2 18 taskset -c 2 ./compilers/model-fma measure-x86-zen5 --check --only "$form" >"results/$label.out.new"
  mv "results/$label.out.new" "results/$label.out"
  sleep 2.5
 done
done

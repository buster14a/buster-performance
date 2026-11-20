#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"
export MEASUREMENT_TITLE='Tier 1 debug range publication (#3121)'
export MEASUREMENT_LINK=https://github.com/buster14a/buster/pull/3121
workloads=(sqlite-O2 lua-lparser sqlite-O0 lua-lvm sqlite-tier1)
for ((round=0;round<=7;round++)); do
 for ((i=0;i<5;i++)); do
  run=${workloads[(round+i)%5]}; variants=(base head)
  if (( (round+i)%2 )); then variants=(head base); fi
  for v in "${variants[@]}"; do
    label="debug-$round-$v-$run"
    [[ -s results/$label.stat ]] && continue
    ./when-free.sh timeout -k 2 20 ./debug-compile-one.sh "$label" "debug-$v" "$run"
    sleep 2.5
  done
 done
done

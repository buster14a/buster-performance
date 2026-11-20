#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"
workloads=(sqlite-O2 lua-lvm sqlite-tier1)
for ((round=0;round<=3;round++)); do
    for ((pos=0;pos<${#workloads[@]};pos++)); do
        workload=${workloads[(pos+round)%${#workloads[@]}]}
        variants=(base head)
        if (( (round+pos)%2 )); then variants=(head base); fi
        for v in "${variants[@]}"; do
            label="eighteen-$round-$v-$workload"
            [[ -s results/$label.stat ]] && continue
            ./when-free.sh timeout -k 2 25 ./debug-compile-one.sh "$label" "eighteen-$v" "$workload"
            sleep 2.5
        done
    done
done

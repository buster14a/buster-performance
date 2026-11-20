#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"
workloads=(sqlite-tier1 lua-lparser sqlite-tier0 lua-lvm)
for ((round=0;round<=7;round++)); do
    for ((pos=0;pos<${#workloads[@]};pos++)); do
        workload=${workloads[(pos+round)%${#workloads[@]}]}
        variants=(base head)
        if (( (round+pos)%2 )); then variants=(head base); fi
        for v in "${variants[@]}"; do
            label="sites-$round-$v-$workload"
            [[ -s results/$label.stat ]] && continue
            ./when-free.sh timeout -k 2 25 ./compile-one.sh "$label" "sites-$v" "$workload"
            sleep 2.5
        done
    done
done

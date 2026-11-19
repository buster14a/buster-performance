#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"
export MEASUREMENT_TITLE='Tier 1 scaled integer products (#2700)'
export MEASUREMENT_LINK='https://github.com/buster14a/buster/issues/2700'
for round in 0 1 2 3 4 5; do
    for case_idx in $(seq 0 11); do
        pos=$(( (case_idx + 5 * round) % 12 )); scales=(2 4 8); pads=(0 16 32 48)
        scale=${scales[pos%3]}; pad=${pads[pos/3]}; variants=(base head)
        if (( (round + case_idx) % 2 )); then variants=(head base); fi
        for variant in "${variants[@]}"; do
            label="$round-$variant-$scale-p$pad"
            if [[ -s $label.stat ]]; then continue; fi
            ./when-free.sh timeout -k 2 10 ./measure-one.sh "$label" 32000000
            sleep 0.35
        done
    done
done

#!/usr/bin/env bash
set -euo pipefail
exe=${1:?usage: memory-floor.sh EXECUTABLE OUT}
out=${2:?}
export CORES_TITLE='Buster memory bandwidth calibration' CORES_LINK='https://github.com/buster14a/buster'
: > "$out/memory-floor.jsonl"
for round in 0 1 2; do
    if (( round % 2 )); then modes=(1 0); else modes=(0 1); fi
    for mode in "${modes[@]}"; do
        cores -n 6 -- "$exe" 6 "$mode" >> "$out/memory-floor.jsonl"
    done
done

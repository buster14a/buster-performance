#!/usr/bin/env bash
set -euo pipefail
root=${1:?usage: run-scaling.sh COMPILER CORPUS OUT}
corpus=${2:?}
out=${3:?}
script=$(dirname "$0")/scaling.py
export CORES_TITLE='Buster independent compile scaling'
export CORES_LINK='https://github.com/buster14a/buster'
: > "$out/scaling.jsonl"
for round in 0 1 2 3 4; do
    case $round in
        0|4) order=(1 2 4 6) ;;
        1) order=(2 4 6 1) ;;
        2) order=(4 6 1 2) ;;
        3) order=(6 1 2 4) ;;
    esac
    for workers in "${order[@]}"; do
        cores -n "$workers" -- python3 "$script" --compiler "$root" --corpus "$corpus" --workers "$workers" --tasks "$((workers * 4))" >> "$out/scaling.jsonl"
    done
    printf 'round %s complete\n' "$round"
done
CORES_TITLE='Buster system-wide memory and energy control' cores -n 6 -- \
    perf stat -a --no-big-num -x ';' -o "$out/uncore-load.csv" \
    -e 'amd_umc/umc_cas_cmd.rd/,amd_umc/umc_cas_cmd.wr/,power/energy-pkg/,power_core/energy-core/' -- \
    python3 "$script" --compiler "$root" --corpus "$corpus" --workers 6 --tasks 96 > "$out/uncore-load.json"
CORES_TITLE='Buster idle memory and energy control' cores -n 6 -- \
    perf stat -a --no-big-num -x ';' -o "$out/uncore-idle.csv" \
    -e 'amd_umc/umc_cas_cmd.rd/,amd_umc/umc_cas_cmd.wr/,power/energy-pkg/,power_core/energy-core/' -- sleep 5

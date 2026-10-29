#!/usr/bin/env bash
set -euo pipefail
compiler=$(realpath "${1:?usage: zen5-scaling.sh COMPILER CORPUS OUT SCALING_SCRIPT}")
corpus=$(realpath "${2:?}")
out=$(realpath "${3:?}")
script=$(realpath "${4:?}")
export EXCLUSIVE_OWNER=codex-microarch-20261029 EXCLUSIVE_TITLE='Buster 9700X compile scaling' EXCLUSIVE_LINK='https://github.com/buster14a/buster-performance/pull/120'
export SOURCE_DATE_EPOCH=1792454400 LC_ALL=C
unset CPATH C_INCLUDE_PATH || true
lock="$HOME/buster-fast-bench/exclusive.sh"
: > "$out/scaling.jsonl"
for round in 0 1 2 3 4; do
    case $round in
        0|4) order=(1 2 4 8) ;;
        1) order=(2 4 8 1) ;;
        2) order=(4 8 1 2) ;;
        3) order=(8 1 2 4) ;;
    esac
    for workers in "${order[@]}"; do
        case $workers in 1) cpus=2 ;; 2) cpus=2,3 ;; 4) cpus=2,3,4,5 ;; 8) cpus=0-7 ;; esac
        "$lock" timeout 90 taskset -c "$cpus" python3 "$script" --compiler "$compiler" --corpus "$corpus" \
            --workers "$workers" --tasks "$((workers*4))" >> "$out/scaling.jsonl"
    done
    printf 'round %s complete\n' "$round"
done
"$lock" timeout 90 perf stat -a -C 0-7 --no-big-num -x ';' -o "$out/uncore-load.csv" \
    -e 'amd_umc/umc_cas_cmd.rd/,amd_umc/umc_cas_cmd.wr/,power/energy-pkg/,power_core/energy-core/' -- \
    taskset -c 0-7 python3 "$script" --compiler "$compiler" --corpus "$corpus" --workers 8 --tasks 128 > "$out/uncore-load.json"
"$lock" timeout 30 perf stat -a -C 0-7 --no-big-num -x ';' -o "$out/uncore-idle.csv" \
    -e 'amd_umc/umc_cas_cmd.rd/,amd_umc/umc_cas_cmd.wr/,power/energy-pkg/,power_core/energy-core/' -- sleep 5

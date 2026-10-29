#!/usr/bin/env bash
set -euo pipefail
compiler=$(realpath "${1:?usage: ir-passes.sh COMPILER OUT}")
out=$(realpath "${2:?}")
mkdir -p "$out/ir-passes"
export CORES_TITLE='Buster IR pass microarchitecture' CORES_LINK='https://github.com/buster14a/buster'
for round in 0 1 2; do
    for length in 1024 4096; do
        for pass in gvn licm; do
            cores -n 1 -- bash -c 'exec taskset -c "${CORES_CPUS%%,*}" "$@"' pin \
                "$compiler" benchmark-ir-optimize-passes --pass "$pass" --instructions "$length" --samples 21 \
                > "$out/ir-passes/$pass-$length-$round.txt" 2>&1
        done
    done
done

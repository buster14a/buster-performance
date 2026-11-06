#!/bin/bash
# The split probe: each configuration's counters, pinned to CPU 2, under the 9700X's lock (run by exclusive.sh).
cd ~/buster-fast-bench/1555-claude/probe
clang -O2 -march=znver5 -o split-probe split-probe.c || exit 1
sha256sum split-probe split-probe.c
for cfg in "0 0 32" "0 40 32" "1 40 8" "1 40 24" "1 40 32" "1 0 8" "2 40 16" "2 56 16" "3 0 64" "3 1 64" "4 0 0"; do
    for rep in 1 2 3; do
        printf '%s rep %s: ' "$cfg" "$rep"
        perf stat -x, -e cycles:u,instructions:u,ls_misal_loads.ma64:u,ls_misal_loads.ma4k:u,ls_dispatch.ld_dispatch:u taskset -c 2 ./split-probe $cfg 20000 2>&1 >/dev/null | awk -F, '{printf "%s=%s ", $3, $1} END {print ""}'
    done
done

#!/bin/bash
# The load-bound split probe, pinned to CPU 2, under the 9700X's lock (run by exclusive.sh).
cd ~/buster-fast-bench/1555-claude/probe
clang -O2 -march=znver5 -o split-probe2 split-probe2.c || exit 1
sha256sum split-probe2 split-probe2.c
objdump -d --no-show-raw-insn split-probe2 | grep -c -E "vmovdqu|vpaddq.*\(" 
for cfg in "32 0" "32 40" "33 0" "33 40" "64 0" "64 1" "64 32"; do
    for rep in 1 2 3; do
        printf '%s rep %s: ' "$cfg" "$rep"
        perf stat -x, -e cycles:u,instructions:u,ls_misal_loads.ma64:u,ls_dispatch.ld_dispatch:u taskset -c 2 ./split-probe2 $cfg 20000 2>&1 >/dev/null | awk -F, '{printf "%s=%s ", $3, $1} END {print ""}'
    done
done
echo probe2-done

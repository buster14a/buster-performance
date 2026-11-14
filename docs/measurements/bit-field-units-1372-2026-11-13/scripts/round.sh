#!/bin/bash
# One round of #1372's kernel measurements, run under one hold of the 9700X's lock: each variant's executable (k_bits by
# that compiler, the same clang -O2 driver) perf stat'd 5 times on CPU 2, in this round's rotation of the variants.
set -euo pipefail
cd ~/buster-fast-bench/1372-claude
round=$1
variants=(base-tier0 head-tier0 base-tier1 head-tier1 clang-O0 clang-O2)
events=cycles:u,instructions:u,ls_bad_status2.stli_other:u,ls_stlf:u
count=${#variants[@]}
for i in $(seq 0 $((count - 1))); do
    v=${variants[$(( (i + round) % count ))]}
    perf stat -x, -r 5 -e "$events" -o "out/perf-$v-$round.csv" taskset -c 2 "out/bench-$v" 50000000 > "out/result-$v-$round.txt"
    echo "round $round $v"
done

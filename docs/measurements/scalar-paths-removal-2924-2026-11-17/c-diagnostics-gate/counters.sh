#!/bin/bash
# #2959: hardware counters of the radix sort's two states. Eight processes of the gate's executable, ASLR on, each
# `benchmark-diagnostics --only selected` under perf stat, under the lock on CPU 2; each process's state from its 4,096
# row (about 43 or about 62 ns/key).
set -uo pipefail
cd "$(dirname "$0")"
export EXCLUSIVE_OWNER=claude-2924 EXCLUSIVE_TITLE="Scalar paths removed: diagnostics' radix states (#2959)" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2959
L=~/buster-fast-bench/exclusive.sh
mkdir -p logs/counters
E=cycles,instructions,ls_bad_status2.stli_other,ls_stlf,ls_misal_loads.ma4k,ls_misal_loads.ma64,ls_l1_d_tlb_miss.all,de_dispatch_stall_cycle_dynamic_tokens_part1.store_queue_rsrc_stall,de_dispatch_stall_cycle_dynamic_tokens_part1.load_queue_rsrc_stall,ex_ret_brn_misp
for run in 1 2 3 4 5 6 7 8; do
    $L timeout -k 5 300 taskset -c 2 perf stat -x, -e "$E" -o logs/counters/perf-$run.csv ./compiler-gate benchmark-diagnostics --only selected > logs/counters/run-$run.log 2>&1
    echo "run $run: $? $(grep -E ' 4096 ' logs/counters/run-$run.log)" >> logs/counters/status.txt
done
date -u +%FT%TZ > logs/counters/.done

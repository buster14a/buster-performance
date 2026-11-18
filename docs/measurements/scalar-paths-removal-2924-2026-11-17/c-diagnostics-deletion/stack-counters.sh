#!/bin/bash
# #2924 C6: counters of head's benchmark-diagnostics at a slow stack pad (0) and a fast one (16), ASLR off, two runs
# each, under the lock on CPU 2.
set -uo pipefail
cd "$(dirname "$0")"
export EXCLUSIVE_OWNER=claude-2924 EXCLUSIVE_TITLE="Scalar paths removed: diagnostics' small rows, counters" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2924
L=~/buster-fast-bench/exclusive.sh
mkdir -p logs/stack-counters
E=cycles,instructions,ls_bad_status2.stli_other,ls_stlf,ls_misal_loads.ma64,ls_misal_loads.ma4k
for run in 1 2; do
    for pad in 0 16; do
        p=$(head -c "$pad" /dev/zero | tr '\0' x)
        PAD="$p" $L timeout -k 5 120 setarch -R taskset -c 2 perf stat -x, -e "$E" -o logs/stack-counters/perf-$pad-$run.csv ./compilers/head benchmark-diagnostics > logs/stack-counters/run-$pad-$run.log 2>&1
        echo "pad $pad run $run: $? $(grep -E ' 32: ' logs/stack-counters/run-$pad-$run.log | sed 's/ TSC.*//')" >> logs/stack-counters/status.txt
    done
done
date -u +%FT%TZ > logs/stack-counters/.done

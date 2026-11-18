#!/bin/bash
# #2924 C6: is the radix sort's bimodal rate (43 or 62 ns/key a process) the process's stack placement? The gate's
# executable with ASLR off (setarch -R), each run's stack shifted by an environment variable of PAD bytes, under the
# lock on CPU 2. Twice ASLR on as the control.
set -uo pipefail
cd "$(dirname "$0")"
export EXCLUSIVE_OWNER=claude-2924 EXCLUSIVE_TITLE="Scalar paths removed: diagnostics' radix by stack placement" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2924
L=~/buster-fast-bench/exclusive.sh
mkdir -p logs/stack
for pad in 0 0 64 512 1024 1536 2048 2560 3072 3584 4096; do
    p=$(head -c "$pad" /dev/zero | tr '\0' x)
    PAD="$p" $L timeout -k 5 300 setarch -R taskset -c 2 ./compiler-gate benchmark-diagnostics --only selected > logs/stack/pad-$pad.log 2>&1
    echo "pad $pad: $? $(grep -E ' (32|4096) ' logs/stack/pad-$pad.log | tr '\n' ' ')" >> logs/stack/status.txt
done
for run in 1 2; do
    $L timeout -k 5 300 taskset -c 2 ./compiler-gate benchmark-diagnostics --only selected > logs/stack/aslr-$run.log 2>&1
    echo "aslr $run: $? $(grep -E ' (32|4096) ' logs/stack/aslr-$run.log | tr '\n' ' ')" >> logs/stack/status.txt
done
date -u +%FT%TZ > logs/stack/.done

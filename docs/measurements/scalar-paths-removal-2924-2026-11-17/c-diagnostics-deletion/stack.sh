#!/bin/bash
# #2924 C6: head's 32-record row read 11.32 ns/key in one process of three (4.53-4.60 in the others). With ASLR off,
# the stack shifted by an environment variable of PAD bytes in 16-byte steps from 0 to 1,008, under the lock on CPU 2.
set -uo pipefail
cd "$(dirname "$0")"
export EXCLUSIVE_OWNER=claude-2924 EXCLUSIVE_TITLE="Scalar paths removed: diagnostics' small rows by stack placement" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2924
L=~/buster-fast-bench/exclusive.sh
mkdir -p logs/stack
for pad in $(seq 0 16 1008); do
    p=$(head -c "$pad" /dev/zero | tr '\0' x)
    PAD="$p" $L timeout -k 5 120 setarch -R taskset -c 2 ./compilers/head benchmark-diagnostics > logs/stack/pad-$pad.log 2>&1
    echo "pad $pad: $? $(grep -E ' (32|64): ' logs/stack/pad-$pad.log | sed 's/ TSC.*//' | tr '\n' ' ')" >> logs/stack/status.txt
done
date -u +%FT%TZ > logs/stack/.done

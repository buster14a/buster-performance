#!/bin/bash
# The wide selection alone (X_SHAPE=1, X_REPS=40), ASLR off, under 16 environment pads of 16 bytes: does the rate follow
# the stack's placement? Both experiment builds, one locked run each.
set -uo pipefail
cd "$(dirname "$0")"
export EXCLUSIVE_OWNER=claude-2924 EXCLUSIVE_TITLE="Scalar paths removed: Tier 1's selection" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2924
L=~/buster-fast-bench/exclusive.sh
rm -rf stack; mkdir -p stack
for p in $(seq 0 15); do
    pad=$(head -c $((p * 16)) /dev/zero | tr '\0' x)
    for side in base head; do
        $L timeout -k 5 300 env X_SHAPE=1 X_REPS=40 BUSTER_PAD="$pad" taskset -c 2 setarch -R ./shape/$side benchmark-tier1-select --only vector > stack/out-$side-$p.txt 2>&1
        echo "$side $p: $?" >> stack/status.txt
    done
done
date -u +%FT%TZ > stack/.done

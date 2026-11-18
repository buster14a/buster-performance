#!/bin/bash
# benchmark-tier1-select's shapes by build under 16 environment pads (the stack moves 16 bytes a pad), one locked run each.
set -uo pipefail
cd ~/buster-fast-bench/2924-c-df-claude/c7b
export EXCLUSIVE_OWNER=claude-2924 EXCLUSIVE_TITLE="Scalar paths removed: Tier 1's selection" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2924
L=~/buster-fast-bench/exclusive.sh
mkdir -p pad
for p in $(seq 0 15); do
    pad=$(head -c $((p * 16)) /dev/zero | tr '\0' x)
    for side in base head; do
        $L timeout -k 5 300 env BUSTER_PAD="$pad" taskset -c 2 ./compilers/$side benchmark-tier1-select --only vector > pad/out-$side-$p.txt 2>&1
        echo "$side $p: $?" >> pad/status.txt
    done
done
date -u +%FT%TZ > pad/.done

#!/bin/bash
# Fresh copies of base and head: benchmark-tier1-select profiled by symbol, cycles and instructions, and the hot
# functions' sizes.
set -uo pipefail
cd "$(dirname "$0")"
export EXCLUSIVE_OWNER=claude-2924 EXCLUSIVE_TITLE="Scalar paths removed: Tier 1's selection" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2924
L=~/buster-fast-bench/exclusive.sh
rm -rf prof; mkdir -p prof
for side in base head; do
    cp compilers/$side prof/$side
    $L timeout -k 5 300 taskset -c 2 perf record -q -e cycles:u,instructions:u -c 100003 -o prof/$side.data ./prof/$side benchmark-tier1-select --only vector > prof/out-$side.txt 2>&1
    echo "record $side: $?" >> prof/status.txt
    for ev in cycles:u instructions:u; do
        perf report -i prof/$side.data --event $ev -n --no-children --sort symbol --stdio 2>/dev/null | grep -v "^#" | grep -v "^$" | head -25 > prof/report-$side-${ev%:u}.txt
    done
    nm -S --size-sort prof/$side | grep -i " t tier1_select\| t tier1_burs\| T tier1_select" | tail -25 > prof/sizes-$side.txt
    rm -f prof/$side
done
date -u +%FT%TZ > prof/.done

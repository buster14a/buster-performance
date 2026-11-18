#!/bin/bash
# The wide shape's selection: instructions and cycles by build, then a profile by symbol of each.
set -uo pipefail
cd ~/buster-fast-bench/2924-c-df-claude/c7b
export EXCLUSIVE_OWNER=claude-2924 EXCLUSIVE_TITLE="Scalar paths removed: Tier 1's selection" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2924
L=~/buster-fast-bench/exclusive.sh
mkdir -p wide
for round in 1 2; do
    for side in base head; do
        $L timeout -k 5 300 taskset -c 2 perf stat -x, -e instructions:u,cycles:u -o wide/stat-$side-$round.txt ./compilers/$side benchmark-tier1-select --only vector > wide/out-$side-$round.txt 2>&1
        echo "stat $side $round: $?" >> wide/status.txt
    done
done
for side in base head; do
    $L timeout -k 5 300 taskset -c 2 perf record -q -e cycles:u -c 200003 -o wide/perf-$side.data ./compilers/$side benchmark-tier1-select --only vector > /dev/null 2>&1
    echo "record $side: $?" >> wide/status.txt
    perf report -i wide/perf-$side.data --no-children --sort symbol --stdio 2>/dev/null | grep -v "^#" | grep -v "^$" | head -40 > wide/report-$side.txt
done
date -u +%FT%TZ > wide/.done

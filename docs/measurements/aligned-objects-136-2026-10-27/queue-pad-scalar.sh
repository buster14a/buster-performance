#!/usr/bin/env bash
# The layout control for the scalar path: perf stat of benchmark-backend --only scalar for main, the padded main and the
# fix, twice each, in one hold. Run detached (setsid -f).
set -u
cd "$(dirname "$0")"
export EXCLUSIVE_OWNER=claude-aligned-136 EXCLUSIVE_TITLE="Objects aligned past 16 (#136): layout control, scalar" EXCLUSIVE_LINK="https://github.com/buster14a/buster/issues/136"
mkdir -p counters-pad-scalar
~/buster-fast-bench/exclusive.sh bash -c "for t in main mainpad fix main mainpad fix; do taskset -c 2 perf stat -x, -e cycles:u,instructions:u,branch-misses:u,L1-icache-load-misses:u,ic_tag_hit_miss.instruction_cache_miss:u ./\$t/build/compiler benchmark-backend --only scalar >> counters-pad-scalar/\$t.out 2>> counters-pad-scalar/\$t.perf; done"
echo "done $(date -Is)" >> queue-pad-scalar.log

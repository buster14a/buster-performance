#!/usr/bin/env bash
# bound16-limits.sh: bound 16's tables measured with the generator's limits raised (states 4096, representers 256, pool
# 262144 entries), so that its counts are known rather than only its failure at the shipped limits; a copy of t-bound16,
# built and its test-tier1-select summary printed, one hold of the shared lock each.
. ~/buster-fast-bench/claude-141-takeover/common.sh
t=t-bound16-limits
rm -rf $t && cp -a t-bound16 $t && rm -rf $t/build
f=$t/src/buster/compiler/tier1_select_burs.c
sed -i 's/^#define BUSTER_TIER1_BURS_MAX_STATES 1024u$/#define BUSTER_TIER1_BURS_MAX_STATES 4096u/; s/^#define BUSTER_TIER1_BURS_MAX_REPRESENTERS 128u$/#define BUSTER_TIER1_BURS_MAX_REPRESENTERS 256u/; s/^#define BUSTER_TIER1_BURS_POOL 32768u$/#define BUSTER_TIER1_BURS_POOL 262144u/' $f
grep -n '^#define BUSTER_TIER1_BURS_\(BOUND\|MAX_STATES\|MAX_REPRESENTERS\|POOL\) ' $f
./build.sh $t
"$lock" bash -c "cd $t && ./build/compiler test-tier1-select 2>&1 | grep -E 'bottom-up rewrite:|selection:|FAIL' | head -20"

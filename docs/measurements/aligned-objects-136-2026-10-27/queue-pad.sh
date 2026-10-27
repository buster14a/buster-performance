#!/usr/bin/env bash
# The layout control: main's tree with 14,928 bytes of padding at the start of tier0_benchmark.c's code (the shift of the
# fix's tier0_compile in that unit, 0x3a50), built under the lock, then perf stat of benchmark-backend --only vector for
# main, the padded main and the fix, twice each, in one hold. Run detached (setsid -f).
set -u
cd "$(dirname "$0")"
export EXCLUSIVE_OWNER=claude-aligned-136 EXCLUSIVE_TITLE="Objects aligned past 16 (#136): layout control" EXCLUSIVE_LINK="https://github.com/buster14a/buster/issues/136"
lock=~/buster-fast-bench/exclusive.sh
rm -rf mainpad && mkdir mainpad && (cd main && tar -cf - --exclude=./build .) | (cd mainpad && tar -xf -)
f=mainpad/src/buster/compiler/tier0_benchmark.c
{ printf '%s\n' '// Layout control for #136'"'"'s A/B, not for main: moves this unit'"'"'s code by 14,928 bytes, as the branch moved it.' '__asm__(".text\n.skip 14928, 0xcc\n");'; cat "$f"; } > "$f.new" && mv "$f.new" "$f"
(cd mainpad && "$lock" env BUSTER_DEBUG_INFO=0 ./build.sh > build.log 2>&1) || { echo "build mainpad failed" >> queue-pad.log; exit 1; }
echo "built mainpad $(date -Is)" >> queue-pad.log
for t in main mainpad; do nm --defined-only $t/build/compiler | awk '$3=="tier0_compile" || $3=="tier0_generate" || $3=="tier0_emit_deferred" || $3=="run_backend_benchmark" {print $3, $1}' > addresses-$t.txt; done
mkdir -p counters-pad
"$lock" bash -c 'for t in main mainpad fix main mainpad fix; do taskset -c 2 perf stat -x, -e cycles:u,instructions:u,branch-misses:u,L1-icache-load-misses:u,ic_tag_hit_miss.instruction_cache_miss:u ./$t/build/compiler benchmark-backend --only vector >> counters-pad/$t.out 2>> counters-pad/$t.perf; done'
echo "done $(date -Is)" >> queue-pad.log

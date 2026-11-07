#!/bin/bash
# 786-claude: perf stat of benchmark-ir's 32-instruction function (--only vector, cfg, scalar) and of
# benchmark-ir-optimize's scalar path for each tree's shifted builds, pinned to CPU 2, user-space counters: cycles,
# instructions, taken branches, op-cache accesses and misses and the dispatch slots the front end left empty. One hold
# of the 9700X's lock runs it all (about a minute).
#   ./perf.sh OUT TREE...
set -u
cd ~/buster-fast-bench/786-claude
export EXCLUSIVE_OWNER=claude-786 EXCLUSIVE_TITLE="Solve 786 (IR verifier/CFG/optimizer placements)" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/786
if [ "$1" != --held ]; then
    exec ~/buster-fast-bench/exclusive.sh ./perf.sh --held "$@"
fi
out=$2
shift 2
mkdir -p "$out"
events=cycles:u,instructions:u,ex_ret_brn_tkn:u,op_cache_hit_miss.all_op_cache_accesses:u,op_cache_hit_miss.op_cache_miss:u,de_no_dispatch_per_slot.no_ops_from_frontend:u
for bytes in ${SHIFTS:-0 640 1344 2048 2752 3456}; do
    for tree in "$@"; do
        exe=shifts-$tree/compiler-$bytes
        for only in vector cfg scalar; do
            perf stat -x, -e "$events" -o "$out/$tree-$bytes-ir32-$only.csv" taskset -c 2 "$exe" benchmark-ir --instructions 32 --only "$only" > /dev/null 2>&1
        done
        perf stat -x, -e "$events" -o "$out/$tree-$bytes-optimize-scalar.csv" taskset -c 2 "$exe" benchmark-ir-optimize --only scalar > /dev/null 2>&1
        echo "$(date +%T) $tree $bytes"
    done
done
echo perf-done

#!/bin/bash
# fe.sh NAME...: front-end counters of each listed benchmark, p and ph2 at placement 0, 3 runs each, under the lock.
d=$HOME/buster-fast-bench/2559-step5b-claude
cd "$d/base" || exit 2
unset CPATH C_INCLUDE_PATH
export SOURCE_DATE_EPOCH=1792454400
ev=cycles:u,instructions:u,ic_tag_hit_miss.instruction_cache_miss:u,op_cache_hit_miss.op_cache_miss:u,bp_l1_tlb_fetch_hit.all:u,de_no_dispatch_per_slot.no_ops_from_frontend:u,ex_ret_brn_misp:u
for name in "$@"; do
    line=$(awk -F"\t" -v n="$name" '$1 == n' "$d/inputs/benchmarks.txt")
    IFS=$'\t' read -r _ cpus arguments <<< "$line"
    read -r -a argv <<< "$arguments"
    c=${CANDIDATE:-ph2}; for side in p $c p $c p $c; do
        printf '%s %s ' "$name" "$side"
        taskset -c "$cpus" perf stat -x, -e "$ev" -- "$d/placements/$side/compiler-0" "${argv[@]}" 2>&1 > /dev/null | awk -F, '{printf "%s=%s ", $3, $1} END {print ""}'
    done
done

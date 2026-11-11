#!/usr/bin/env bash
# perf stat of main.c -c on CPU 2: every event group (no multiplexing) of every build, one process each, builds' order
# alternating by round. One round per call (run under the lock by campaign.sh). Usage: pstat.sh OUT ROUND NAME=EXE...
set -u
W=$HOME/buster-fast-bench/2270-claude; TMPDIR=$W/tmp
out=$1; r=$2; shift 2
src=$W/head/src
args=(-c -march=native -I"$src" -fwrapv -funsigned-char "$src/buster/compiler/main.c" -o /dev/null)
groups=(
 "cycles:u,instructions:u,L1-dcache-load-misses:u,ls_l1_d_tlb_miss.all:u,ls_l1_d_tlb_miss.all_l2_miss:u,ls_misal_loads.ma4k:u"
 "cycles:u,l2_cache_req_stat.ic_dc_miss_in_l2:u,ic_tag_hit_miss.instruction_cache_miss:u,bp_l1_tlb_miss_l2_tlb_hit:u,bp_l1_tlb_miss_l2_tlb_miss.all:u,ls_bad_status2.stli_other:u"
 "cycles:u,de_no_dispatch_per_slot.backend_stalls:u,de_no_dispatch_per_slot.no_ops_from_frontend:u,branch-misses:u,ls_stlf:u,ls_dmnd_fills_from_sys.local_l2:u"
 "cycles:k,cycles:u,page-faults,ls_hw_pf_dc_fills.all:u,ls_dmnd_fills_from_sys.all:u,l2_request_g1.all_no_prefetch:u"
)
for g in "${!groups[@]}"; do
  list=("$@"); if (( (r + g) % 2 == 0 )); then list=($(printf '%s\n' "$@" | tac)); fi
  for b in "${list[@]}"; do
    name=${b%%=*}; exe=${b#*=}
    tmp=$TMPDIR/pstat.$$
    perf stat -x, -o "$tmp" -e "${groups[$g]}" taskset -c 2 "$exe" "${args[@]}" > /dev/null 2>&1 || echo "fail $name" >&2
    grep -v '^#' "$tmp" | grep . | awk -F, -v n="$name" -v r="$r" -v g="$g" '{print r"\t"g"\t"n"\t"$3"\t"$1}' >> "$out"
  done
done

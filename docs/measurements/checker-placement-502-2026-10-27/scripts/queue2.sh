#!/usr/bin/env bash
# What tells the sweep's fast and slow placements apart: three groups of front-end, branch and TLB counters on its
# extremes, by turns; then copies of two executables (the same bytes in other pages) beside them, three rounds.
set -u
here="$HOME/buster-fast-bench/checker-placement-502"
cd "$here"
. "$HOME/buster-fast-bench/pp-117-templates/args.sh"
r=results
cp bin/align-s16 bin/align-s16c; cp bin/main-s16 bin/main-s16c
sha256sum bin/align-s16 bin/align-s16c bin/main-s16 bin/main-s16c > $r/sha2.txt
groups=(
    cycles:u,ic_tag_hit_miss.instruction_cache_miss:u,op_cache_hit_miss.op_cache_miss:u,bp_l2_btb_correct:u,bp_de_redirect:u,ex_ret_brn_misp:u
    cycles:u,de_no_dispatch_per_slot.no_ops_from_frontend:u,de_no_dispatch_per_slot.backend_stalls:u,bp_redirects.resync:u,ls_bad_status2.stli_other:u,ex_ret_brn_ind_misp:u
    cycles:u,bp_l1_tlb_miss_l2_tlb_hit:u,bp_l1_tlb_miss_l2_tlb_miss.all:u,l2_request_g1.cacheable_ic_read:u,de_dispatch_stall_cycle_dynamic_tokens_part1.taken_brnch_buffer_rsrc:u,bp_dyn_ind_pred:u
)
for g in 0 1 2; do
    for b in main-s16 main-s128 main-s0 align-s64 align-s1024; do
        ./locked.sh taskset -c 2 perf stat -r 11 -x, -e "${groups[$g]}" "$here/bin/$b" -fsyntax-only "${sqlite[@]}" \
            > /dev/null 2> $r/counters2-g$g-$b.txt
    done
done
set -- align-s16 align-s16c align-s64 main-s16 main-s16c
for round in 1 2 3; do
    for b in "$@"; do
        ./locked.sh taskset -c 2 perf stat -r 21 -x, -e cycles:u,instructions:u "$here/bin/$b" -fsyntax-only "${sqlite[@]}" \
            > /dev/null 2> $r/copy2-$b-$round.txt
    done
    set -- "${@:2}" "$1"
done
echo done > $r/queue2.done

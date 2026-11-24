#!/bin/bash
# characterize.sh NAME: the direct path's microarchitectural readings for bin/direct-NAME on the frozen sqlite3.c:
# Zen 5's pipeline-slot accounting, the front end, branches, the backend's stalls, memory and the op mix, each from
# 40 compiles in one process on CPU 2 in user mode, then samples by function for the events that say where.
# One hold of the lock.
set -uo pipefail
here=$HOME/buster-fast-bench/2850-direct-tx5wvj
name=$1
out=$here/results/$name/uarch
mkdir -p "$out"
C=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
hargs=(--predefines "$C/provenance/gnu17-pinned-predefines.txt" -isystem "$C/headers/usr/lib/clang/23/include" -isystem "$C/headers/usr/local/include" -isystem "$C/headers/usr/include"
       -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$C/sqlite" "$C/sqlite/sqlite3.c")
obj=/dev/shm/direct-tx5wvj-$name.u.o
run=(taskset -c 2 "$here/bin/direct-$name" "${hargs[@]}" -o "$obj" --repeat 40)
{ date -u +%FT%TZ; cat /proc/loadavg; ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | head -6; } > "$out/host.txt" 2>&1
stat() { # stat FILE EVENTS: one group of at most six counters, user mode
    perf stat --all-user -x ';' --no-big-num -e "$2" -o "$out/$1.csv" -- "${run[@]}" > /dev/null 2>&1
}
metric() { # metric FILE METRICS
    perf stat --all-user -M "$2" -o "$out/$1.txt" -- "${run[@]}" > /dev/null 2>&1
}
metric tma-l1 frontend_bound,bad_speculation,backend_bound,retiring,smt_contention
metric tma-l2-front frontend_bound_by_latency,frontend_bound_by_bandwidth
metric tma-l2-spec bad_speculation_from_mispredicts,bad_speculation_from_pipeline_restarts
metric tma-l2-back backend_bound_by_memory,backend_bound_by_cpu
metric tma-l2-retire retiring_from_fastpath,retiring_from_microcode
metric caches-l1 all_data_cache_accesses_pti,all_l1_data_cache_fills_pti,l1_demand_data_cache_fills_from_local_l2_pti,l1_demand_data_cache_fills_from_same_ccx_pti,l1_demand_data_cache_fills_from_near_memory_pti
metric caches-l2 all_l2_cache_accesses_pti,all_l2_cache_misses_pti,l2_cache_misses_from_l1_dc_miss_pti,l2_cache_misses_from_l1_ic_miss_pti,l2_cache_misses_from_l2_hwpf_pti
metric tlb l1_dtlb_misses_pti,l2_dtlb_misses_pti,l1_itlb_misses_pti,l2_itlb_misses_pti
metric frontend-ratios op_cache_fetch_miss_ratio,ic_fetch_miss_ratio,macro_ops_dispatched,macro_ops_retired
metric misc sse_avx_stalls,branch_misprediction_rate
stat core cycles,ex_ret_instr,ex_ret_ops,de_src_op_disp.all,ex_ret_fused_instr,ex_ret_ucode_ops
stat slots de_no_dispatch_per_slot.no_ops_from_frontend,de_no_dispatch_per_slot.backend_stalls,de_no_dispatch_per_slot.smt_contention,de_src_op_disp.all,ex_ret_ops,cycles
stat frontend de_src_op_disp.op_cache,de_src_op_disp.x86_decoder,de_op_queue_empty,ic_tag_hit_miss.instruction_cache_miss,ic_cache_fill_l2,ic_cache_fill_sys
stat redirects bp_redirects.all,bp_redirects.ex_redir,bp_redirects.resync,bp_de_redirect,bp_l2_btb_correct,bp_dyn_ind_pred
stat branches ex_ret_brn,ex_ret_brn_misp,ex_ret_cond,ex_ret_msprd_brnch_instr_dir_msmtch,ex_ret_brn_tkn,ex_ret_brn_tkn_misp
stat branches2 ex_ret_ind_brch_instr,ex_ret_brn_ind_misp,ex_ret_near_ret,ex_ret_near_ret_mispred,ex_ret_uncond_brnch_instr,ex_ret_uncond_brnch_instr_mispred
stat stalls1 de_dispatch_stall_cycle_dynamic_tokens_part1.int_phy_reg_file_rsrc_stall,de_dispatch_stall_cycle_dynamic_tokens_part1.load_queue_rsrc_stall,de_dispatch_stall_cycle_dynamic_tokens_part1.store_queue_rsrc_stall,de_dispatch_stall_cycle_dynamic_tokens_part1.taken_brnch_buffer_rsrc,de_dispatch_stall_cycle_dynamic_tokens_part1.fp_sch_rsrc_stall,cycles
stat stalls2 de_dispatch_stall_cycle_dynamic_tokens_part2.ag_tokens,de_dispatch_stall_cycle_dynamic_tokens_part2.al_tokens,de_dispatch_stall_cycle_dynamic_tokens_part2.ex_flush_recovery,de_dispatch_stall_cycle_dynamic_tokens_part2.retq,de_additional_resource_stalls.dispatch_stalls,cycles
stat noretire ex_no_retire.all,ex_no_retire.empty,ex_no_retire.load_not_complete,ex_no_retire.not_complete,ex_no_retire.other,cycles
stat loadstore ls_dispatch.ld_dispatch,ls_dispatch.store_dispatch,ls_dispatch.ld_st_dispatch,ls_stlf,ls_bad_status2.stli_other,ls_misal_loads.ma64
stat fills ls_dmnd_fills_from_sys.all,ls_dmnd_fills_from_sys.local_l2,ls_dmnd_fills_from_sys.local_ccx,ls_dmnd_fills_from_sys.dram_io_near,ls_hw_pf_dc_fills.all,ls_hw_pf_dc_fills.dram_io_near
stat fills2 ls_any_fills_from_sys.all,ls_any_fills_from_sys.local_l2,ls_any_fills_from_sys.local_ccx,ls_any_fills_from_sys.dram_io_near,ls_mab_alloc.load_store_allocations,ls_mab_alloc.hardware_prefetcher_allocations
stat l2 l2_cache_req_stat.dc_access_in_l2,l2_cache_req_stat.dc_hit_in_l2,l2_cache_req_stat.ic_access_in_l2,l2_cache_req_stat.ic_dc_miss_in_l2,l2_pf_hit_l2.l2_hwpf,l2_pf_miss_l2_hit_l3.l2_hwpf
stat l2b l2_pf_miss_l2_l3.l2_hwpf,l2_fill_rsp_src.local_ccx,l2_fill_rsp_src.dram_io_near,l2_request_g1.rd_blk_x,l2_request_g1.rd_blk_l,l2_wcb_req.wcb_close
stat tlbs ls_l1_d_tlb_miss.all,ls_l1_d_tlb_miss.all_l2_miss,ls_l1_d_tlb_miss.tlb_reload_4k_l2_hit,ls_l1_d_tlb_miss.tlb_reload_2m_l2_hit,bp_l1_tlb_miss_l2_tlb_hit,bp_l1_tlb_miss_l2_tlb_miss.all
stat vector fp_ops_retired_by_width.pack_512_uops_retired,fp_ops_retired_by_width.pack_256_uops_retired,fp_ops_retired_by_width.pack_128_uops_retired,fp_ops_retired_by_width.scalar_uops_retired,fp_ops_retired_by_type.vector_all,ex_ret_ops
stat vector2 fp_ops_retired_by_type.vector_cmp,fp_ops_retired_by_type.vector_logical,fp_ops_retired_by_type.vector_shuffle,fp_ops_retired_by_type.vector_mov,fp_ops_retired_by_type.vector_blend,fp_ops_retired_by_type.vector_other
stat misc2 ex_div_count,ex_div_busy,ls_int_taken,ls_locks.all,ex_ret_ucode_instr,ls_st_commit_cancel2.st_commit_cancel_wcb_full
# user and kernel together, for the whole process's split
perf stat -x ';' --no-big-num -e cycles:u,cycles:k,instructions:u,instructions:k,page-faults,minor-faults -o "$out/userkernel.csv" -- "${run[@]}" > /dev/null 2>&1
# samples by function
sample() { # sample FILE EVENT PERIOD
    perf record -q -e "$2" -c "$3" -o "$out/$1.data" -- "${run[@]}" > /dev/null 2>&1
    perf report -i "$out/$1.data" --no-children --sort symbol -g none 2> /dev/null | grep -v '^$' | head -70 > "$out/$1.txt"
    rm -f "$out/$1.data"
}
sample by-cycles cycles:u 20011
sample by-instructions ex_ret_instr:u 50021
sample by-branch-misses ex_ret_brn_misp:u 211
sample by-frontend-slots de_no_dispatch_per_slot.no_ops_from_frontend:u 20011
sample by-backend-slots de_no_dispatch_per_slot.backend_stalls:u 20011
sample by-load-not-complete ex_no_retire.load_not_complete:u 2003
sample by-l1-fills ls_dmnd_fills_from_sys.all:u 211
sample by-any-fills ls_any_fills_from_sys.all:u 211
sample by-dram-fills ls_any_fills_from_sys.dram_io_near:u 53
sample by-decoder-ops de_src_op_disp.x86_decoder:u 20011
sample by-512-ops fp_ops_retired_by_width.pack_512_uops_retired:u 5003
sample by-stlf-fail ls_bad_status2.stli_other:u 211
sample by-kernel-cycles cycles:k 5003
{ cat /proc/loadavg; ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | head -6; date -u +%FT%TZ; } >> "$out/host.txt" 2>&1
rm -f "$obj"
echo done > "$out/done"

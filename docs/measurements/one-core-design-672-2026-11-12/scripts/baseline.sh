#!/bin/bash
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md.
#
# baseline.sh PART: the frozen sqlite3.c's -c by src/build/compiler, pinned to CPU 2; run each PART inside its own
# hold of the 9700X's lock (lock.sh ./baseline.sh PART).
#   stages    measure-compile's stage table against tcc (the 9700X job's compile_time step, 11 runs)
#   counters  six counter groups perf never multiplexes, 5 compiles each
#   profile   leader-sampled groups by function (8 compiles each) and the cycles profile with the kernel
#   chains    cycles and instructions with DWARF call chains, for the stages' and their callees' inclusive shares
set -u
cd "$(dirname "$0")"
part=${1:?a part}
out=results/baseline
mkdir -p "$out" scratch
sqlite=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
options=(-c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$sqlite" "$sqlite/sqlite3.c")
compiler=src/build/compiler
export LC_ALL=C
status=0
head -1 /var/lib/buster-9700x/owner > "$out/$part.holder.txt"
printf -v loop '%q ' taskset -c 2 "$compiler" "${options[@]}" -o scratch/sqlite3.o
case $part in
    stages)
        printf '%s  %s\n' 0a409f1633283fa31a9126b11fbfd64a1991c5d30defad07e5745d4667f5e23d "$sqlite/sqlite3.c" | sha256sum --check > "$out/corpus.txt" 2>&1 || status=1
        tcc -v > "$out/tcc.txt" 2>&1; sha256sum "$(command -v tcc)" "$compiler" >> "$out/tcc.txt"
        taskset -c 2 "$compiler" measure-compile --runs 11 --reference "$(command -v tcc)" -- "${options[@]}" > "$out/measure-compile.txt" 2>&1 || status=1
        taskset -c 2 "$compiler" --time-stages "${options[@]}" -o scratch/sqlite3.o > "$out/time-stages.txt" 2>&1 || status=1
        sha256sum scratch/sqlite3.o > "$out/object.txt" ;;
    counters)
        command=("$compiler")
        group()
        {
            local name=$1; shift
            taskset -c 2 perf stat -x, -r 5 -o "$out/stat-$name.csv" "$@" -- "${command[@]}" "${options[@]}" -o scratch/sqlite3.o > /dev/null 2>&1 || status=1
        }
        group basic -e '{cycles:u,instructions:u,cycles:k,instructions:k}' -e task-clock,page-faults,minor-faults,major-faults,context-switches
        group td1 -e '{ls_not_halted_cyc:u,de_src_op_disp.all:u,ex_ret_ops:u,de_no_dispatch_per_slot.no_ops_from_frontend:u,de_no_dispatch_per_slot.backend_stalls:u}'
        group td2 -e '{ls_not_halted_cyc:u,ex_no_retire.load_not_complete:u,ex_no_retire.not_complete:u,cpu/de_no_dispatch_per_slot.no_ops_from_frontend,cmask=8/u,ex_ret_ucode_ops:u}'
        group br -e '{instructions:u,ex_ret_brn:u,ex_ret_brn_misp:u,ex_ret_brn_tkn:u,bp_redirects.resync:u}'
        group fe -e '{instructions:u,ic_tag_hit_miss.instruction_cache_miss:u,op_cache_hit_miss.op_cache_miss:u,op_cache_hit_miss.all_op_cache_accesses:u,bp_l1_tlb_miss_l2_tlb_miss.all:u}'
        group mem -e '{instructions:u,ls_dmnd_fills_from_sys.all:u,ls_dmnd_fills_from_sys.dram_io_near:u,l2_cache_req_stat.ic_dc_miss_in_l2:u,ls_l1_d_tlb_miss.all:u}'
        group mem2 -e '{instructions:u,ls_dmnd_fills_from_sys.local_l2:u,ls_dmnd_fills_from_sys.local_ccx:u,ls_hw_pf_dc_fills.dram_io_near:u,ls_bad_status2.stli_other:u}'
        command=("$(command -v tcc)")
        group tcc -e '{cycles:u,instructions:u,cycles:k,instructions:k}' -e task-clock,page-faults
        ;;
    profile)
        record()
        {
            local name=$1; shift
            perf record -q -o "scratch/$name.data" "$@" -- bash -c "for i in 1 2 3 4 5 6 7 8; do $loop > /dev/null 2>&1 || exit 1; done" > "$out/$name.record.log" 2>&1 || status=1
        }
        record cycles -e cycles -c 100003
        perf report -i scratch/cycles.data --no-children --sort dso,sym --stdio -q --percent-limit 0.05 > "$out/cycles.txt" 2>> "$out/cycles.record.log" || status=1
        perf report -i scratch/cycles.data --no-children --sort dso --stdio -q > "$out/cycles-dso.txt" 2>> "$out/cycles.record.log" || status=1
        record work -e '{cycles:u,instructions:u,ex_ret_brn_misp:u,ls_dmnd_fills_from_sys.all:u,ls_dmnd_fills_from_sys.dram_io_near:u}:S' -c 50021
        perf script -i scratch/work.data -F period,event,ip,sym 2>> "$out/work.record.log" | ./uarch symbols - > "$out/work.tsv" || status=1
        record td1 -e '{ls_not_halted_cyc:u,de_src_op_disp.all:u,ex_ret_ops:u,de_no_dispatch_per_slot.no_ops_from_frontend:u,de_no_dispatch_per_slot.backend_stalls:u}:S' -c 50021
        perf script -i scratch/td1.data -F period,event,ip,sym 2>> "$out/td1.record.log" | ./uarch symbols - > "$out/td1.tsv" || status=1
        ;;
    chains)
        perf record -q -o scratch/chains.data -e '{cycles:u,instructions:u}:S' -c 200003 --call-graph dwarf,16384 -- \
            bash -c "for i in 1 2 3 4; do $loop > /dev/null 2>&1 || exit 1; done" > "$out/chains.record.log" 2>&1 || status=1
        ;;
    *) echo "unknown part $part" >&2; status=1 ;;
esac
if ((status == 0)); then date -u +%FT%TZ > "$out/$part.done"; fi
exit $status

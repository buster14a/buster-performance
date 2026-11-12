#!/bin/bash
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md.
#
# stagecounters.sh CORPUS GROUP [RUNS]: counters by stage and by function. Each run is one --tier1 -c compile of
# CORPUS by the instrumented tree on CPU 2, on one lane, under a leader-sampled perf group whose samples carry
# CLOCK_MONOTONIC_RAW times (-k), with that run's own lap log beside it (laps.patch: the TSC at every stage's end,
# anchored on the same clock), so that a reducer puts each sample in the lap its time falls in. GROUP is one of work,
# td, lat, mem (the events below); RUNS runs (default 6) inside one hold of the lock.
set -u
cd "$(dirname "$0")"
here=$PWD
source ./corpora.sh
name=${1:?a corpus}
group=${2:?a group}
runs=${3:-6}
options_name="${name}_options[@]"; files_name="${name}_files[@]"
options=("${!options_name}"); files=("${!files_name}")
compiler=$here/inst/build/compiler
out=$here/results/stagecounters/$name
work=$here/scratch/stagecounters-$name-$group
mkdir -p "$out" "$work"
export LC_ALL=C
status=0
head -1 /var/lib/buster-9700x/owner > "$out/$group.holder.txt"
case $group in
    work) events='{cycles:u,instructions:u,ex_ret_brn_misp:u,ls_dmnd_fills_from_sys.all:u,ls_dmnd_fills_from_sys.dram_io_near:u}:S' ;;
    td) events='{ls_not_halted_cyc:u,de_src_op_disp.all:u,ex_ret_ops:u,de_no_dispatch_per_slot.no_ops_from_frontend:u,de_no_dispatch_per_slot.backend_stalls:u}:S' ;;
    lat) events='{ls_not_halted_cyc:u,ex_no_retire.load_not_complete:u,op_cache_hit_miss.op_cache_miss:u,ls_dmnd_fills_from_sys.local_l2:u,ls_dmnd_fills_from_sys.local_ccx:u}:S' ;;
    mem) events='{cycles:u,ls_l1_d_tlb_miss.all:u,ls_bad_status2.stli_other:u,ex_ret_brn_tkn:u,ex_ret_brn:u}:S' ;;
    kernel) events='{cycles,cycles:k,instructions:k,page-faults}:S' ;;
    *) echo "unknown group $group" >&2; exit 1 ;;
esac
cd "$work" || exit 1
# One uncounted compile first: the first process of a hold has run its first stages slower.
taskset -c 2 "$compiler" --tier1 "${options[@]}" --lanes 1 -c "${files[@]}" > /dev/null 2>&1 || status=1
for ((r = 1; r <= runs; r += 1)); do
    BUSTER_T1_LAPS="$out/$group-$r.laps" taskset -c 5 perf record -q -T -k CLOCK_MONOTONIC_RAW -o "$work/sc.data" -e "$events" -c 100003 -- \
        taskset -c 2 "$compiler" --tier1 "${options[@]}" --lanes 1 -c "${files[@]}" > /dev/null 2> "$out/$group-$r.record.log" || status=1
    perf script --ns -i "$work/sc.data" -F time,period,event,ip,sym 2>> "$out/$group.script.log" | gzip -c > "$out/$group-$r.samples.gz" || status=1
    rm -f "$work/sc.data"
    gzip -f "$out/$group-$r.laps"
done
cd "$here" && rm -rf "$work"
if ((status == 0)); then date -u +%FT%TZ > "$out/$group.done"; fi
exit $status

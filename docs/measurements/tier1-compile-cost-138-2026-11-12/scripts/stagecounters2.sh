#!/bin/bash
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md.
#
# stagecounters2.sh CORPUS GROUP RUNS TREE LABEL [NAME=VALUE]...: stagecounters.sh for another tree's compiler and with
# variables in the compiler's environment (the prototypes' switches), into results/stagecounters-LABEL/CORPUS. Run
# inside one hold of the lock.
set -u
cd "$(dirname "$0")"
here=$PWD
source ./corpora.sh
name=${1:?a corpus}
group=${2:?a group}
runs=${3:?runs}
tree=${4:?a tree}
label=${5:?a label}
shift 5
options_name="${name}_options[@]"; files_name="${name}_files[@]"
options=("${!options_name}"); files=("${!files_name}")
compiler=$here/$tree/build/compiler
out=$here/results/stagecounters-$label/$name
work=$here/scratch/stagecounters-$label-$name-$group
mkdir -p "$out" "$work"
export LC_ALL=C
status=0
head -1 /var/lib/buster-9700x/owner > "$out/$group.holder.txt"
sha256sum "$compiler" > "$out/compiler.txt"
printf '%s\n' "$@" > "$out/environment.txt"
case $group in
    work) events='{cycles:u,instructions:u,ex_ret_brn_misp:u,ls_dmnd_fills_from_sys.all:u,ls_dmnd_fills_from_sys.dram_io_near:u}:S' ;;
    td) events='{ls_not_halted_cyc:u,de_src_op_disp.all:u,ex_ret_ops:u,de_no_dispatch_per_slot.no_ops_from_frontend:u,de_no_dispatch_per_slot.backend_stalls:u}:S' ;;
    lat) events='{ls_not_halted_cyc:u,ex_no_retire.load_not_complete:u,op_cache_hit_miss.op_cache_miss:u,ls_dmnd_fills_from_sys.local_l2:u,ls_dmnd_fills_from_sys.local_ccx:u}:S' ;;
    *) echo "unknown group $group" >&2; exit 1 ;;
esac
cd "$work" || exit 1
env "$@" taskset -c 2 "$compiler" --tier1 "${options[@]}" --lanes 1 -c "${files[@]}" > /dev/null 2>&1 || status=1
for ((r = 1; r <= runs; r += 1)); do
    env "$@" BUSTER_T1_LAPS="$out/$group-$r.laps" taskset -c 5 perf record -q -T -k CLOCK_MONOTONIC_RAW -o "$work/sc.data" -e "$events" -c 100003 -- \
        taskset -c 2 "$compiler" --tier1 "${options[@]}" --lanes 1 -c "${files[@]}" > /dev/null 2> "$out/$group-$r.record.log" || status=1
    perf script --ns -i "$work/sc.data" -F time,period,event,ip,sym 2>> "$out/$group.script.log" | gzip -c > "$out/$group-$r.samples.gz" || status=1
    rm -f "$work/sc.data"
    gzip -f "$out/$group-$r.laps"
done
cd "$here" && rm -rf "$work"
if ((status == 0)); then date -u +%FT%TZ > "$out/$group.done"; fi
exit $status

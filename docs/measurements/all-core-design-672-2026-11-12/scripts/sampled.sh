#!/bin/bash
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md.
#
# sampled.sh TAG UNIT WORKERS GROUP [LOOPS]: counters by stage, the one-core record's method run on every worker's CPU
# at once, inside one hold of the lock. One cohort of UNIT's -c (--lanes 1 --time-stages; LOOPS compiles a worker, 6 by
# default at 1 worker and 3 at 8) under `perf record -a` on the workers' CPUs alone, a leader-sampled group with sample
# times on CLOCK_MONOTONIC, the clock the cohort's rows are on; then `allcore buckets` puts every sample in the run and
# the stage its time falls in, each run's stages from its own report, for each worker's runs but its first and last
# (which the other workers don't overlap as the runs between are) and without the worker on CPU 0 where a stray process
# shared its core (the strays file says where it was). TAG names the unit in the labels (sq, whole,
# spine); WORKERS is w1 or w8; GROUP is one of:
#   work  {cycles:u,instructions:u,ex_ret_brn_misp:u,ls_dmnd_fills_from_sys.all:u,ls_dmnd_fills_from_sys.dram_io_near:u}
#   lat   {ls_not_halted_cyc:u,ex_no_retire.load_not_complete:u,de_no_dispatch_per_slot.backend_stalls:u,
#          ls_dmnd_fills_from_sys.local_l2:u,ls_dmnd_fills_from_sys.local_ccx:u}
#   kern  {cycles,cycles:k,instructions:k,l2_fill_rsp_src.dram_io_near:u,l2_fill_rsp_src.dram_io_near:k}: sampled in
#         both modes, so the kernel's cycles and both modes' L2 fills from DRAM by stage and by function
# The samples' text stays in scratch/ (it is large); the record keeps the reductions.
set -u
cd "$(dirname "$0")"
. ./common.sh
tag=${1:?a tag} unit=${2:?a unit} workers=${3:?w1 or w8} group=${4:?a group}
label="$tag-$group.$workers"
cpus=$(cpus_of "$label") || exit 1
loops=${5:-$([[ $workers == w1 ]] && echo 6 || echo 5)}
out=results/sampled
mkdir -p "$out/stages" scratch
status=0
head -1 /var/lib/buster-9700x/owner > "$out/$label.holder.txt"
case $group in
    work) events='{cycles:u,instructions:u,ex_ret_brn_misp:u,ls_dmnd_fills_from_sys.all:u,ls_dmnd_fills_from_sys.dram_io_near:u}:S' ;;
    lat) events='{ls_not_halted_cyc:u,ex_no_retire.load_not_complete:u,de_no_dispatch_per_slot.backend_stalls:u,ls_dmnd_fills_from_sys.local_l2:u,ls_dmnd_fills_from_sys.local_ccx:u}:S' ;;
    kern) events='{cycles,cycles:k,instructions:k,l2_fill_rsp_src.dram_io_near:u,l2_fill_rsp_src.dram_io_near:k}:S' ;;
    *) echo "unknown group $group" >&2; exit 1 ;;
esac
: > "$out/$label.strays.txt"
strays "$out" "$label" before
perf record -q -a -C "$cpus" -k CLOCK_MONOTONIC -T -m 16M -o "scratch/$label.data" -e "$events" -c 100003 -- \
    ./allcore cohort --cpus "$cpus" --loops "$loops" --label "$label" --out "$out/$label.rows.tsv" --stderr "$out/stages/$label.w%w.r%i.txt" -- \
    "$compiler" --time-stages --lanes 1 -c "${SQLITE_OPTIONS[@]}" "$unit" -o "scratch/$label.w%w.o" > "$out/$label.record.log" 2>&1 || status=1
strays "$out" "$label" after
perf report -i "scratch/$label.data" --stats 2>> "$out/$label.record.log" | grep -E 'SAMPLE|LOST|THROTTLE' >> "$out/$label.record.log"
perf script -i "scratch/$label.data" --ns -F cpu,pid,tid,time,period,event,ip,sym 2>> "$out/$label.record.log" | gzip -1 -c > "scratch/$label.samples.gz" || status=1
rm -f "scratch/$label.data"
# The cores a stray shared: its CPU, or the CPU whose sibling it is (8 and 9 are 0's and 1's, 11 to 15 are 3's to 7's).
without=$(awk '{ c = $3; if (c >= 8) c -= 8; if (c != 2 || '"$([[ $workers == w1 ]] && echo 0 || echo 1)"') print c }' "$out/$label.strays.txt" | sort -un | paste -sd, -)
[[ $workers == w1 ]] && without=
# A stray's own samples are left out by its process ID.
pids=$(awk '{ print $7 }' "$out/$label.strays.txt" | sort -un | paste -sd, -)
./allcore buckets --rows "$out/$label.rows.tsv" --stages "$out/stages/$label.w%w.r%i.txt" --samples "scratch/$label.samples.gz" --interior --without "${without:--}" --without-pid "${pids:--}" --functions 30 \
    --families families.tsv > "$out/$label.buckets.tsv" 2>> "$out/$label.record.log" || status=1
echo "without ${without:--}" >> "$out/$label.record.log"
if ((status == 0)); then date -u +%FT%TZ > "$out/$label.done"; fi
exit $status

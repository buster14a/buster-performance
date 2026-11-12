#!/bin/bash
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md.
#
# stagecounters.sh [RUNS]: counters by stage. Each run is one `-c --time-stages` compile of the frozen sqlite3.c on
# CPU 2 under a leader-sampled perf group with sample times, with that run's own stage report beside it, so that a
# reducer can put every sample in the stage its time falls in. Three groups, RUNS runs each (default 6), inside one
# hold of the lock. DWARF call chains gave empty stacks here (the driver's frame starts at an untouched page), hence
# the times.
set -u
cd "$(dirname "$0")"
runs=${1:-6}
out=results/stagecounters
mkdir -p "$out" scratch
sqlite=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
options=(-c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$sqlite" "$sqlite/sqlite3.c")
compiler=src/build/compiler
export LC_ALL=C
status=0
head -1 /var/lib/buster-9700x/owner > "$out/holder.txt"
group()
{
    local name=$1 events=$2 r
    for ((r = 1; r <= runs; r += 1)); do
        taskset -c 5 perf record -q -T -o "scratch/sc-$name-$r.data" -e "$events" -c 100003 -- \
            taskset -c 2 "$compiler" --time-stages "${options[@]}" -o scratch/sqlite3.o > /dev/null 2> "$out/$name-$r.stages.txt" || status=1
        perf script -i "scratch/sc-$name-$r.data" -F time,period,event,ip,sym 2>> "$out/script.log" | gzip -c > "$out/$name-$r.samples.gz" || status=1
        rm -f "scratch/sc-$name-$r.data"
    done
}
group work '{cycles:u,instructions:u,ex_ret_brn_misp:u,ls_dmnd_fills_from_sys.all:u,ls_dmnd_fills_from_sys.dram_io_near:u}:S'
group td '{ls_not_halted_cyc:u,de_src_op_disp.all:u,ex_ret_ops:u,de_no_dispatch_per_slot.no_ops_from_frontend:u,de_no_dispatch_per_slot.backend_stalls:u}:S'
group lat '{ls_not_halted_cyc:u,ex_no_retire.load_not_complete:u,op_cache_hit_miss.op_cache_miss:u,ls_dmnd_fills_from_sys.local_l2:u,ls_dmnd_fills_from_sys.local_ccx:u}:S'
if ((status == 0)); then date -u +%FT%TZ > "$out/.done"; fi
exit $status

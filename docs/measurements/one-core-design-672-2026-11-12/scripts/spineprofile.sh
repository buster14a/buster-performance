#!/bin/bash
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md.
#
# spineprofile.sh: the whole preprocessed unit's and its file scope's -c by function, inside one hold of the lock: 8
# compiles of each on CPU 2 under the leader-sampled work group, reduced by uarch symbols. A function's difference is
# what the function bodies cost in it.
set -u
cd "$(dirname "$0")"
out=results/spine
mkdir -p "$out" scratch
compiler=src/build/compiler
export LC_ALL=C
status=0
head -1 /var/lib/buster-9700x/owner > "$out/profile.holder.txt"
for name in sqlite3 sqlite3-spine; do
    printf -v loop '%q ' taskset -c 2 "$compiler" -c "scratch/$name.i" -o "scratch/$name-profile.o"
    taskset -c 5 perf record -q -o "scratch/$name.data" -e '{cycles:u,instructions:u,ex_ret_brn_misp:u,ls_dmnd_fills_from_sys.all:u,ls_dmnd_fills_from_sys.dram_io_near:u}:S' -c 100003 -- \
        bash -c "for i in 1 2 3 4 5 6 7 8; do $loop > /dev/null 2>&1 || exit 1; done" > "$out/$name.record.log" 2>&1 || status=1
    perf script -i "scratch/$name.data" -F period,event,ip,sym 2>> "$out/$name.record.log" | ./uarch symbols - > "$out/$name.work.tsv" || status=1
    rm -f "scratch/$name.data"
done
if ((status == 0)); then date -u +%FT%TZ > "$out/profile.done"; fi
exit $status

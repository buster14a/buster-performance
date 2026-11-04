#!/bin/bash
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md.
# stat1236.sh: where head's extra user cycles on the one-line -c go (ab1236b.sh and ab1236c.sh read +2% net of the
# floor, over placements too). perf stat -r 51 on CPU 2 of base's and head's build/compiler, two event groups of at most
# six (no multiplexing), user mode, the trees alternating, three rounds; one lock hold per round.
cd ~/buster-fast-bench/1236-claude/in
export LC_ALL=C EXCLUSIVE_OWNER=claude-1236 EXCLUSIVE_TITLE="#1236 object_prepare part boundaries: perf stat" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/1236
L=~/buster-fast-bench/exclusive.sh
G1=cycles:u,instructions:u,ls_dmnd_fills_from_sys.all:u,ls_dmnd_fills_from_sys.dram_io_all:u,ls_l1_d_tlb_miss.all:u,ls_bad_status2.stli_other:u
G2=cycles:u,ex_ret_brn_misp:u,l2_cache_req_stat.ic_fill_miss:u,ls_any_fills_from_sys.all:u,ls_hw_pf_dc_fills.all:u,cycles:k
for round in 1 2 3; do
    $L sh -c '
        for g in "$1" "$2"; do
            for t in base head; do
                printf "== stat %s %s: " "$0" "$t"
                taskset -c 2 perf stat -x, -r 51 -e "$g" ../$t/build/compiler -c tiny.c -o tiny.o 2>&1 >/dev/null | awk -F, "{printf \"%s=%s \", \$3, \$1} END {printf \"\"}"
                echo "status=$?"
            done
        done' $round "$G1" "$G2"
done
echo done

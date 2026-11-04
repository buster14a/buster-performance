#!/bin/bash
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md.
# stat1236b.sh: stat1236.sh's perf stat -r 51 (one executable back to back) read head's user cycles below base's, where
# time-runs (the executables alternating) read them 2% above. This counts one process at a time with the executables
# alternating as time-runs does (base, head, base-again, rotated by iteration), 41 iterations a round, three rounds, one
# lock hold per round, on CPU 2: each process's user cycles and instructions, L1 dTLB misses and demand fills.
cd ~/buster-fast-bench/1236-claude/in
cp ../base/build/compiler ../base-again-compiler
export LC_ALL=C EXCLUSIVE_OWNER=claude-1236 EXCLUSIVE_TITLE="#1236 object_prepare part boundaries: alternating perf stat" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/1236
L=~/buster-fast-bench/exclusive.sh
sha256sum ../base/build/compiler ../base-again-compiler ../head/build/compiler
for round in 1 2 3; do
    $L bash -c '
        E=cycles:u,instructions:u,ls_l1_d_tlb_miss.all:u,ls_dmnd_fills_from_sys.all:u,ls_any_fills_from_sys.all:u,cycles:k
        names=(base head base-again)
        paths=(../base/build/compiler ../head/build/compiler ../base-again-compiler)
        for i in $(seq 0 40); do
            for k in 0 1 2; do
                j=$(( (k + i) % 3 ))
                printf "== one %s %s %s: " "$0" "$i" "${names[$j]}"
                taskset -c 2 perf stat -x, -e "$E" ${paths[$j]} -c tiny.c -o tiny.o 2>&1 >/dev/null | awk -F, "{printf \"%s=%s \", \$3, \$1} END {printf \"\"}"
                echo "status=$?"
            done
        done' $round
done
echo done

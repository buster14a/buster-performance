#!/bin/bash
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md.
# campaign.sh: #652's 9700X runs, each build locked on its own and each measurement batch (a few seconds) locked on its
# own. Trees: m687 (#687 merged), pre956 and m956 (around #956), base (main 3ce71ec3), head (advice at commit) and
# head2 (head and .bss in base pages).
cd ~/buster-fast-bench/652-claude
export EXCLUSIVE_OWNER=claude-652 EXCLUSIVE_TITLE="solve 652" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/652
L=~/buster-fast-bench/exclusive.sh
for t in pre956 m956 head2; do
    [ -x $t/build/compiler ] || (cd $t && $L env BUSTER_HOST_ARCH=znver5 ./build.sh 2>&1 | tail -1)
done
[ -x reserve_bench ] || clang -O2 -Wall -Wextra -Werror -o reserve_bench reserve_bench.c
cp ~/buster-fast-bench/corpus-391e729af658/sqlite/sqlite3.c in/sqlite3.c
cd in
for round in 1 2 3; do
    $L sh -c '
        for t in m687 pre956 m956 base head head2; do
            for a in "-fsyntax-only empty.c" "-c tiny.c -o tiny.o"; do
                printf "== stat %s %s [%s]: " "$0" "$t" "$a"
                taskset -c 2 perf stat -x, -r 51 -e task-clock,page-faults,instructions:u,instructions:k ../$t/build/compiler $a 2>&1 >/dev/null | awk -F, "{printf \"%s=%s \", \$3, \$1} END {print \"\"}"
            done
        done
        for s in 956 lazy rw fixed two slab; do printf "== bench %s " "$0"; taskset -c 2 ../reserve_bench $s 90 401; done
        printf "== bench %s " "$0"; taskset -c 2 ../reserve_bench lazy 0 401' $round
done
for t in m687 pre956 m956 base head head2; do
    strace -f -c -o ../strace-$t.txt ../$t/build/compiler -fsyntax-only empty.c
    echo "== strace $t $(awk '$NF ~ /^(mmap|madvise|mprotect|prlimit64|munmap|total)$/ {printf "%s=%s ", $NF, $4}' ../strace-$t.txt)"
done
echo done

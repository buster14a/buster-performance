#!/bin/bash
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md.
# merge-ab.sh: #652's stacks' columns and file cache in the unit's arena of tables, after #1203, on the 9700X. Trees: base
# (main eac92264) and head (d02fb1ea, the PR's merge with it), each built with BUSTER_HOST_ARCH=znver5 under the lock.
# perf stat and strace of the small inputs, then ab of time-runs with base, head and base again (the floor), each
# executable from 3 fresh copies; every build and batch locked on its own.
cd ~/buster-fast-bench/652-claude/merge
export LC_ALL=C EXCLUSIVE_OWNER=claude-652 EXCLUSIVE_TITLE="#652 merge with main: A/B" EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/1237
L=~/buster-fast-bench/exclusive.sh
echo "== host $(uname -a)"
echo "== clang $(clang --version | head -1)"
echo "== perf $(perf --version)"
echo "== governor cpu2 $(cat /sys/devices/system/cpu/cpu2/cpufreq/scaling_governor) epp $(cat /sys/devices/system/cpu/cpu2/cpufreq/energy_performance_preference)"
echo "== thp $(cat /sys/kernel/mm/transparent_hugepage/enabled) defrag $(cat /sys/kernel/mm/transparent_hugepage/defrag)"
mkdir -p in && cd in
: > empty.c
printf 'int f(int x) { return x + 1; }\n' > tiny.c
cp ~/buster-fast-bench/corpus-391e729af658/sqlite/sqlite3.c sqlite3.c
sha256sum ../base/build/compiler ../head/build/compiler empty.c tiny.c sqlite3.c
for round in 1 2 3; do
    $L sh -c '
        for t in base head; do
            for a in "-fsyntax-only empty.c" "-c tiny.c -o tiny.o"; do
                printf "== stat %s %s [%s]: " "$0" "$t" "$a"
                taskset -c 2 perf stat -x, -r 51 -e task-clock,page-faults,instructions:u,instructions:k ../$t/build/compiler $a 2>&1 >/dev/null | awk -F, "{printf \"%s=%s \", \$3, \$1} END {printf \"\"}"
                echo "status=$?"
            done
        done' $round
done
for t in base head; do
    strace -f -c -o ../strace-$t.txt ../$t/build/compiler -fsyntax-only empty.c
    echo "== strace $t status=$? $(awk '$NF ~ /^(mmap|madvise|mprotect|munmap|total)$/ {printf "%s=%s ", $NF, $4}' ../strace-$t.txt)"
done
mkdir -p ~/.cache/claude-652-copies
B="--build base ../base/build/compiler --build head ../head/build/compiler --build base-again ../base/build/compiler"
run() {
    local rounds=$1 runs=$2; shift 2
    ../head/build/compiler ab --rounds "$rounds" --cpu 2 --lock $L ../head/build/compiler \
        -- time-runs --runs "$runs" --copies 3 --directory ~/.cache/claude-652-copies $B --list "$@"
    echo "== ab status=$? [$*]"
}
run 3 31 -fsyntax-only empty.c
run 3 31 -E -P empty.c -o /dev/null
run 3 31 -c tiny.c -o tiny.o
run 3 11 -E -P sqlite3.c -o /dev/null
run 3 7 -fsyntax-only sqlite3.c
run 3 7 -c sqlite3.c -o sqlite3.o
echo done

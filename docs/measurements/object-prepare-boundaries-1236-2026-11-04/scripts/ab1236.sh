#!/bin/bash
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md.
# ab1236.sh: #1236, object_prepare's part boundaries sized by the units. Trees: base (main cdee12f2, the branch's
# merge-base) and head (84d0b572), each a git archive built with BUSTER_HOST_ARCH=znver5 under the lock. The anonymous
# huge pages of a one-line -c at exit (gdb, smaps), perf stat of that -c, then ab of time-runs with base, head and base
# again (the floor), each executable from 3 fresh copies: the one-line -c and sqlite3.c's -c. Every build and batch is
# locked on its own.
cd ~/buster-fast-bench/1236-claude
echo $$ > ab.pid
export LC_ALL=C EXCLUSIVE_OWNER=claude-1236 EXCLUSIVE_TITLE="#1236 object_prepare part boundaries: A/B" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/1236
L=~/buster-fast-bench/exclusive.sh
for t in base head; do
    (cd $t && $L env BUSTER_HOST_ARCH=znver5 ./build.sh 2>&1 | grep -v -E "^exclusive.sh: waiting|^  (title|link|pull request):" | tail -1; exit ${PIPESTATUS[0]})
    echo "== build $t status=$? commit $(cat $t/COMMIT)"
done
echo "== host $(uname -a)"
echo "== cpu $(grep -m1 'model name' /proc/cpuinfo)"
echo "== clang $(clang --version | head -1)"
echo "== perf $(perf --version)"
echo "== gdb $(gdb --version | head -1)"
echo "== governor cpu2 $(cat /sys/devices/system/cpu/cpu2/cpufreq/scaling_governor) epp $(cat /sys/devices/system/cpu/cpu2/cpufreq/energy_performance_preference)"
echo "== thp $(cat /sys/kernel/mm/transparent_hugepage/enabled) defrag $(cat /sys/kernel/mm/transparent_hugepage/defrag)"
sha256sum base/build/compiler head/build/compiler in/tiny.c in/sqlite3.c
# Drive check: each tree's -c of both inputs, once, with its status.
$L sh -c '
    for t in base head; do
        ./$t/build/compiler -c in/tiny.c -o in/tiny-$t.o; echo "== drive $t tiny status=$?"
        ./$t/build/compiler -c in/sqlite3.c -o in/sqlite3-$t.o; echo "== drive $t sqlite3 status=$?"
    done'
cmp in/tiny-base.o in/tiny-head.o && echo "== objects tiny identical"
cmp in/sqlite3-base.o in/sqlite3-head.o && echo "== objects sqlite3 identical"
# The one-line -c's anonymous memory at exit.
$L sh -c '
    for t in base head; do
        echo "== smaps $t"
        gdb -q -batch -x scripts/smaps.gdb --args ./$t/build/compiler -c in/tiny.c -o in/tiny-smaps.o 2>&1 | grep -E "^anon|huge [1-9]"
    done'
cd in
for round in 1 2 3; do
    $L sh -c '
        for t in base head; do
            printf "== stat %s %s [-c tiny.c]: " "$0" "$t"
            taskset -c 2 perf stat -x, -r 51 -e task-clock,page-faults,instructions:u,instructions:k ../$t/build/compiler -c tiny.c -o tiny.o 2>&1 >/dev/null | awk -F, "{printf \"%s=%s \", \$3, \$1} END {printf \"\"}"
            echo "status=$?"
        done' $round
done
B="--build base ../base/build/compiler --build head ../head/build/compiler --build base-again ../base/build/compiler"
run() {
    local rounds=$1 runs=$2; shift 2
    ../head/build/compiler ab --rounds "$rounds" --cpu 2 --lock $L ../head/build/compiler \
        -- time-runs --runs "$runs" --copies 3 --directory ~/.cache/claude-1236-copies $B --list "$@"
    echo "== ab status=$? [$*]"
}
run 3 31 -c tiny.c -o tiny.o
run 3 7 -c sqlite3.c -o sqlite3.o
echo done

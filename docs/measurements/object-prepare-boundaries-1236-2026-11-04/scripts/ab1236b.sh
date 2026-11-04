#!/bin/bash
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md.
# ab1236b.sh: ab1236.sh's time-runs part again, whose first run failed because the copies' directory didn't exist
# (time-runs makes its directories under it). The same trees, builds and inputs; ab of time-runs with base, head and base
# again (the floor), each executable from 3 fresh copies, on CPU 2, each round locked on its own.
cd ~/buster-fast-bench/1236-claude
echo $$ > abb.pid
export LC_ALL=C EXCLUSIVE_OWNER=claude-1236 EXCLUSIVE_TITLE="#1236 object_prepare part boundaries: A/B" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/1236
L=~/buster-fast-bench/exclusive.sh
mkdir -p ~/.cache/claude-1236-copies
echo "== governor cpu2 $(cat /sys/devices/system/cpu/cpu2/cpufreq/scaling_governor) epp $(cat /sys/devices/system/cpu/cpu2/cpufreq/energy_performance_preference)"
echo "== thp $(cat /sys/kernel/mm/transparent_hugepage/enabled) defrag $(cat /sys/kernel/mm/transparent_hugepage/defrag)"
sha256sum base/build/compiler head/build/compiler in/tiny.c in/sqlite3.c
cd in
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

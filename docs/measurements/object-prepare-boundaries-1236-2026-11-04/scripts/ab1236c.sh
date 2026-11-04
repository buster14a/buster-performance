#!/bin/bash
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md.
# ab1236c.sh: #1236's builds over their code's placements (#509, docs/profiling.md "Comparing two versions"). ab1236b.sh
# read head's one-line -c +3.4% to +4.5% in user cycles against base, where base again read +0.8% to +1.3%, with 253
# fewer user instructions: this tells placement from work. Each tree's checker unit (main_unit_checker.c, which holds
# the -c driver and object_writer.c) is linked at six shifts across a page, multiples of its .text's alignment, 64,
# each build under the lock; then ab of
# time-runs with base, head and base again, every placement from 3 fresh copies.
cd ~/buster-fast-bench/1236-claude
echo $$ > abc.pid
export LC_ALL=C EXCLUSIVE_OWNER=claude-1236 EXCLUSIVE_TITLE="#1236 object_prepare part boundaries: placements A/B" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/1236
L=~/buster-fast-bench/exclusive.sh
shifts="0 704 1408 2048 2752 3456"
for t in base head; do
    (cd $t && $L env BUSTER_HOST_ARCH=znver5 ./build.sh shifts ../shifts/$t main_unit_checker.c $shifts 2>&1 | grep -v -E "^exclusive.sh: waiting|^  (title|link|pull request):" | tail -3; exit ${PIPESTATUS[0]})
    echo "== shifts $t status=$? commit $(cat $t/COMMIT)"
done
echo "== governor cpu2 $(cat /sys/devices/system/cpu/cpu2/cpufreq/scaling_governor) epp $(cat /sys/devices/system/cpu/cpu2/cpufreq/energy_performance_preference)"
echo "== thp $(cat /sys/kernel/mm/transparent_hugepage/enabled) defrag $(cat /sys/kernel/mm/transparent_hugepage/defrag)"
sha256sum shifts/base/compiler-* shifts/head/compiler-* in/tiny.c in/sqlite3.c
mkdir -p ~/.cache/claude-1236-copies
cd in
builds=()
for b in base:base head:head base-again:base; do
    for s in $shifts; do builds+=(--build "${b%%:*}" "../shifts/${b#*:}/compiler-$s"); done
done
run() {
    local rounds=$1 runs=$2; shift 2
    ../head/build/compiler ab --rounds "$rounds" --cpu 2 --lock $L ../head/build/compiler \
        -- time-runs --runs "$runs" --copies 3 --directory ~/.cache/claude-1236-copies "${builds[@]}" --list "$@"
    echo "== ab status=$? [$*]"
}
run 3 11 -c tiny.c -o tiny.o
run 3 1 -c sqlite3.c -o sqlite3.o
echo done

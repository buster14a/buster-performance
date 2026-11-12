#!/bin/bash
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md.
#
# env.sh: the host's and the measured trees' identities, read without a run (no lock): the kernel, the CPU and its
# online CPUs, CPUs 0 to 7's governors and EPP, transparent huge pages, the address space's randomization, the tools'
# versions, the two trees' commits and differences, and the hashes of the compilers, the corpus and these scripts.
# (After file-scope-design-672-2026-11-12's env.sh.)
cd "$(dirname "$0")"
mkdir -p results
{
    echo "## date"; date -u +%FT%TZ
    echo "## uname"; uname -a
    echo "## cpu"; grep -m1 'model name' /proc/cpuinfo; lscpu -e=CPU,CORE,ONLINE | head -20
    echo "## governors and EPP, CPUs 0-7"
    for c in 0 1 2 3 4 5 6 7; do
        echo "cpu$c $(cat /sys/devices/system/cpu/cpu$c/cpufreq/scaling_governor 2>/dev/null) $(cat /sys/devices/system/cpu/cpu$c/cpufreq/energy_performance_preference 2>/dev/null)"
    done
    echo "## THP"; cat /sys/kernel/mm/transparent_hugepage/enabled /sys/kernel/mm/transparent_hugepage/defrag
    echo "## randomize_va_space"; cat /proc/sys/kernel/randomize_va_space
    echo "## tools"; clang --version | head -1; perf --version; bash --version | head -1
    for w in main head; do
        echo "## $w"; git -C "$w" log -1 --format='%H %s'; git -C "$w" status --porcelain; git -C "$w" diff --stat
    done
    echo "## sha256"
    sha256sum main/build/compiler head/build/compiler
    sha256sum /var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite/sqlite3.c /var/lib/buster-9700x/corpora/preprocessor-391e729af658/MANIFESTS.sha256
    sha256sum ./*.sh
} > results/env.txt 2>&1
git -C head diff > results/head.diff

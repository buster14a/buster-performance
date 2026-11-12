#!/bin/bash
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md of buster14a/buster.
#
# env.sh: the host's and the measured tree's identities, read without a run (no lock): the kernel, the CPU and its
# online CPUs, CPUs 0 to 7's governors and EPP, transparent huge pages, memory, the file systems, the tools' versions,
# the source commit and the hashes of the compiler, the tools, the corpus's files and this directory's scripts.
cd "$(dirname "$0")"
. ./common.sh
mkdir -p results
{
    echo "## date"; date -u +%FT%TZ
    echo "## uname"; uname -a
    echo "## cpu"; grep -m1 'model name' /proc/cpuinfo; lscpu -e=CPU,CORE,ONLINE | head -20
    echo "## governors and EPP, CPUs 0-7"
    for n in 0 1 2 3 4 5 6 7; do
        echo "cpu$n $(cat /sys/devices/system/cpu/cpu$n/cpufreq/scaling_governor) $(cat /sys/devices/system/cpu/cpu$n/cpufreq/energy_performance_preference 2>/dev/null)"
    done
    echo "## THP"; cat /sys/kernel/mm/transparent_hugepage/enabled
    echo "## memory"; free -m | head -2
    echo "## file systems of the outputs and of the tree"; df -T $t "$here" | sed 's/  */ /g'
    echo "## perf_event_paranoid and max sample rate"; cat /proc/sys/kernel/perf_event_paranoid /proc/sys/kernel/perf_event_max_sample_rate
    echo "## PID 1 (the exit helper starts where it reaps orphans)"; cat /proc/1/comm
    echo "## tools"
    clang --version | head -1; gcc --version | head -1; tcc -v; ld.lld --version; mold --version; ld.bfd --version | head -1; ar --version | head -1
    perf --version; bash --version | head -1; pacman -Q glibc 2> /dev/null
    echo "## source"; cat COMMIT; git -C src status --porcelain | wc -l
    echo "## sha256"
    sha256sum src/build/compiler tools/procbench tools/medians tools/phasemedians tools/stagebuckets
    sha256sum /usr/bin/tcc /usr/lib/libtcc.so /usr/bin/clang /usr/bin/ld.lld /usr/bin/mold /usr/bin/ld.bfd /usr/bin/ar
    sha256sum "$sqlite/sqlite3.c" "$sqlite/shell.c" "$corpus/MANIFESTS.sha256" /usr/lib/libm.a /usr/lib/libc.a /usr/lib/libc.so.6 "$G/libgcc.a"
    sha256sum ./*.sh tools/*.c inputs/*.c
} > results/env.txt 2>&1

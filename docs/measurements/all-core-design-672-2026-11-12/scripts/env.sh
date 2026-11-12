#!/bin/bash
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md.
#
# env.sh: the host's and the measured tree's identities, read without a run (no lock): the kernel, the CPUs and which
# are online, every CPU's governor and EPP, the frequency driver, transparent huge pages, memory, the tools' versions,
# the source commit and the hashes of the compiler, the corpus's files and this directory's scripts.
cd "$(dirname "$0")"
mkdir -p results
{
    echo "## date"; date -u +%FT%TZ
    echo "## uname"; uname -a
    echo "## cpu"; grep -m1 'model name' /proc/cpuinfo; lscpu -e=CPU,CORE,ONLINE | head -20
    echo "## governors and EPP"
    for c in /sys/devices/system/cpu/cpu[0-9]*; do
        echo "${c##*/} $(cat "$c/cpufreq/scaling_governor" 2>/dev/null) $(cat "$c/cpufreq/energy_performance_preference" 2>/dev/null) $(cat "$c/cpufreq/scaling_max_freq" 2>/dev/null)"
    done
    echo "## frequency driver"; cat /sys/devices/system/cpu/cpufreq/policy0/scaling_driver /sys/devices/system/cpu/amd_pstate/status 2>/dev/null; cat /sys/devices/system/cpu/cpufreq/boost 2>/dev/null
    echo "## THP"; cat /sys/kernel/mm/transparent_hugepage/enabled /sys/kernel/mm/transparent_hugepage/defrag
    echo "## memory"; free -m | head -2; grep -E 'MemTotal|Hugepagesize|AnonHugePages' /proc/meminfo
    echo "## init_on_alloc and the NMI watchdog"; grep -o 'init_on_alloc=[0-9]' /proc/cmdline; zcat /proc/config.gz 2>/dev/null | grep -E 'CONFIG_INIT_ON_ALLOC_DEFAULT_ON|CONFIG_HZ=|CONFIG_PREEMPT_DYNAMIC'; cat /proc/sys/kernel/nmi_watchdog
    echo "## perf_event_paranoid, max sample rate, mlock kb"; cat /proc/sys/kernel/perf_event_paranoid /proc/sys/kernel/perf_event_max_sample_rate /proc/sys/kernel/perf_event_mlock_kb
    echo "## tools"; clang --version | head -1; perf --version; bash --version | head -1
    echo "## source"; cat COMMIT; git -C src status --porcelain | wc -l
    echo "## sha256"
    sha256sum src/build/compiler allcore tools/allcore.c
    sha256sum "/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite/sqlite3.c" /var/lib/buster-9700x/corpora/preprocessor-391e729af658/MANIFESTS.sha256
    sha256sum ./*.sh
} > results/env.txt 2>&1

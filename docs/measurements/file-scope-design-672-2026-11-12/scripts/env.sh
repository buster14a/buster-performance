#!/bin/bash
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md.
#
# env.sh: the host's and the measured trees' identities, read without a run (no lock): the kernel, the CPU and its
# online CPUs, CPUs 0 to 7's governors and EPP, transparent huge pages, memory, the tools' versions, the source commit
# and the hashes of the compilers, the corpus's files and this directory's scripts. (After the first record's env.sh.)
cd "$(dirname "$0")"
mkdir -p results
{
    echo "## date"; date -u +%FT%TZ
    echo "## uname"; uname -a
    echo "## cpu"; grep -m1 'model name' /proc/cpuinfo; lscpu -e=CPU,CORE,ONLINE | head -20
    echo "## governors and EPP, CPUs 0-7"
    for c in 0 1 2 3 4 5 6 7; do
        echo "cpu$c $(cat /sys/devices/system/cpu/cpu$c/cpufreq/scaling_governor) $(cat /sys/devices/system/cpu/cpu$c/cpufreq/energy_performance_preference 2>/dev/null)"
    done
    echo "## THP"; cat /sys/kernel/mm/transparent_hugepage/enabled; cat /sys/kernel/mm/transparent_hugepage/defrag
    echo "## memory"; free -m | head -2
    echo "## perf_event_paranoid and max sample rate"; cat /proc/sys/kernel/perf_event_paranoid /proc/sys/kernel/perf_event_max_sample_rate
    echo "## tools"; clang --version | head -1; perf --version; bash --version | head -1; python3 --version; tcc -v
    echo "## source"; cat COMMIT; git -C src status --porcelain | wc -l; git -C src-probe status --porcelain 2>/dev/null
    echo "## sha256"
    sha256sum src/build/compiler src-probe/build/compiler uarch /usr/bin/tcc
    sha256sum /var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite/sqlite3.c /var/lib/buster-9700x/corpora/preprocessor-391e729af658/MANIFESTS.sha256
    sha256sum ./*.sh ./*.patch tools/*
} > results/env.txt 2>&1

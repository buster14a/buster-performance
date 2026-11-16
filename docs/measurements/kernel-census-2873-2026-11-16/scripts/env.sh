#!/bin/bash
# env.sh: the host, its settings, the tools' versions and every input's, executable's and script's SHA-256 (env.txt).
cd "$(dirname "$0")"
sqlite=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite/sqlite3.c
{
    echo "== host"; uname -a; grep -m1 "model name" /proc/cpuinfo; nproc; cat /sys/devices/system/cpu/online
    echo "== governors"; for c in 2 4; do echo "cpu$c $(cat /sys/devices/system/cpu/cpu$c/cpufreq/scaling_governor)"; done
    echo "== transparent huge pages"; cat /sys/kernel/mm/transparent_hugepage/enabled /sys/kernel/mm/transparent_hugepage/defrag /sys/kernel/mm/transparent_hugepage/khugepaged/defrag
    echo "== kernel"; zcat /proc/config.gz | grep -E "^CONFIG_HZ=|^CONFIG_NO_HZ_FULL=|^CONFIG_UNWINDER_ORC=|^CONFIG_PREEMPT_DYNAMIC="; cat /proc/sys/kernel/perf_event_paranoid /proc/sys/kernel/perf_event_max_sample_rate
    echo "== memory"; grep -E "MemTotal|MemFree|MemAvailable" /proc/meminfo
    echo "== file systems"; df -T /tmp /dev/shm . "$(dirname "$sqlite")" | cat
    echo "== tools"; perf --version; strace --version | head -1; gdb --version | head -1; llvm-symbolizer --version | head -2; cc --version | head -1; setarch --version
    echo "== the builds' toolchain"; grep -m3 -i "clang version\|toolchain" build.log
    echo "== sources"; git -C src rev-parse HEAD; git -C census rev-parse HEAD; git -C census diff --stat
    echo "== sha256"; sha256sum "$sqlite" src/build/compiler census/build/compiler tools/* scripts/* *.sh
} > env.txt 2>&1

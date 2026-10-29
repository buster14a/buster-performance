#!/bin/bash
# #764: thprace's runs on the 9700X in one lock hold (about 20 s): the host, then one thread alone on CPU 2, then 2, 4
# and 8 threads on CPUs 2,0,1,3,4,5,6,7, each mode 64 rounds.
D=~/buster-fast-bench/claude-764
L="$D/logs/thprace.txt"
mkdir -p "$D/logs"
{
    echo "== $(date -Is) host"
    uname -a
    grep -m1 "model name" /proc/cpuinfo
    for c in 0 1 2 3 4 5 6 7; do echo "cpu$c $(cat /sys/devices/system/cpu/cpu$c/cpufreq/scaling_governor) $(cat /sys/devices/system/cpu/cpu$c/cpufreq/energy_performance_preference 2>/dev/null)"; done
    echo "thp enabled: $(cat /sys/kernel/mm/transparent_hugepage/enabled) defrag: $(cat /sys/kernel/mm/transparent_hugepage/defrag) use_zero_page: $(cat /sys/kernel/mm/transparent_hugepage/use_zero_page)"
    grep -E "^(MemFree|MemAvailable)" /proc/meminfo
    sha256sum "$D/tools/thprace.c" "$D/tools/thprace"
    for cpus in 2 2,0 2,0,1,3 2,0,1,3,4,5,6,7; do
        echo "== $(date -Is) thprace --cpus $cpus"
        "$D/tools/thprace" --cpus "$cpus" --rounds 64 --spin 3 distinct same same-zero distinct-zero base-same base-same-zero
        echo "exit=$?"
    done
} >> "$L" 2>&1

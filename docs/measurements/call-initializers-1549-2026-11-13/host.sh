#!/bin/bash
# A host snapshot beside the results.
cd ~/buster-fast-bench/1549-claude
{
    echo "== host"; uname -srvm; lscpu | grep -E '^(CPU\(s\)|On-line|Model name)'
    cat /sys/devices/system/cpu/cpu2/cpufreq/scaling_governor /sys/devices/system/cpu/cpu2/cpufreq/energy_performance_preference
    cat /sys/kernel/mm/transparent_hugepage/enabled
    clang --version | head -1; cmake --version | head -1; ninja --version
    for t in base head; do echo "$t $(git -C $t rev-parse HEAD) $(sha256sum < $t/build/compiler | cut -d' ' -f1)"; done
    sha256sum k/*.c *.sh
} > results/host.txt

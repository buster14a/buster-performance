#!/bin/bash
# The host's identity and both measured trees' manifests, under one lock hold (lock.sh): every file of each tree but the
# build's outputs (build/, build.log) and the COMMIT note the copy wrote, in git archive's form for comparison.
dir=$(cd "$(dirname "$0")" && pwd)
root=$(dirname "$dir")
{
    uname -a
    grep -m1 "model name" /proc/cpuinfo
    cat /sys/devices/system/cpu/cpu2/cpufreq/scaling_governor
    cat /sys/devices/system/cpu/cpu2/cpufreq/energy_performance_preference 2> /dev/null
    cat /sys/kernel/mm/transparent_hugepage/enabled
    clang --version | head -1
    cmake --version | head -1
    ninja --version
    perf --version
} > "$dir/host.txt"
for tree in main head; do
    (cd "$root/$tree" && cat COMMIT && find . -path ./build -prune -o -type f ! -name build.log ! -name COMMIT -print | LC_ALL=C sort | xargs -d '\n' sha256sum) > "$dir/$tree.host.sha256"
done

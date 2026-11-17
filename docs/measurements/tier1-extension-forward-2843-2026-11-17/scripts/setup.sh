#!/bin/bash
# The trees' Release builds (no debug info), each a hold of its own, and the host's identity. Each tree is `git archive`
# of its commit, unpacked here before this runs, with COMMIT holding the full hash. Usage: setup.sh
dir=$(cd "$(dirname "$0")" && pwd)
B=$(dirname "$dir")
for tree in main head; do
    (cd $B/$tree && BUSTER_DEBUG_INFO=0 LOCK_TIMEOUT=1200 "$dir/lock.sh" build-$tree ./build.sh --config Release > build.log 2>&1)
    status=$?
    echo "$tree $(cat $B/$tree/COMMIT) exit $status $(tail -2 $B/$tree/build.log | head -1)"
    sha256sum $B/$tree/build/compiler
done
{
    uname -a
    grep -m1 "model name" /proc/cpuinfo
    cat /sys/devices/system/cpu/cpu2/cpufreq/scaling_governor
    cat /sys/devices/system/cpu/cpu2/cpufreq/energy_performance_preference 2> /dev/null
    cat /sys/kernel/mm/transparent_hugepage/enabled
    clang --version | head -1
    perf --version
} > "$dir/host-identity.txt"

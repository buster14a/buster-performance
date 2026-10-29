#!/bin/bash
# Receipts for #785's record: the host, the toolchain, CPU 2's governor, the measured executables' SHA-256 and each
# measured tree's file manifest.
cd ~/buster-fast-bench/claude-784
out=~/buster-fast-bench/claude-784/out
{
    echo "== uname -a"; uname -a
    echo "== clang --version"; clang --version
    echo "== perf --version"; perf --version
    echo "== CPU 2"; cat /sys/devices/system/cpu/cpu2/cpufreq/scaling_governor /sys/devices/system/cpu/cpu2/cpufreq/energy_performance_preference
    echo "== lscpu model"; lscpu | grep -i "model name"
} > "$out/host.txt" 2>&1
sha256sum main/build/compiler head/build/compiler shifts/*/compiler-* > "$out/executables.sha256"
for tree in main head; do (cd $tree && find . -path ./build -prune -o -type f -print0 | sort -z | xargs -0 sha256sum) > "$out/manifest-$tree.sha256"; done
echo receipts done

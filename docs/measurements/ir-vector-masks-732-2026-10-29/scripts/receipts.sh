#!/bin/bash
# Receipts for #732's record: the host, the toolchain, CPU 2's governor, the measured executables' SHA-256 and each
# measured tree's file manifest, under one hold of the shared lock.
cd ~/buster-fast-bench/claude-732
out=~/buster-fast-bench/claude-732/out2
{
    echo "== uname -a"; uname -a
    echo "== clang --version"; clang --version
    echo "== perf --version"; perf --version
    echo "== CPU 2"; cat /sys/devices/system/cpu/cpu2/cpufreq/scaling_governor /sys/devices/system/cpu/cpu2/cpufreq/energy_performance_preference
    echo "== lscpu model"; lscpu | grep -i "model name"
} > "$out/host.txt" 2>&1
sha256sum main2/build/compiler head2/build/compiler > "$out/executables.sha256"
for t in main2 head2; do (cd $t && find . -path ./build -prune -o -type f -print0 | sort -z | xargs -0 sha256sum) > "$out/manifest-$t.sha256"; done
echo receipts done

#!/bin/bash
# receipts.sh A B: the host's and the runs' identities for an A/B of trees A and B (their commits, executables, input).
cd ~/buster-fast-bench/628-claude-tesla
echo "host: $(cat /proc/sys/kernel/hostname)"
echo "kernel: $(uname -r)"
echo "cpu: $(grep -m1 'model name' /proc/cpuinfo | cut -d: -f2 | sed 's/^ //')"
echo "cpu2 governor: $(cat /sys/devices/system/cpu/cpu2/cpufreq/scaling_governor)"
echo "cpu2 epp: $(cat /sys/devices/system/cpu/cpu2/cpufreq/energy_performance_preference 2>/dev/null)"
echo "thp: $(cat /sys/kernel/mm/transparent_hugepage/enabled)"
echo "clang: $(clang --version | head -1)"
echo "perf: $(perf --version)"
for tree in "$@"; do echo "$tree tree: $(git -C "$tree" rev-parse HEAD)"; done
for tree in "$@"; do sha256sum "$tree/build/compiler"; done
sha256sum /var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite/sqlite3.c

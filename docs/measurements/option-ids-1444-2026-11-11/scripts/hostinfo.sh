#!/bin/sh
# #1444 item 5: the host, toolchain, trees and executables of this record.
d=~/buster-fast-bench/1444-claude-options
cd $d
echo "== date"; date -u +%Y-%m-%dT%H:%M:%S+00:00
echo "== uname"; uname -r
echo "== cpu"; grep -m1 "model name" /proc/cpuinfo; echo "online: $(cat /sys/devices/system/cpu/online)"
echo "== governors and EPP by CPU"
for c in /sys/devices/system/cpu/cpu[0-9]*; do printf '%s %s %s;' ${c##*cpu} "$(cat $c/cpufreq/scaling_governor 2>/dev/null)" "$(cat $c/cpufreq/energy_performance_preference 2>/dev/null)"; done; echo
echo "== transparent huge pages"; cat /sys/kernel/mm/transparent_hugepage/enabled /sys/kernel/mm/transparent_hugepage/defrag
echo "== toolchain"; clang --version | head -1; perf version; ldd --version | head -1
echo "== trees"; git -C tree-base rev-parse HEAD; git -C tree-head rev-parse HEAD
echo "== executables"; sha256sum shifts-base/compiler-* shifts-head/compiler-*
echo "== inputs"; sha256sum inputs/*.c /var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite/sqlite3.c

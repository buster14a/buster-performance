#!/bin/bash
# env.sh: the host, the tools, the commit, the inputs and the executables of the record, as text: the trees that still
# exist by their executables, every tree by its build log's last line (the executable's hash). Reads only; no lock.
cd "$(dirname "$0")"
source ./corpora.sh
echo "date $(date -u +%FT%TZ)"
echo "host $(uname -n) $(uname -srm)"
grep -m1 'model name' /proc/cpuinfo
echo "cpus $(nproc) online $(cat /sys/devices/system/cpu/online) smt $(cat /sys/devices/system/cpu/smt/active)"
echo "cpu2 governor $(cat /sys/devices/system/cpu/cpu2/cpufreq/scaling_governor) driver $(cat /sys/devices/system/cpu/cpu2/cpufreq/scaling_driver) epp $(cat /sys/devices/system/cpu/cpu2/cpufreq/energy_performance_preference 2>/dev/null)"
echo "cpu2 siblings $(cat /sys/devices/system/cpu/cpu2/topology/thread_siblings_list)"
echo "boost $(cat /sys/devices/system/cpu/cpufreq/boost 2>/dev/null) thp $(cat /sys/kernel/mm/transparent_hugepage/enabled)"
echo "perf_event_paranoid $(cat /proc/sys/kernel/perf_event_paranoid) kptr_restrict $(cat /proc/sys/kernel/kptr_restrict)"
grep -E 'MemTotal|HugePages_Total' /proc/meminfo
echo "filesystem $(findmnt -no FSTYPE,OPTIONS -T "$PWD")"
clang --version | head -1
cmake --version | head -1
echo "ninja $(ninja --version)"
perf --version
python3 --version
ld.lld --version 2>/dev/null | head -1
echo "commit $(head -1 COMMIT) $(git -C src log -1 --format='%cI %s' | cut -c1-120)"
for t in src; do
    if [ -x "$t/build/compiler" ]; then echo "compiler $t $(sha256sum < "$t/build/compiler" | cut -d' ' -f1) $(stat -c %s "$t/build/compiler") bytes"; fi
done
for b in build-*.log; do echo "$b: $(tail -1 "$b")"; done
echo "sqlite3.c $(sha256sum < "$sqlite/sqlite3.c" | cut -d' ' -f1) $(stat -c %s "$sqlite/sqlite3.c") bytes"
echo "lua ${#lua_files[@]} units $(cat "${lua_files[@]}" | sha256sum | cut -d' ' -f1) $(cat "${lua_files[@]}" | wc -c) bytes; lua-5.4.8.tar.gz $(sha256sum < inputs/lua-5.4.8.tar.gz 2>/dev/null | cut -d' ' -f1)"
echo "musl ${#musl_files[@]} units $(cat "${musl_files[@]}" | sha256sum | cut -d' ' -f1) $(cat "${musl_files[@]}" | wc -c) bytes"
echo "corpus $corpus"

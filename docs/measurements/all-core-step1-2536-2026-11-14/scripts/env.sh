#!/bin/bash
# env.sh: the host's state and the measured executables' identities, read without a run (no lock).
cd ~/buster-fast-bench/2536-step1-claude
{
    echo "## date"; date -u +%FT%TZ
    echo "## uname"; uname -a
    echo "## cpu"; grep -m1 'model name' /proc/cpuinfo; lscpu -e=CPU,CORE,ONLINE | head -20
    echo "## governors and EPP"
    for c in /sys/devices/system/cpu/cpu[0-9]*; do
        echo "${c##*/} $(cat "$c/cpufreq/scaling_governor" 2>/dev/null) $(cat "$c/cpufreq/energy_performance_preference" 2>/dev/null)"
    done
    echo "## THP"; cat /sys/kernel/mm/transparent_hugepage/enabled /sys/kernel/mm/transparent_hugepage/defrag
    echo "## perf_event_paranoid, nmi_watchdog"; cat /proc/sys/kernel/perf_event_paranoid /proc/sys/kernel/nmi_watchdog
    echo "## tools"; clang --version | head -1; perf --version
    echo "## commits"; for t in main head1 head2 head3; do echo "$t $(cat $t/COMMIT 2>/dev/null || git -C $t rev-parse HEAD)"; done
    echo "## sha256"; sha256sum compiler-main compiler-head1 compiler-head2 compiler-head3 allcore main/tools/allcore/allcore.c /var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite/sqlite3.c ./*.sh
} > env.txt 2>&1

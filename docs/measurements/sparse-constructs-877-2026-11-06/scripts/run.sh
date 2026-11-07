#!/bin/bash
# #877: the measurements in order, after the builds; the host's state first. Each step takes the lock per run.
set -u
export LC_ALL=C
R=$HOME/buster-fast-bench/877-claude; L=$R/logs
echo $$ > $R/run.pid
{ date -u; uname -a; clang --version | head -1; cat /sys/kernel/mm/transparent_hugepage/enabled
  for c in 0 1 2 3; do echo "cpu$c $(cat /sys/devices/system/cpu/cpu$c/cpufreq/scaling_governor) $(cat /sys/devices/system/cpu/cpu$c/cpufreq/energy_performance_preference 2>/dev/null)"; done
  df -h /tmp | tail -1; } >> $L/host.txt
for pair in 1025 1067; do $R/measure.sh objects $pair; done
for pair in 1025 1067; do $R/measure.sh stages $pair; done
for pair in 1025 1067; do $R/measure.sh time $pair; done
echo done > $L/run-done

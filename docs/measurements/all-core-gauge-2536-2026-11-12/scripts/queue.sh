#!/bin/bash
# queue.sh OUT: the gate's runs, each in its own hold of the lock with 20 s between holds: the tool's build and the
# host's state, the counted part, the sampled part; then the reductions (files alone, milliseconds).
set -u
cd "$(dirname "$0")"
out=${1:?an output directory}
mkdir -p "$out"
log="$out/queue.log"
echo "start $(date -u +%T) build" >> "$log"
./lock.sh bash -c "head -1 /var/lib/buster-9700x/owner > $out/build.holder.txt; cc -std=c17 -O2 -Wall -Wextra -Werror -o allcore tools/allcore.c && ./allcore self-test && sha256sum tools/allcore.c allcore src/build/compiler > $out/SHA256SUMS && { uname -a; cat /proc/cmdline; grep -m1 'model name' /proc/cpuinfo; cat /sys/kernel/mm/transparent_hugepage/enabled; for c in /sys/devices/system/cpu/cpu[0-9]*; do printf '%s %s %s %s\n' \"\${c##*/}\" \"\$(cat \$c/online 2>/dev/null || echo 1)\" \"\$(cat \$c/cpufreq/scaling_governor 2>/dev/null)\" \"\$(cat \$c/cpufreq/energy_performance_preference 2>/dev/null)\"; done; cat /proc/sys/kernel/perf_event_paranoid /proc/sys/kernel/nmi_watchdog /proc/sys/kernel/perf_event_max_sample_rate; } > $out/env.txt 2>&1" >> "$log" 2>&1
echo "end $(date -u +%T) build status $?" >> "$log"
for part in counted sampled; do
    sleep 20
    echo "start $(date -u +%T) $part" >> "$log"
    ./lock.sh ./gate.sh "$part" "$out" >> "$log" 2>&1
    echo "end $(date -u +%T) $part status $?" >> "$log"
done
./allcore table --out "$out" --bytes 9507037 > "$out/table.txt" 2>&1
echo "table status $?" >> "$log"
./allcore compare --out "$out" --record ../2536-rerun-claude/results/tables > "$out/compare.tsv" 2>&1
echo "compare status $?" >> "$log"
echo "done $(date -u +%T)" >> "$log"

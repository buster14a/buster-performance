#!/bin/bash
# #877: the measurements by one runner. run.sh's chain had been started four times (a launch retried after its ssh
# session hung), and the four interleaved their outputs; they are kept in logs/discarded. A runner that finds another
# holding run2.lock exits. Each round is one hold of the lock (hold.sh): three of the stages, then five of time-runs.
set -u
export LC_ALL=C
R=$HOME/buster-fast-bench/877-claude; L=$R/logs; O=$R/results
exec 8> $R/run2.lock
flock -n 8 || { echo "run2: another runner holds run2.lock" >&2; exit 1; }
echo $$ > $R/run2.pid
export EXCLUSIVE_OWNER=claude-877 EXCLUSIVE_TITLE="#877 matched 9700X comparison of #1025 and #1067" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/877
{ date -u; uname -a; cat /sys/kernel/mm/transparent_hugepage/enabled
  for c in 0 1 2 3; do echo "cpu$c $(cat /sys/devices/system/cpu/cpu$c/cpufreq/scaling_governor) $(cat /sys/devices/system/cpu/cpu$c/cpufreq/energy_performance_preference 2>/dev/null)"; done
  df -h /tmp | tail -1; perf --version; } >> $L/host.txt
for round in 1 2 3; do
    ~/buster-fast-bench/exclusive.sh $R/hold.sh stages $round > $O/stages-$round.txt 2>&1
    echo "$(date -u +%FT%TZ) run2 stages $round status $?" >> $L/receipts.txt
done
for round in 1 2 3 4 5; do
    ~/buster-fast-bench/exclusive.sh $R/hold.sh time $round > $O/time-$round.txt 2>&1
    echo "$(date -u +%FT%TZ) run2 time $round status $?" >> $L/receipts.txt
done
echo done > $L/run2-done

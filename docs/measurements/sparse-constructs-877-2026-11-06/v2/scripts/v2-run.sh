#!/bin/bash
# #877, second campaign: the measurements by one runner, each round one hold (v2-hold.sh): three of the stages, then
# five of time-runs. v2-build.sh starts it once the builds are done.
set -u
export LC_ALL=C
R=$HOME/buster-fast-bench/877-claude; V=$R/v2; L=$V/logs; O=$V/results
exec 9> $V/run.lock
flock -n 9 || { echo "v2-run: another runner holds run.lock" >&2; exit 1; }
export EXCLUSIVE_OWNER=claude-877 EXCLUSIVE_TITLE="#877 local_map variants on the 9700X" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/877
{ date -u; uname -a; cat /sys/kernel/mm/transparent_hugepage/enabled; df -h /tmp | tail -1; } >> $L/host.txt
for round in 1 2 3; do
    ~/buster-fast-bench/exclusive.sh $V/v2-hold.sh stages $round > $O/stages-$round.txt 2>&1
    echo "$(date -u +%FT%TZ) v2 stages $round status $?" >> $L/receipts.txt
done
for round in 1 2 3 4 5; do
    ~/buster-fast-bench/exclusive.sh $V/v2-hold.sh time $round > $O/time-$round.txt 2>&1
    echo "$(date -u +%FT%TZ) v2 time $round status $?" >> $L/receipts.txt
done
echo done > $L/run-done

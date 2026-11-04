#!/bin/bash
# #673, the two-phase growing team: head $1 (head-<short commit>) against main $2 (main-<short commit>). Cohorts and
# time-runs controls (measure8a.sh, measure6's method), the never-grows and no-jobserver controls over six placements
# (measure8b.sh, measure7's), then each build's physical traffic (traffic/traffic, six rounds). Each build and run is
# its own lock hold.
B=~/buster-fast-bench/673-claude
C=~/buster-fast-bench/unclaimed-perf-20261028
E=issue673-spawn-1d/evidence-673-spawn
P=$B/measure8-$1.progress
$B/measure8a.sh $1 $2; echo "$(date +%T) measure8a status $?" >> $P
$B/measure8b.sh $1 $2; echo "$(date +%T) measure8b status $?" >> $P
cd $C
for T in $2 $1; do
    $B/traffic/traffic $B/traffic-$1/$T $B/$T/build/compiler ./$E/matched_cohort ./$E/compile-budget.mk ./$E/usage_record 6 $T > $B/traffic-$1-$T.log 2>&1
    s=$?
    echo "$(date +%T) traffic $T status $s" >> $P
    $B/traffic/traffic_stats $B/traffic-$1/$T > $B/traffic-$1/$T.tsv 2>> $B/traffic-$1-$T.log
    echo "$(date +%T) traffic_stats $T status $?" >> $P
done
echo "$(date +%T) done" >> $P

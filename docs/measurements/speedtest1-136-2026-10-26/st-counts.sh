#!/bin/bash
# User-space instructions and cycles of speedtest1's runs on CPU 2 (perf stat), ROUNDS rounds in a rotating order: the
# count SQLite's own procedure takes from cachegrind (counts/, each run's output beside its counts).
set -u
. "$(dirname "$0")/st-env.sh"
cd $M || exit 1
rounds=${1:-3}
builds=()
for c in ${BUILDS[@]}; do
    [ -x st-$c ] && builds+=($c)
done
n=${#builds[@]}
rm -rf counts && mkdir -p counts
for r in $(seq 0 $(( rounds - 1 ))); do
    for i in $(seq 0 $(( n - 1 ))); do
        c=${builds[$(( (r + i) % n ))]}
        rm -rf $RUNDIR
        mkdir -p $RUNDIR/db $RUNDIR/tmp
        (cd $RUNDIR/db && SQLITE_TMPDIR=$RUNDIR/tmp exec taskset -c 2 perf stat -x, -e instructions:u,cycles:u,task-clock -o $M/counts/r$r-$c.stat $M/st-$c $OPTS speedtest1.db > $M/counts/r$r-$c.txt 2>&1)
        echo "$r $c $(grep -E 'instructions|cycles' $M/counts/r$r-$c.stat | cut -d, -f1 | tr '\n' ' ')"
    done
done

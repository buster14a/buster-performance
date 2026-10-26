#!/bin/bash
# Where each build's user-space instructions and cycles go, by function: a perf record of one run of each build on CPU
# 2 per event (instructions:u every 1,000,003, cycles:u every 200,003), reported by symbol (profile/).
set -u
. "$(dirname "$0")/st-env.sh"
cd $M || exit 1
rm -rf profile && mkdir -p profile
for c in ${BUILDS[@]}; do
    [ -x st-$c ] || continue
    for event in instructions:u,1000003 cycles:u,200003; do
        e=${event%,*}
        rm -rf $RUNDIR
        mkdir -p $RUNDIR/db $RUNDIR/tmp
        (cd $RUNDIR/db && SQLITE_TMPDIR=$RUNDIR/tmp taskset -c 2 perf record -q -e $e -c ${event#*,} -o $M/profile/$c-${e%:u}.data $M/st-$c $OPTS speedtest1.db > /dev/null 2>&1)
        perf report -i profile/$c-${e%:u}.data --stdio --sort symbol --percent-limit 0.3 2> /dev/null | grep -v '^$' > profile/$c-${e%:u}.txt
    done
done

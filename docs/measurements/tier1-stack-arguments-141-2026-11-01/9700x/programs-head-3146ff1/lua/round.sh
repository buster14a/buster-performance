#!/usr/bin/env bash
# round.sh ROUND: each build's run of every script, the builds in an order rotating by ROUND; a line per run: the round,
# the script, the build and the microseconds from before the run's fork to after its wait.
cd "$(dirname "$0")"
compilers=(t1base t1)
for s in calls tables strings arithmetic closures; do
    for i in 0 1; do
        c=${compilers[$(( ($1 + i) % 2 ))]}
        [ -x lua-$c ] || continue
        start=$EPOCHREALTIME
        taskset -c 2 ./lua-$c $s.lua > /dev/null 2>&1
        end=$EPOCHREALTIME
        echo "$1 $s $c $(( ${end/./} - ${start/./} ))"
    done
done

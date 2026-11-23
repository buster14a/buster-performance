#!/bin/bash
# one.sh BUILD FILE LIMIT: one timed --tier1 -c compile on CPU 2, with the load before and after.
{ echo "== $1 $2 $(date -u +%FT%TZ) load $(cat /proc/loadavg)"; ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | head -6; } >> results/load.log
TIMEFORMAT=%R
t=$( { time taskset -c 2 timeout -k 5 $3 $1/build/compiler -w --tier1 -c $2 -o /dev/shm/claude-3332-$1.o > /dev/null 2>&1; echo "rc=$?" > /dev/shm/claude-3332-rc; } 2>&1 )
echo -e "$1\t$(basename $2 .c)\t$(cat /dev/shm/claude-3332-rc)\t$t" >> results/nests.tsv
echo "   after: load $(cat /proc/loadavg)" >> results/load.log

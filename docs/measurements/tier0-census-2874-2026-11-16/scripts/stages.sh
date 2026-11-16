#!/bin/bash
# stages.sh LABEL RUNS: `-c --time-stages` of sqlite3.c by results/LABEL/compiler, RUNS times, CPU 2, in ONE hold of the
# lock; each run's stage report in results/LABEL/stages-N.txt.
set -u
cd "$(dirname "$0")"
. ./corpora.sh
label=$1; runs=$2
out=$PWD/results/$label
options=$(corpus_options sqlite3)
busy="ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | head -6; cat /proc/loadavg"
./lock.sh bash -c "
    head -1 /var/lib/buster-9700x/owner | cut -c1-200; $busy
    for ((i = 1; i <= $runs; i += 1)); do
        taskset -c 2 $out/compiler --time-stages -c $options $sqlite/sqlite3.c -o /dev/shm/claude-2874.o > /dev/null 2> $out/stages-\$i.txt
    done
    $busy" > "$out/stages.log" 2>&1
echo "status $?" >> "$out/stages.log"
rm -f /dev/shm/claude-2874.o
echo done

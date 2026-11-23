#!/bin/bash
# Usage: profile-b-post.sh TAG RUNS: brips over the records (after the hold; CPU 7, niceness 19).
set -u
D=~/buster-fast-bench/2874-claude-rubin
TAG=$1; RUNS=$2
cd $D/results/$TAG
for i in $(seq 1 $RUNS); do
  taskset -c 7 nice -n 19 perf script -i /dev/shm/2874-rubin-$TAG-$i.data -F period,ip,brstack 2>/dev/null | taskset -c 7 nice -n 19 $D/tools/brips $D/tools/transparent.txt > b-$i.ips && test -s b-$i.ips && rm -f /dev/shm/2874-rubin-$TAG-$i.data
done
rm -f /dev/shm/2874-rubin-$TAG.o
wc -l b-*.ips

#!/bin/bash
# Usage: profile-post.sh TAG RUNS: the records' addresses (after the hold; CPU 7, niceness 19).
set -u
D=~/buster-fast-bench/3393-claude
TAG=$1; RUNS=$2
cd $D/results/$TAG
for i in $(seq 1 $RUNS); do
  taskset -c 7 nice -n 19 perf script -i /dev/shm/3393-$TAG-$i.data -F ip,dso 2>/dev/null | awk '{print $1, $2}' > ips-$i.txt
  test -s ips-$i.txt && rm -f /dev/shm/3393-$TAG-$i.data
done
rm -f /dev/shm/3393-$TAG.o
wc -l ips-*.txt

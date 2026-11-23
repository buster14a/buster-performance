#!/bin/bash
# Usage: profbench-post.sh TAG: the record's sample addresses (CPU 7, niceness 19).
set -u
D=~/buster-fast-bench/3394-claude
TAG=$1
cd $D/results/$TAG
taskset -c 7 nice -n 19 perf script -i /dev/shm/3394-claude-$TAG.data -F ip,sym 2>/dev/null | awk '{print $1, $2}' > ips.txt
test -s ips.txt && rm -f /dev/shm/3394-claude-$TAG.data
wc -l ips.txt

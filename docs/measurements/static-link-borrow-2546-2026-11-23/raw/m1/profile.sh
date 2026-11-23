#!/bin/sh
# profile.sh NAME BIN RUNS: cycles and page faults of RUNS fresh static hello builds, CPU 2.
set -u
n=$1; b=$2; runs=$3
dir=$(cd "$(dirname "$0")" && pwd); cd "$dir"
export XDG_CACHE_HOME=$CACHE_ROOT/cache-$n
cat /proc/loadavg; ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | head -6
taskset -c 2 "$b" -static hello.c -o out-$n/hello
perf record -q -F 49999 -o cyc-$n.data -- sh -c "for i in \$(seq $runs); do taskset -c 2 $b -static hello.c -o out-$n/hello; done" 2>/dev/null
perf report -i cyc-$n.data --no-children --sort sym --stdio 2>/dev/null | grep -v '^#' | grep -v '^$' | head -70 > cyc-$n.txt
perf record -q -e page-faults -c 1 -d -o pf-$n.data -- sh -c "for i in \$(seq 20); do taskset -c 2 $b -static hello.c -o out-$n/hello; done" 2>/dev/null
perf report -i pf-$n.data --no-children --sort sym --stdio 2>/dev/null | grep -v '^#' | grep -v '^$' | head -50 > pf-$n.txt
rm -f cyc-$n.data
cat /proc/loadavg

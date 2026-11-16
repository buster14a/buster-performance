#!/bin/bash
# musl-faults.sh: CPU 2 counted over the units a process each, twice, with the page-fault counter beside the
# minor-fault one (the recording samples the latter) and the huge pages the system gave (thp_fault_alloc and
# thp_fault_fallback from /proc/vmstat around each pass). In one hold of the lock.
set -u
cd "$(dirname "$0")"
here=$PWD
out=results/musl
for pass in 0 1; do
    grep -E "^thp_fault_(alloc|fallback) " /proc/vmstat | sed "s/^/before $pass /" >> "$out/faults-vmstat.txt"
    taskset -c 4 perf stat -C 2 -x, -e cycles:k,page-faults,minor-faults,major-faults -o "$out/faults-$pass.csv" -- taskset -c 2 bash scripts/musl-loop.sh units "$here/src/build/compiler" > /dev/null 2>&1
    grep -E "^thp_fault_(alloc|fallback) " /proc/vmstat | sed "s/^/after $pass /" >> "$out/faults-vmstat.txt"
done

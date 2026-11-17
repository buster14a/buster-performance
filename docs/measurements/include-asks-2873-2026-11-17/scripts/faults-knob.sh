#!/bin/bash
# faults-knob.sh OUT: the page faults of hello.c's -c by the knob build with its asks off and at the third miss (perf
# record -e page-faults -c 1 -d: every fault's address and where it was taken), three runs a setting; OUT/asksN-R.txt
# are the faults (the address's page, the instruction's symbol), OUT/summary.txt their counts and the pages one
# setting faults on and the other doesn't.
set -u
cd "$(dirname "$0")"
here=$PWD
out=$1
mkdir -p "$out"
cp knob/build/compiler "$out/knob.compiler"
for warm in 1 2 3; do taskset -c 2 "$out/knob.compiler" -c inputs/hello.c -o /dev/shm/2873-faults.o; done
for run in 1 2 3; do
    for asks in 0 3; do
        BUSTER_ASKS=$asks taskset -c 2 perf record -q -e page-faults -c 1 -d -o "$out/asks$asks-$run.data" -- "$here/$out/knob.compiler" -c inputs/hello.c -o /dev/shm/2873-faults.o > /dev/null 2>&1
        perf script -i "$out/asks$asks-$run.data" -F comm,addr,ip,sym 2> /dev/null | awk '{printf "%s %s %s\n", $1, substr($2, 1, length($2) - 3), $4}' > "$out/asks$asks-$run.txt"
    done
done
{
    for f in "$out"/asks*-*.txt; do echo "$(basename "$f"): $(wc -l < "$f") faults"; done
    for run in 1 2 3; do
        echo "run $run: pages faulted with the asks at 3 and not with them off (<), and the other way (>):"
        diff <(sort "$out/asks3-$run.txt" | uniq -c) <(sort "$out/asks0-$run.txt" | uniq -c) | grep '^[<>]'
    done
} > "$out/summary.txt"
rm -f "$out"/*.compiler "$out"/*.data /dev/shm/2873-faults.o
cat "$out/summary.txt"

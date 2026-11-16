#!/bin/bash
# own.sh LABEL RUNS: the three parts' own benchmarks by results/LABEL/compiler, CPU 2, each run its own hold of the lock:
# benchmark-x86-encoder (the compiler-like mix, with fixups, and after 200 ms of the scalar loop), benchmark-branch-sizing
# and benchmark-object-writer (its objects in /dev/shm). results/LABEL/own-NAME-N.txt.
set -u
cd "$(dirname "$0")"
label=$1; runs=$2
out=$PWD/results/$label
busy="ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | head -6; cat /proc/loadavg"
mkdir -p /dev/shm/claude-2874-objects
run()
{
    local name=$1; shift
    for ((n = 1; n <= runs; n += 1)); do
        ./lock.sh bash -c "head -1 /var/lib/buster-9700x/owner | cut -c1-200; $busy; taskset -c 2 $out/compiler $*; echo status \$?; $busy" > "$out/own-$name-$n.txt" 2>&1
    done
}
run encoder benchmark-x86-encoder
run encoder-fixups benchmark-x86-encoder --fixups
run encoder-after-scalar benchmark-x86-encoder --fixups --after-scalar 200 --only x86_encode_16
run branch-sizing benchmark-branch-sizing
run object-writer benchmark-object-writer --directory /dev/shm/claude-2874-objects
rm -rf /dev/shm/claude-2874-objects
echo done

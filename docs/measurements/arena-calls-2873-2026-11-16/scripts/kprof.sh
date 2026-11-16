#!/bin/bash
# kprof.sh NAME COMPILER KIND: the kernel's cycles by symbol for one count's work of KIND (ab.sh --work) by COMPILER, on
# CPU 2 (perf record -C 2 -e cycles:k), into results/kprof-NAME.txt. One hold of the lock.
cd "$(dirname "$0")"
name=$1
compiler=$2
kind=$3
bash ab.sh --work "$kind" "$compiler" warm > /dev/null 2>&1
taskset -c 4 perf record -q -C 2 -e cycles:k -c 100003 -o "/dev/shm/2873-kprof-$name.data" -- bash ab.sh --work "$kind" "$compiler" "$name" > /dev/null 2>&1
perf report -i "/dev/shm/2873-kprof-$name.data" --sort symbol --stdio 2> /dev/null | grep -v "^#" | grep -v "^$" | head -60 > "results/kprof-$name.txt"
perf report -i "/dev/shm/2873-kprof-$name.data" --sort symbol --stdio 2> /dev/null | grep "Event count" >> "results/kprof-$name.txt"
rm -f "/dev/shm/2873-kprof-$name.data"

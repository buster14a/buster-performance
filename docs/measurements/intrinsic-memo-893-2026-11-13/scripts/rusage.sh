#!/bin/bash
# rusage.sh ROUNDS [TREE] (inside one hold): c-testsuite's 220 units as 220 processes of fresh copies of each build in turn on CPU 2
# (alternating the order), each process's user and system time and minor faults from wait4 (rusage.py).
set -u
cd "$(dirname "$0")"
. ./common.sh
out=$here/results/rusage
mkdir -p "$out"
log=$out/rusage${2:+-$2}-$(date -u +%H%M%S).txt
head -1 /var/lib/buster-9700x/owner > "$log"
# Fresh copies of the executables, written alike, so that no build gains from another page-cache state of its file.
rm -rf $t/copies-rusage && mkdir -p $t/copies-rusage
cp "$base" $t/copies-rusage/base && cp "$head" $t/copies-rusage/head
builds=(base $t/copies-rusage/base head $t/copies-rusage/head)
if [[ -n ${2:-} ]]; then cp "$here/$2/build/compiler" $t/copies-rusage/other && builds+=(other $t/copies-rusage/other); fi
taskset -c 2 python3 -I "$here/rusage.py" "$t/lists/cts.txt" "$t/o/r.o" "$1" "${builds[@]}" >> "$log" 2>&1
cat "$log"

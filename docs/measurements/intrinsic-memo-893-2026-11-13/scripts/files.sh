#!/bin/bash
# files.sh ROUNDS (inside one hold): c-testsuite's 220 units as 220 processes each, base and head in turn ROUNDS times
# (alternating which goes first), each a perf stat of the whole loop's user cycles and instructions on CPU 2.
set -u
cd "$(dirname "$0")"
. ./common.sh
rounds=$1
out=$here/results/files
mkdir -p "$out"
log=$out/files-$(date -u +%H%M%S).txt
head -1 /var/lib/buster-9700x/owner > "$log"
loop='for f in $(cat '$t'/lists/cts.txt); do "$0" -c "$f" -o '$t'/o/f.o 2>/dev/null || exit 1; done'
for ((r = 0; r < rounds; r += 1)); do
    order="base head"
    if ((r % 2 == 1)); then order="head base"; fi
    for v in $order; do
        c=$base
        if [[ $v == head ]]; then c=$head; fi
        printf 'round %d %s ' "$r" "$v" >> "$log"
        taskset -c 2 perf stat -x, -e cycles:u,instructions:u,task-clock -- bash -c "$loop" "$c" 2>&1 >/dev/null | tr '\n' ' ' >> "$log"
        echo >> "$log"
    done
done
cat "$log"

#!/usr/bin/env bash
# ab.sh RUNS: sqlite3.c -fsyntax-only and -c by main's and the head's Release compilers, alternating, pinned to CPU 2:
# a line per run with user cycles, instructions, wall seconds and exit status. Run under the lock.
set -u
R=~/buster-fast-bench/1875-claude-b
cd $R
RUNS=$1
mkdir -p out
C=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
ARGS=(--predefines $C/provenance/gnu17-pinned-predefines.txt --target=x86_64-linux-gnu -march=znver5 -std=gnu17 -nostdinc -isystem $C/headers/usr/lib/clang/23/include -isystem $C/headers/usr/local/include -isystem $C/headers/usr/include $C/sqlite/sqlite3.c)
head -1 /var/lib/buster-9700x/owner >> out/holds.txt
{ echo "before: $(cat /proc/loadavg)"; ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | head -6; } >> out/busy.txt
for mode in fsyntax c; do
    for run in $(seq 1 $RUNS); do
        for variant in main head; do
            args="-fsyntax-only"
            [ $mode = c ] && args="-c -o out/$variant.o"
            start=$EPOCHREALTIME
            taskset -c 2 perf stat -x, -e cycles:u,instructions:u -o out/perf.txt -- $R/$variant/build/compiler $args "${ARGS[@]}" > out/$variant-$mode.err 2>&1
            status=$?
            end=$EPOCHREALTIME
            c=$(grep cycles out/perf.txt | cut -d, -f1); i=$(grep instructions out/perf.txt | cut -d, -f1)
            echo "$mode $variant $run $c $i $(echo "$end - $start" | bc) status $status"
        done
    done
done
{ echo "after: $(cat /proc/loadavg)"; ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | head -6; } >> out/busy.txt

#!/bin/bash
# The default warnings' cycles by function on the 9700X: main's head built as the job builds it, then a cycles profile
# and counters of -c sqlite3.c with and without -w, the two alternating. One hold.
set -u
cd ~/buster-fast-bench/2850-claude-vjgaob/buster
S=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
rev=$(git rev-parse --short=9 HEAD)
out=$HOME/buster-fast-bench/2850-claude-vjgaob/results/warn-prof-$rev
rm -rf "$out"; mkdir -p "$out"
{ date -u; cat /proc/loadavg; } > "$out/before.txt"
start=$(date +%s)
BUSTER_HOST_ARCH=znver5 BUSTER_DEBUG_INFO=0 ./build.sh --config Release > "$out/build.log" 2>&1; echo "build-status=$? seconds=$(( $(date +%s) - start ))" >> "$out/build.log"
C=$PWD/build/compiler-job-$rev
cp "$(BUSTER_HOST_ARCH=znver5 BUSTER_DEBUG_INFO=0 ./build.sh print-output --config Release 2>/dev/null)" "$C" && chmod +x "$C"
O=(--lanes 1 -c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$S" "$S/sqlite3.c")
cd "$out"
taskset -c 2 "$C" "${O[@]}" -o default.o 2> default.err; echo "status=$?" >> default.err
taskset -c 2 "$C" -w "${O[@]}" -o w.o 2> w.err; echo "status=$?" >> w.err
cmp default.o w.o > cmp.txt 2>&1; echo "cmp=$?" >> cmp.txt
for i in 1 2 3 4 5 6 7 8; do
    taskset -c 2 perf record -q -e cycles:u -c 100003 -o perf-default-$i.data -- "$C" "${O[@]}" -o x.o > /dev/null 2>&1
    taskset -c 2 perf record -q -e cycles:u -c 100003 -o perf-w-$i.data -- "$C" -w "${O[@]}" -o x.o > /dev/null 2>&1
done
E=cycles:u,instructions:u,branch-misses:u,L1-dcache-load-misses:u,cache-misses:u,dTLB-load-misses:u
for round in 1 2; do
    taskset -c 2 perf stat -x, -e $E -r 5 -o stat-default-$round.csv -- "$C" "${O[@]}" -o x.o > /dev/null 2>&1
    taskset -c 2 perf stat -x, -e $E -r 5 -o stat-w-$round.csv -- "$C" -w "${O[@]}" -o x.o > /dev/null 2>&1
done
for i in 1 2 3 4 5; do
    taskset -c 2 "$C" "${O[@]}" --time-stages -o x.o 2> stages-default-$i.txt > /dev/null
    taskset -c 2 "$C" -w "${O[@]}" --time-stages -o x.o 2> stages-w-$i.txt > /dev/null
done
rm -f x.o
{ date -u; cat /proc/loadavg; } > after.txt
echo done > held

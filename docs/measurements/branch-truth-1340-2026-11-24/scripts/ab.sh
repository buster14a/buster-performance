#!/bin/bash
# #1340 part 2: base against head on the frozen sqlite3.c, as compile-count-2850-2026-11-24's scripts/warn-facts.sh runs
# the compile (--lanes 1 -c, CPU 2), three rounds (forward, reverse, forward) of perf stat -r 11 each, in one hold.
# Usage: ab.sh OUT NAME... (the compilers bin/compiler-NAME; a name ending in :w adds -w)
set -u
out=$HOME/buster-fast-bench/1340-truth/results/$1; shift
names=("$@")
bin=$HOME/buster-fast-bench/1340-truth/bin
S=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
rm -rf "$out"; mkdir -p "$out"; cd "$out"
{ date -u; cat /proc/loadavg; ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | head; } > before.txt
O=(--lanes 1 -c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$S" "$S/sqlite3.c")
taskset -c 2 "$bin/compiler-${names[0]%%:*}" "${O[@]}" -o none.o 2> none.err; echo "status=$?" >> none.err
# Each compiler once before the rounds: a binary just built is not in the page cache.
for n in "${names[@]}"; do taskset -c 2 "$bin/compiler-${n%%:*}" "${O[@]}" -o x.o 2> /dev/null; done
E=cycles:u,instructions:u,task-clock,L1-dcache-load-misses:u,cache-misses:u,branch-misses:u
run() {
    local n=${names[$1]} round=$2 extra=()
    [ "${n##*:}" = w ] && extra=(-w)
    local file=${n/:/-}
    taskset -c 2 perf stat -x, -e $E -r 11 -o "stat-$file-$round.csv" -- "$bin/compiler-${n%%:*}" "${extra[@]}" "${O[@]}" -o x.o > /dev/null 2> "err-$file-$round.txt"
    echo "status=$?" >> "err-$file-$round.txt"
    cmp -s x.o none.o || echo "$n round $round: object differs" >> differs.txt
}
for i in "${!names[@]}"; do run "$i" 1; done
for (( i=${#names[@]}-1; i>=0; i-- )); do run "$i" 2; done
for i in "${!names[@]}"; do run "$i" 3; done
rm -f x.o
{ date -u; cat /proc/loadavg; ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | head; } > after.txt
echo done > complete

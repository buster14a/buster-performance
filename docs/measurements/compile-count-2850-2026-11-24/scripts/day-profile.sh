#!/bin/bash
# The day's merges along main, with binaries earlier A/B holds built on this host (each as the job builds it):
# sqlite3.c's --lanes 1 -c compile with the default warnings and with -w for every one, interleaved in three rounds
# (forward, reverse, forward) of 11 runs. One hold, no build.
set -u
R=$HOME/buster-fast-bench/2850-claude-vjgaob/results
S=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
out=$R/day-profile
rm -rf "$out"; mkdir -p "$out"; cd "$out"
names=(e347ec526 188cef807 dc8efaacd b4fda31b9 64e88df4d 31fd25ce8 5cd20effd 14e364653)
paths=("$R/ab-day-14e364653/compiler-base" "$R/ab-main-188cef807/compiler-head" "$R/ab-main-3553/compiler-base" "$R/ab-main-3553/compiler-head" "$R/ab-fix-3553/compiler-base" "$R/ab-fix-3553-pr/compiler-base" "$R/ab-pr3569/compiler-base" "$R/ab-day-14e364653/compiler-head")
{ date -u; cat /proc/loadavg; } > before.txt
for i in "${!names[@]}"; do "${paths[$i]}" --version > /dev/null 2>&1 || { echo "${names[$i]} doesn't run: ${paths[$i]}" >> failed; }; done
[ -f failed ] && exit 1
O=(--lanes 1 -c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$S" "$S/sqlite3.c")
E=cycles:u,instructions:u,task-clock,L1-dcache-load-misses:u,cache-misses:u,branch-misses:u,page-faults
run() {
    local i=$1 round=$2 mode=$3 extra=()
    [ "$mode" = w ] && extra=(-w)
    taskset -c 2 perf stat -x, -e $E -r 11 -o "stat-${names[$i]}-$mode-$round.csv" -- "${paths[$i]}" "${extra[@]}" "${O[@]}" -o x.o > /dev/null 2> "err-${names[$i]}-$mode-$round.txt"
    echo "status=$?" >> "err-${names[$i]}-$mode-$round.txt"
}
for i in "${!names[@]}"; do taskset -c 2 "${paths[$i]}" -w "${O[@]}" -o x.o > /dev/null 2>&1; done
for i in "${!names[@]}"; do run "$i" 1 w; run "$i" 1 d; done
for (( i=${#names[@]}-1; i>=0; i-- )); do run "$i" 2 w; run "$i" 2 d; done
for i in "${!names[@]}"; do run "$i" 3 w; run "$i" 3 d; done
rm -f x.o
{ date -u; cat /proc/loadavg; } > after.txt
echo done > complete

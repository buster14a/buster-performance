#!/bin/bash
# #1340 part 3: what the quiet roots save sqlite3.c's compile on the 9700X. The base (the commit the branch sits on) and
# the head, each built as the 9700X job builds it (build-one.sh), interleaved in one hold: three rounds (forward,
# reverse, forward; five with ROUNDS=5) of `perf stat -r 11` on the `--lanes 1 -c` compile, as compile-count-2850-2026-11-24's
# scripts/warn-facts.sh runs it, with every run's exit status and the objects compared. Usage: roots-ab.sh NAME VARIANT...
set -u
name=$1; shift
B=$HOME/buster-fast-bench/1340-roots/bin
S=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
out=$HOME/buster-fast-bench/1340-roots/results/$name
rm -rf "$out"; mkdir -p "$out"; cd "$out" || exit 1
variants=("$@")
{ date -u; cat /proc/loadavg; ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | head; } > before.txt
for v in "${variants[@]}"; do v=${v%:visits}; sha256sum "$B/compiler-${v%@*}" >> compilers.txt; done
O=(--lanes 1 -c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$S" "$S/sqlite3.c")
taskset -c 2 "$B/compiler-${variants[0]}" "${O[@]}" -o reference.o 2> reference.err; echo "status=$?" >> reference.err
E=cycles:u,instructions:u,task-clock,L1-dcache-load-misses:u,cache-misses:u,branch-misses:u
run() {
    local v=$1 round=$2 extra=()
    [ "$v" = "${variants[0]}-w" ] && { v=${variants[0]}; extra=(-w); }
    local label=$1
    # A variant NAME:visits is NAME's compiler with the test's switch, which visits every root.
    local log=()
    [ "${v%:visits}" != "$v" ] && { v=${v%:visits}; log=(env BUSTER_TEST_DEFAULT_PATH_LOG=/dev/null); }
    # A variant NAME@MASK is NAME's compiler (the experiment's, scripts/experiment-roots.patch) with BUSTER_EXPERIMENT_ROOTS=MASK.
    [ "${v%@*}" != "$v" ] && { log=(env "BUSTER_EXPERIMENT_ROOTS=${v#*@}"); v=${v%@*}; }
    taskset -c 2 "${log[@]}" perf stat -x, -e $E -r 11 -o "stat-$label-$round.csv" -- "$B/compiler-$v" "${extra[@]}" "${O[@]}" -o x.o > /dev/null 2> "err-$label-$round.txt"
    echo "status=$?" >> "err-$label-$round.txt"
    cmp -s x.o reference.o || echo "$label round $round: object differs" >> differs.txt
}
all=("${variants[@]}" "${variants[0]}-w")
for i in "${!all[@]}"; do run "${all[$i]}" 1; done
for (( i=${#all[@]}-1; i>=0; i-- )); do run "${all[$i]}" 2; done
for i in "${!all[@]}"; do run "${all[$i]}" 3; done
# (ROUNDS=5 adds a reverse and a forward round, as the exploratory runs took.)
if [ "${ROUNDS:-3}" = 5 ]; then
    for (( i=${#all[@]}-1; i>=0; i-- )); do run "${all[$i]}" 4; done
    for i in "${!all[@]}"; do run "${all[$i]}" 5; done
fi
rm -f x.o
{ date -u; cat /proc/loadavg; ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | head; } > after.txt
echo done > complete

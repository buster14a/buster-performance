#!/bin/bash
# The reach scan's filter on the 9700X (#1340 part 1): base (the commit the branch sits on) against head, with stage1
# (head without the integer constants' widths) and base under -w for scale. The frozen sqlite3.c's --lanes 1 -c compile,
# as compile-count-2850-2026-11-24/scripts/warn-facts.sh runs it: CPU 2, perf stat -r 11, three rounds (forward,
# reverse, forward), every run's exit status kept and every object compared with base's. Run under the lock, one hold.
# Arguments: a label for the results directory, then the variants (binaries in bin/) to time after base.
set -u
cd ~/buster-fast-bench/1340-reach
S=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
out=$PWD/results/ab-$1; shift
rm -rf "$out"; mkdir -p "$out"
names=(base "$@" base-w)
binaries=(base "$@" base)
O=(--lanes 1 -c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$S" "$S/sqlite3.c")
cd "$out"
{ date -u; cat /proc/loadavg; ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | head; } > before.txt
for name in "${binaries[@]}"; do sha256sum ../../bin/compiler-$name; cat ../../bin/compiler-$name.commit; done > binaries.txt
taskset -c 2 ../../bin/compiler-base "${O[@]}" -o none.o 2> none.err; echo "status=$?" >> none.err
# The filter's counts on this compile, by the audit (it lists every candidate, so it is no timed run).
for name in "$@"; do
    BUSTER_TEST_COMMON_REACH_AUDIT=$out/audit-$name.txt taskset -c 2 ../../bin/compiler-$name "${O[@]}" -o audit.o 2> audit-$name.err; echo "status=$?" >> audit-$name.err
    cmp -s audit.o none.o || echo "audit $name: object differs" >> differs.txt
done
rm -f audit.o
E=cycles:u,instructions:u,task-clock,L1-dcache-load-misses:u,cache-misses:u,branch-misses:u
run() {
    local i=$1 round=$2 extra=()
    [ "${names[$i]}" = base-w ] && extra=(-w)
    taskset -c 2 perf stat -x, -e $E -r 11 -o "stat-${names[$i]}-$round.csv" -- "../../bin/compiler-${binaries[$i]}" "${extra[@]}" "${O[@]}" -o x.o > /dev/null 2> "err-${names[$i]}-$round.txt"
    echo "status=$?" >> "err-${names[$i]}-$round.txt"
    cmp -s x.o none.o || echo "${names[$i]} round $round: object differs" >> differs.txt
}
for i in "${!names[@]}"; do run "$i" 1; done
for (( i=${#names[@]}-1; i>=0; i-- )); do run "$i" 2; done
for i in "${!names[@]}"; do run "$i" 3; done
rm -f x.o
{ date -u; cat /proc/loadavg; ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | head; } > after.txt
echo done > complete

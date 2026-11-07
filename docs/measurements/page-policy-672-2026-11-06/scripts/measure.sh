#!/bin/bash
# usage: measure.sh LABEL [COMPILER]  -- run under the lock
cd ~/buster-fast-bench/672-claude
sqlite=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
opts=(-c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$sqlite" "$sqlite/sqlite3.c")
out=results/$1; mkdir -p $out
C=${2:-./build/compiler}
cp "$C" $out/compiler
C=$out/compiler
sha256sum $C > $out/compiler.sha256
vm() { grep -E '^(thp_fault_alloc|thp_fault_fallback|pgfault|pgalloc_normal|pgfree|thp_zero_page_alloc) ' /proc/vmstat | awk '{printf "%s=%s ", $1, $2}'; }
# warm
taskset -c 2 $C "${opts[@]}" --lanes 1 -o $out/sqlite3.o
for r in 1 2 3 4 5 6 7; do taskset -c 2 $C "${opts[@]}" --lanes 1 --time-stages -o $out/sqlite3.o 2> $out/stages-$r.txt; done
for r in 1 2 3 4 5; do
  echo "before $(vm)" >> $out/vmstat.txt
  taskset -c 2 $C "${opts[@]}" --lanes 1 -o $out/sqlite3.o
  echo "after $(vm)" >> $out/vmstat.txt
done
perf stat -r 7 -e task-clock,page-faults,cycles:u,cycles:k,instructions:u,instructions:k -o $out/perf-1.txt -- taskset -c 2 $C "${opts[@]}" --lanes 1 -o $out/sqlite3.o
# 8 independent compiles pinned one per physical core, 5 rounds
for r in 1 2 3 4 5; do
  s=$(date +%s%N)
  for c in 0 1 2 3 4 5 6 7; do taskset -c $c $C "${opts[@]}" --lanes 1 -o $out/w$c.o & done
  wait
  e=$(date +%s%N)
  echo "round $r wall_ns $((e-s))" >> $out/workers8.txt
done
perf stat -a -e task-clock,cycles:u,cycles:k,instructions:u -o $out/perf-8.txt -- bash -c 'for c in 0 1 2 3 4 5 6 7; do taskset -c $c '"$C"' '"$(printf '%q ' "${opts[@]}")"' --lanes 1 -o '"$out"'/w$c.o & done; wait'
sha256sum $out/*.o > $out/objects.sha256
echo done > $out/done

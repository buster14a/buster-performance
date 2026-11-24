#!/bin/bash
# measure.sh NAME: the direct path's readings for bin/compiler-NAME and bin/direct-NAME on the frozen sqlite3.c.
# One hold of the lock; CPU 2; the object on /dev/shm.
set -uo pipefail
here=$HOME/buster-fast-bench/2850-direct-tx5wvj
name=$1
out=$here/results/$name
mkdir -p "$out"
C=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
unit=(--lanes 1 --predefines "$C/provenance/gnu17-pinned-predefines.txt" --target=x86_64-linux-gnu -march=znver5 -std=gnu17 -nostdinc
      -isystem "$C/headers/usr/lib/clang/23/include" -isystem "$C/headers/usr/local/include" -isystem "$C/headers/usr/include")
sqlite=(-c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$C/sqlite" "$C/sqlite/sqlite3.c")
hargs=(--predefines "$C/provenance/gnu17-pinned-predefines.txt" -isystem "$C/headers/usr/lib/clang/23/include" -isystem "$C/headers/usr/local/include" -isystem "$C/headers/usr/include"
       -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$C/sqlite" "$C/sqlite/sqlite3.c")
{
  date -u +%FT%TZ; uname -r; cat /proc/loadavg
  ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | head -6
  cat /sys/kernel/mm/transparent_hugepage/enabled /sys/kernel/mm/transparent_hugepage/defrag
} > "$out/host.txt" 2>&1
cmp_o=/dev/shm/direct-tx5wvj-$name.o
# 1. the product's compile: wall and counters, 15 runs
taskset -c 2 "$here/bin/compiler-$name" "${unit[@]}" "${sqlite[@]}" -o "$cmp_o" || echo "compile failed: $?" >> "$out/host.txt"
sha256sum "$cmp_o" > "$out/object.sha256"; ls -l "$cmp_o" >> "$out/object.sha256"
taskset -c 2 perf stat -r 15 -e cycles:u,cycles:k,instructions:u,instructions:k,branches:u,branch-misses:u -o "$out/stat-compile-1.txt" -- "$here/bin/compiler-$name" "${unit[@]}" "${sqlite[@]}" -o "$cmp_o"
taskset -c 2 perf stat -r 15 -e L1-dcache-load-misses:u,l2_cache_req_stat.ic_dc_miss_in_l2:u,dTLB-load-misses:u,iTLB-load-misses:u,page-faults,task-clock -o "$out/stat-compile-2.txt" -- "$here/bin/compiler-$name" "${unit[@]}" "${sqlite[@]}" -o "$cmp_o"
# 2. the stages by the harness: 15 compiles in one process
taskset -c 2 "$here/bin/direct-$name" "${hargs[@]}" -o "$cmp_o.h" --stages --repeat 15 > "$out/stages.txt" 2>&1
cmp "$cmp_o" "$cmp_o.h" >> "$out/object.sha256" 2>&1 && echo "harness object identical" >> "$out/object.sha256"
# 3. the --time-stages report of the product
taskset -c 2 "$here/bin/compiler-$name" "${unit[@]}" "${sqlite[@]}" -o "$cmp_o" --time-stages > "$out/time-stages.txt" 2>&1
# 4. samples by function: cycles, then branch misses, the harness repeating 40 compiles
taskset -c 2 perf record -q -e cycles:u -c 20011 -o "$out/perf-cycles.data" -- "$here/bin/direct-$name" "${hargs[@]}" -o "$cmp_o.h" --repeat 40 > /dev/null 2>&1
perf report -i "$out/perf-cycles.data" --no-children --sort symbol -g none 2> /dev/null | grep -v '^#' | grep -v '^$' | head -120 > "$out/perf-cycles.txt"
taskset -c 2 perf record -q -e branch-misses:u -c 211 -o "$out/perf-bmiss.data" -- "$here/bin/direct-$name" "${hargs[@]}" -o "$cmp_o.h" --repeat 40 > /dev/null 2>&1
perf report -i "$out/perf-bmiss.data" --no-children --sort symbol -g none 2> /dev/null | grep -v '^#' | grep -v '^$' | head -60 > "$out/perf-bmiss.txt"
taskset -c 2 perf record -q -e instructions:u -c 50021 -o "$out/perf-instr.data" -- "$here/bin/direct-$name" "${hargs[@]}" -o "$cmp_o.h" --repeat 40 > /dev/null 2>&1
perf report -i "$out/perf-instr.data" --no-children --sort symbol -g none 2> /dev/null | grep -v '^#' | grep -v '^$' | head -120 > "$out/perf-instr.txt"
# 5. the harness's own counters over 40 compiles (per-compile = /40), user and kernel
taskset -c 2 perf stat -e cycles:u,cycles:k,instructions:u,branches:u,branch-misses:u,page-faults -o "$out/stat-harness-40.txt" -- "$here/bin/direct-$name" "${hargs[@]}" -o "$cmp_o.h" --repeat 40 > /dev/null 2>&1
{ cat /proc/loadavg; ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | head -6; date -u +%FT%TZ; } >> "$out/host.txt" 2>&1
rm -f "$cmp_o" "$cmp_o.h"
echo done > "$out/done"

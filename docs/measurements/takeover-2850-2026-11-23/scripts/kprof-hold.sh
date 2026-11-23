#!/bin/bash
# kprof-hold.sh OUT: two units of sqlite3.c with main's discards (d0) and with discards and pool pages kept (p2d1): the
# kernel's cycles by symbol (perf record, 5 runs each), and the memory calls under p2d1 (strace).
set -uo pipefail
dir="$HOME/buster-fast-bench/2850-claude-01Egbx"
out=$1
cc="$dir/trees/keep5/build/compiler"
sqlite=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
export LC_ALL=C BUSTER_EXPERIMENT_FRESH_LIST="$dir/zero26.list"
mkdir -p "$out/scratch"; cd "$out/scratch"
args=(--lanes 1 -c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$sqlite" "$sqlite/sqlite3.c" "$dir/inputs/sqlite3b.c")
for s in d0 p2d1; do
    case $s in d0) pages=0; discards=0;; p2d1) pages=2; discards=1;; esac
    for i in 1 2 3 4 5; do
        BUSTER_EXPERIMENT_KEEP_PAGES=$pages BUSTER_EXPERIMENT_KEEP_DISCARDS=$discards taskset -c 2 perf record -q -e cycles -c 100003 -o "$out/perf-$s-$i.data" -- "$cc" "${args[@]}" > /dev/null 2>&1
    done
    for i in 1 2 3 4 5; do perf report -i "$out/perf-$s-$i.data" --stdio --no-children --sort symbol -F overhead,period,symbol 2>/dev/null | grep -v '^#' | grep -v '^$'; done > "$out/report-$s.txt"
    rm -f "$out"/perf-$s-*.data
done
BUSTER_EXPERIMENT_KEEP_PAGES=2 BUSTER_EXPERIMENT_KEEP_DISCARDS=1 strace -f -tt -e trace=madvise,munmap,mmap,mprotect -o "$out/p2d1.strace" taskset -c 2 "$cc" "${args[@]}" > /dev/null 2>&1
BUSTER_EXPERIMENT_KEEP_PAGES=2 BUSTER_EXPERIMENT_KEEP_DISCARDS=1 taskset -c 2 "$cc" "${args[@]}" --time-stages > /dev/null 2> "$out/stages-p2d1.txt"
taskset -c 2 "$cc" "${args[@]}" --time-stages > /dev/null 2> "$out/stages-d0.txt"
rm -f ./*.o
echo done > "$out/complete"

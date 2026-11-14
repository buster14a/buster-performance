#!/bin/bash
# selfhost-perf.sh NAME...: each stage 2 compiler's default-tier compile of the frozen sqlite3.c (selfhost-runs.sh's
# first workload), pinned to CPU 2: its retired near returns (its calls) and branches by perf stat (three runs, the
# events ungrouped), and a cycles profile by symbol (perf record, user, a period perf doesn't throttle). #138's record's
# selfhost-perf.sh. Run inside one hold of the lock. results/selfhost/perf-NAME-stat.csv, perf-NAME-symbols.txt.
set -u
cd "$(dirname "$0")"
out=$PWD/results/selfhost
export LC_ALL=C
head -1 /var/lib/buster-9700x/owner >> "$out/holders.txt"
sqlite=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
options=(-c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$sqlite" "$sqlite/sqlite3.c")
tmp=$(mktemp -d /tmp/claude-2541-step2-perf.XXXXXX)
for b in "$@"; do
    compiler=scratch/selfhost/$b/compiler
    taskset -c 2 perf stat -x, -r 3 -o "$out/perf-$b-stat.csv" -e cycles:u,instructions:u,ex_ret_near_ret:u,ex_ret_brn:u,ex_ret_brn_tkn:u,ex_ret_brn_misp:u -- "$compiler" --lanes 1 "${options[@]}" -o "$tmp/out.o" > /dev/null 2>&1
    echo "stat status $?" >> "$out/perf-$b-stat.csv"
    taskset -c 2 perf record -q -o "$tmp/$b.data" -e cycles:u -c 400009 -- "$compiler" --lanes 1 "${options[@]}" -o "$tmp/out.o" > /dev/null 2> "$out/perf-$b-record.log"
    perf report -i "$tmp/$b.data" --no-children --sort sym --stdio -q --percent-limit 0.2 > "$out/perf-$b-symbols.txt" 2>> "$out/perf-$b-record.log"
done
rm -rf "$tmp"
date -u +%FT%TZ > "$out/perf.done"

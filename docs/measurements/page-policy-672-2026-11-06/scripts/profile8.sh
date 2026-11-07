#!/bin/bash
# usage: profile8.sh LABEL COMPILER -- system-wide cycles profile of 3 rounds of 8 independent pinned -c compiles. Under the lock.
cd ~/buster-fast-bench/672-claude
label=$1; C=$2
sqlite=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
d=(-c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$sqlite" "$sqlite/sqlite3.c" --lanes 1)
out=results/$label; mkdir -p $out
perf record -q -a -F 4000 -e cycles -o $out/perf8.data -- bash -c 'for r in 1 2 3; do for c in 0 1 2 3 4 5 6 7; do taskset -c $c "$@" -o /dev/null > /dev/null 2>&1 & done; wait; done' x $C "${d[@]}"
perf report -i $out/perf8.data --no-children --sort dso,symbol --percent-limit 0.25 --stdio 2>/dev/null | grep -v "^#" | grep -v "^$" > $out/profile8.txt
perf report -i $out/perf8.data --no-children --sort dso --stdio 2>/dev/null | grep -v "^#" | grep -v "^$" > $out/profile8-dso.txt
echo done >> $out/profile8.txt

#!/bin/bash
# usage: profile.sh LABEL COMPILER -- cycles profile of 5 pinned -c compiles. Run under the lock.
cd ~/buster-fast-bench/672-claude
label=$1; C=$2
sqlite=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
d=(-c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$sqlite" "$sqlite/sqlite3.c" --lanes 1)
out=results/$label; mkdir -p $out
taskset -c 2 perf record -q -F 20000 -e cycles -o $out/perf.data -- bash -c 'for i in 1 2 3 4 5; do "$@" > /dev/null 2>&1; done' x $C "${d[@]}" -o $out/p.o
perf report -i $out/perf.data --no-children --sort dso,symbol --percent-limit 0.3 --stdio 2>/dev/null | grep -v "^#" | grep -v "^$" > $out/profile.txt
echo done >> $out/profile.txt

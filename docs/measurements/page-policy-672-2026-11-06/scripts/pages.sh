#!/bin/bash
# usage: pages.sh LABEL COMPILER -- huge vs base pages, -E / parse / -c, pinned to CPU 2
cd ~/buster-fast-bench/672-claude
sqlite=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
d=(-DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$sqlite" "$sqlite/sqlite3.c")
out=results/$1; mkdir -p $out
C=$2
for hp in 1 0; do
  BUSTER_HUGE_PAGES=$hp taskset -c 2 $C time-runs --runs 7 --warmups 1 --executable $C --list -E "${d[@]}" -o $out/s.i --list parse "${d[@]}" --list -c "${d[@]}" --lanes 1 -o $out/s.o > $out/pages-hp$hp.txt 2>&1
  for r in 1 2 3; do BUSTER_HUGE_PAGES=$hp taskset -c 2 $C -c "${d[@]}" --lanes 1 --time-stages -o $out/s.o 2> $out/stages-hp$hp-$r.txt; done
done
echo done > $out/pages-done

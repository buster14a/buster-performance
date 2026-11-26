#!/bin/bash
# IBS op samples of 200 compiles each of main (base tree) and the work tree's head, per symbol.
D=$HOME/buster-fast-bench/3577-claude
sqlite=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
export EXCLUSIVE_OWNER=claude-3577 EXCLUSIVE_TITLE="#3577 direct path: IBS attribution of the remaining cost" EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/3597
cd "$D/work" || exit 1
~/buster-fast-bench/exclusive.sh timeout -k 5 590 bash -c '
  sqlite=$1
  flags=(-c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$sqlite" "$sqlite/sqlite3.c")
  for t in base work; do
    (cd ../$t && taskset -c 2 perf record -q -e ibs_op/cnt_ctl=1,swfilt=1/u -c 250000 -o ../pibs-now-$t.data -- bash -c "for i in \$(seq 200); do ./build/compiler \"\$@\" -o /tmp/3577-claude-i.o; done" _ "${flags[@]}" > /dev/null 2>&1) || echo "record failed $t"
  done
' x "$sqlite"
cd "$D" || exit 1
for t in base work; do
  perf report -q -i pibs-now-$t.data --no-children --sort symbol --stdio 2>/dev/null | grep -v "^$" > ibs-now-$t.txt
  perf report -q -i pibs-now-$t.data --no-children --sort srcline --stdio 2>/dev/null | grep -v "^$" > ibs-now-lines-$t.txt
done
wc -l ibs-now-*.txt
echo DONE

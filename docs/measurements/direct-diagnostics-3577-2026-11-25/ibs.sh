#!/bin/bash
# IBS op samples (precise IPs) for base and the work tree, 100 compiles each, in one locked run; reports outside the lock.
D=$HOME/buster-fast-bench/3577-claude
cd "$D" || exit 1
export EXCLUSIVE_OWNER=claude-3577 EXCLUSIVE_TITLE="#3577 direct path: IBS op profiles" EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/3597
~/buster-fast-bench/exclusive.sh timeout -k 5 600 bash -c '
  sqlite=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
  flags=(-c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$sqlite" "$sqlite/sqlite3.c")
  for t in base head; do
    (cd $t && ./build/compiler --version > /dev/null || exit 1)
    (cd $t && taskset -c 2 perf record -q -e ibs_op/cnt_ctl=1,swfilt=1/u -c 500000 -o ../pibs-$t.data -- bash -c "for i in \$(seq 100); do ./build/compiler \"\$@\" -o /tmp/3577-claude-i.o; done" _ "${flags[@]}" > /dev/null 2>&1) || echo "record failed $t"
  done
'
for t in base head; do
  perf report -q -i pibs-$t.data --no-children --sort symbol --stdio 2>/dev/null | grep -v "^$" > ibs2-$t.txt
  perf report -i pibs-$t.data --stdio --sort comm,dso -n -q 2>/dev/null | head -3
done
perf report -q -i pibs-head.data --no-children --sort srcline --stdio 2>/dev/null | grep -v "^$" > ibs2-lines-head.txt
perf report -q -i pibs-base.data --no-children --sort srcline --stdio 2>/dev/null | grep -v "^$" > ibs2-lines-base.txt
wc -l ibs2-*.txt

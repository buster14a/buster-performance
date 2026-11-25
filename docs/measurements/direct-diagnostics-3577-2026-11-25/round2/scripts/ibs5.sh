#!/bin/bash
# IBS op samples of head (19e85f76b) and work (the last abl3.sh variant), 100 compiles each, in one locked run.
D=$HOME/buster-fast-bench/3577-claude
cd "$D" || exit 1
export EXCLUSIVE_OWNER=claude-3577 EXCLUSIVE_TITLE="#3577 direct path: IBS op profiles of a variant" EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/3597
~/buster-fast-bench/exclusive.sh timeout -k 5 600 bash -c '
  sqlite=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
  flags=(-c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$sqlite" "$sqlite/sqlite3.c")
  for t in head work; do
    (cd $t && ./build/compiler --version > /dev/null || exit 1)
    (cd $t && taskset -c 2 perf record -q -e ibs_op/cnt_ctl=1,swfilt=1/u -c 250000 -o ../pibs5-$t.data -- bash -c "for i in \$(seq 100); do ./build/compiler \"\$@\" -o /tmp/3577-claude-i.o; done" _ "${flags[@]}" > /dev/null 2>&1) || echo "record failed $t"
  done
'
for t in head work; do
  perf report -q -i pibs5-$t.data --no-children --sort symbol --stdio 2>/dev/null | grep -v "^$" > ibs5-$t.txt
  perf report -q -i pibs5-$t.data --no-children --sort srcline --stdio 2>/dev/null | grep -v "^$" > ibs5-lines-$t.txt
done
wc -l ibs5-*.txt
echo DONE

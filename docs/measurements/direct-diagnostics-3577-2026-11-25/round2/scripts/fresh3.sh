#!/bin/bash
# #3577: fresh A/B and IBS op profiles of the PR head 19e85f76b against its merge base 09c3b79ba (sqlite3.c's default -c).
# Each build is one locked run; the measurement and both profiles share one; the reports run outside the lock.
D=$HOME/buster-fast-bench/3577-claude
sqlite=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
export EXCLUSIVE_OWNER=claude-3577 EXCLUSIVE_TITLE="#3577 direct path: fresh A/B and IBS of the PR head" EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/3597
for t in base head; do
  cd "$D/$t" || exit 1
  ~/buster-fast-bench/exclusive.sh timeout -k 5 590 ./build.sh --config Release > "$D/build-$t.log" 2>&1 || { echo "BUILD FAILED $t"; tail -5 "$D/build-$t.log"; exit 1; }
  chmod +x build/compiler; ./build/compiler --version > /dev/null || { echo "NO COMPILER $t"; exit 1; }
  echo "built $t $(git log --oneline -1 | cut -c1-12) $(date -u +%H:%M:%S)"
done
cd "$D/head" || exit 1
~/buster-fast-bench/exclusive.sh timeout -k 5 590 bash -c '
  sqlite=$1
  flags=(-c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$sqlite" "$sqlite/sqlite3.c")
  taskset -c 2 ./build/compiler measure-compile --runs 21 --reference ../base/build/compiler -- "${flags[@]}"
  for t in base head; do
    (cd ../$t && taskset -c 2 perf record -q -e ibs_op/cnt_ctl=1,swfilt=1/u -c 500000 -o ../pibs3-$t.data -- bash -c "for i in \$(seq 100); do ./build/compiler \"\$@\" -o /tmp/3577-claude-i.o; done" _ "${flags[@]}" > /dev/null 2>&1) || echo "record failed $t"
  done
' fresh "$sqlite" > "$D/fresh3.out" 2>&1
echo "measure status $? $(date -u +%H:%M:%S)"
cd "$D" || exit 1
for t in base head; do
  perf report -q -i pibs3-$t.data --no-children --sort symbol --stdio 2>/dev/null | grep -v "^$" > ibs3-$t.txt
  perf report -q -i pibs3-$t.data --no-children --sort srcline --stdio 2>/dev/null | grep -v "^$" > ibs3-lines-$t.txt
done
wc -l ibs3-*.txt
echo "DONE $(date -u +%H:%M:%S)"

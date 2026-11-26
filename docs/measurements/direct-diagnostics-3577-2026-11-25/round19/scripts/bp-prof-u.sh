#!/bin/bash
# bp-prof-u.sh: unthrottled profiles of main (base) and the head (work): IBS ops (period 262144 ops) and cycles (period
# 100000), 300 compiles each, below perf_event_max_sample_rate; one hold. Then per-function and per-line reports.
D=$HOME/buster-fast-bench/3577-claude
sqlite=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
export EXCLUSIVE_OWNER=claude-3577 EXCLUSIVE_TITLE="#3577 direct path: unthrottled op and cycle profiles, main vs head" EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/3597
cd "$D" || exit 1
~/buster-fast-bench/exclusive.sh timeout -k 5 590 bash -c '
  sqlite=$1
  flags=(-c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$sqlite" "$sqlite/sqlite3.c" -o /tmp/3577-claude-u.o)
  for t in base work; do
    (cd $t && taskset -c 2 perf record -q -e ibs_op/cnt_ctl=1,swfilt=1/u -c 262144 -o ../pu-op-$t.data -- bash -c "for i in \$(seq 300); do ./build/compiler \"\$@\"; done" _ "${flags[@]}" > /dev/null 2>&1) || echo "record failed $t"
    (cd $t && taskset -c 2 perf record -q -e cycles:u -c 100000 -o ../pu-cyc-$t.data -- bash -c "for i in \$(seq 300); do ./build/compiler \"\$@\"; done" _ "${flags[@]}" > /dev/null 2>&1) || echo "record failed $t"
  done
' x "$sqlite"
dmesg 2>/dev/null | tail -2
for t in base work; do
  for k in op cyc; do
    perf report -q -i pu-$k-$t.data --no-children --comm compiler --sort symbol --stdio -F overhead,sample,symbol 2>/dev/null | grep -v "^$" > pu-$k-$t.txt
    perf report -q -i pu-$k-$t.data --no-children --comm compiler --sort srcline --stdio -F overhead,sample,srcline 2>/dev/null | grep -v "^$" > pu-$k-lines-$t.txt
    echo "$t $k: $(perf report -q -i pu-$k-$t.data --stdio --sort comm -F sample,comm 2>/dev/null | tr -s ' ' | tr '\n' ' ')"
  done
done
echo DONE

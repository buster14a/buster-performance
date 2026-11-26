#!/bin/bash
# bp-io.sh: IBS op samples with their raw registers (-R) of main (base) and the head (work), one hold.
D=$HOME/buster-fast-bench/3577-claude
sqlite=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
export EXCLUSIVE_OWNER=claude-3577 EXCLUSIVE_TITLE="#3577 direct path: IBS op samples with raw registers, main vs head" EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/3597
cd "$D/work" || exit 1
~/buster-fast-bench/exclusive.sh timeout -k 5 590 bash -c '
  sqlite=$1
  flags=(-c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$sqlite" "$sqlite/sqlite3.c" -o /tmp/3577-claude-c.o)
  for t in base work; do
    (cd ../$t && taskset -c 2 perf record -q -R -e ibs_op/cnt_ctl=1,swfilt=1/u -c 65536 -o ../pio-$t.data -- bash -c "for i in \$(seq 20); do ./build/compiler \"\$@\"; done" _ "${flags[@]}" > /dev/null 2>&1) || echo "record failed $t"
  done
' x "$sqlite"
cd "$D" || exit 1
ls -la pio-*.data
perf report -D -i pio-work.data 2>/dev/null | grep -A12 "PERF_RECORD_SAMPLE" | grep -m1 -B14 "work/build/compiler" | head -30
echo DONE

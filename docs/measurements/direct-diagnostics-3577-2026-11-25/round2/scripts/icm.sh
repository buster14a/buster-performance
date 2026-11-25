#!/bin/bash
# L1 instruction cache misses (event sampling) of base and work, 20 compiles each, in one locked run.
D=$HOME/buster-fast-bench/3577-claude
cd "$D" || exit 1
export EXCLUSIVE_OWNER=claude-3577 EXCLUSIVE_TITLE="#3577 direct path: instruction cache miss profiles" EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/3597
~/buster-fast-bench/exclusive.sh timeout -k 5 590 bash -c '
  sqlite=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
  flags=(-c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$sqlite" "$sqlite/sqlite3.c")
  for t in base work; do
    (cd $t && taskset -c 2 perf record -q -e ic_tag_hit_miss.instruction_cache_miss:u -c 5003 -o ../picm-$t.data -- bash -c "for i in \$(seq 20); do ./build/compiler \"\$@\" -o /tmp/3577-claude-i.o; done" _ "${flags[@]}" > /dev/null 2>&1) || echo "record failed $t"
    (cd $t && taskset -c 2 perf record -q -e l2_cache_req_stat.ic_access_in_l2:u -c 5003 -o ../pl2i-$t.data -- bash -c "for i in \$(seq 20); do ./build/compiler \"\$@\" -o /tmp/3577-claude-i.o; done" _ "${flags[@]}" > /dev/null 2>&1) || echo "record failed $t"
  done
'
for t in base work; do
  perf report -q -i picm-$t.data --no-children --sort symbol --stdio 2>/dev/null | grep -v "^$" > icm-$t.txt
  perf report -q -i pl2i-$t.data --no-children --sort symbol --stdio 2>/dev/null | grep -v "^$" > l2i-$t.txt
done
echo DONE

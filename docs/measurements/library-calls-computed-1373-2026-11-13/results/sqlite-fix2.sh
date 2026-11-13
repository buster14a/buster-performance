head -1 /var/lib/buster-9700x/owner >> /home/david/buster-fast-bench/1373-claude/results/holds.txt
{ cat /proc/loadavg; ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | head -8; } > /home/david/buster-fast-bench/1373-claude/results/busy-sqlite-fix2.txt
unset CPATH C_INCLUDE_PATH
for r in $(seq 1 11); do
  for tree in base fix2; do
    c=$([ $tree = base ] && echo /home/david/buster-fast-bench/1373-claude/base-b7a95eed/build/compiler || echo /home/david/buster-fast-bench/1373-claude/fix2-9e873bf6/build/compiler)
    s=$(date +%s%N)
    taskset -c 2 $c --time-stages -c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -I/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite -o /home/david/buster-fast-bench/1373-claude/out/f2-sqlite-$tree.o /var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite/sqlite3.c 2> /home/david/buster-fast-bench/1373-claude/out/f2-sqlite-$tree-$r.stages
    status=$?
    e=$(date +%s%N)
    echo "sqlite $tree $r $(( (e - s) / 1000 )) us status $status"
  done
done
size /home/david/buster-fast-bench/1373-claude/out/f2-sqlite-base.o /home/david/buster-fast-bench/1373-claude/out/f2-sqlite-fix2.o
cmp /home/david/buster-fast-bench/1373-claude/out/sqlite-head.o /home/david/buster-fast-bench/1373-claude/out/f2-sqlite-fix2.o && echo "fix's sqlite object is head's" || echo "fix's sqlite object differs from head's"
for tree in base fix2; do
  c=$([ $tree = base ] && echo /home/david/buster-fast-bench/1373-claude/base-b7a95eed/build/compiler || echo /home/david/buster-fast-bench/1373-claude/fix2-9e873bf6/build/compiler)
  taskset -c 2 perf stat -x, -r 11 -e instructions:u,cycles:u,task-clock -o /home/david/buster-fast-bench/1373-claude/results/perf-sqlite-$tree-3.csv -- $c -c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -I/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite -o /home/david/buster-fast-bench/1373-claude/out/sqlite-perf.o /var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite/sqlite3.c
  echo "perf $tree status $?"
  taskset -c 2 perf stat -x, -r 11 -e instructions:u,cycles:u,task-clock -o /home/david/buster-fast-bench/1373-claude/results/perf-sqlite-syntax-$tree-3.csv -- $c -fsyntax-only -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -I/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite /var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite/sqlite3.c
  echo "perf syntax $tree status $?"
done
{ cat /proc/loadavg; ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | head -8; } >> /home/david/buster-fast-bench/1373-claude/results/busy-sqlite-fix2.txt

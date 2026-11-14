head -1 /var/lib/buster-9700x/owner >> /home/david/buster-fast-bench/1373-claude/results/holds.txt
{ cat /proc/loadavg; ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | head -8; } > /home/david/buster-fast-bench/1373-claude/results/busy-sqlite.txt
unset CPATH C_INCLUDE_PATH
sha256sum /var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite/sqlite3.c
for r in $(seq 1 11); do
  for tree in base head; do
    c=$([ $tree = base ] && echo /home/david/buster-fast-bench/1373-claude/base-b7a95eed/build/compiler || echo /home/david/buster-fast-bench/1373-claude/head-8fad19cd/build/compiler)
    s=$(date +%s%N)
    taskset -c 2 $c --time-stages -c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -I/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite -o /home/david/buster-fast-bench/1373-claude/out/sqlite-$tree.o /var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite/sqlite3.c 2> /home/david/buster-fast-bench/1373-claude/out/sqlite-$tree-$r.stages
    status=$?
    e=$(date +%s%N)
    echo "sqlite $tree $r $(( (e - s) / 1000 )) us status $status"
  done
done
size /home/david/buster-fast-bench/1373-claude/out/sqlite-base.o /home/david/buster-fast-bench/1373-claude/out/sqlite-head.o
for tree in base head; do nm -u /home/david/buster-fast-bench/1373-claude/out/sqlite-$tree.o | grep -cw -e memcpy -e memmove -e memset | sed "s/^/$tree undefined mem* symbols: /"; done
for tree in base head; do
  c=$([ $tree = base ] && echo /home/david/buster-fast-bench/1373-claude/base-b7a95eed/build/compiler || echo /home/david/buster-fast-bench/1373-claude/head-8fad19cd/build/compiler)
  taskset -c 2 perf stat -x, -r 11 -e instructions:u,cycles:u,task-clock -o /home/david/buster-fast-bench/1373-claude/results/perf-sqlite-$tree.csv -- $c -c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -I/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite -o /home/david/buster-fast-bench/1373-claude/out/sqlite-perf.o /var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite/sqlite3.c
  echo "perf $tree status $?"
  taskset -c 2 perf stat -x, -r 11 -e instructions:u,cycles:u,task-clock -o /home/david/buster-fast-bench/1373-claude/results/perf-sqlite-syntax-$tree.csv -- $c -fsyntax-only -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -I/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite /var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite/sqlite3.c
  echo "perf syntax $tree status $?"
done
{ cat /proc/loadavg; ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | head -8; } >> /home/david/buster-fast-bench/1373-claude/results/busy-sqlite.txt

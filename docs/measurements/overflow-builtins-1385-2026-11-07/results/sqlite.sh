head -1 /var/lib/buster-9700x/owner >> /home/david/buster-fast-bench/1385-opencode/results/holds.txt
unset CPATH C_INCLUDE_PATH
sha256sum /var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite/sqlite3.c
for r in $(seq 1 11); do
  for tree in base head; do
    c=$([ $tree = base ] && echo /home/david/buster-fast-bench/1385-opencode/base-73fcf006/build/compiler || echo /home/david/buster-fast-bench/1385-opencode/head-24d2a14b/build/compiler)
    s=$(date +%s%N)
    taskset -c 2 $c -c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -I/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite -o /home/david/buster-fast-bench/1385-opencode/out/sqlite-$tree.o /var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite/sqlite3.c
    status=$?
    e=$(date +%s%N)
    echo "sqlite $tree $r $(( (e - s) / 1000 )) us status $status"
  done
done
cmp /home/david/buster-fast-bench/1385-opencode/out/sqlite-base.o /home/david/buster-fast-bench/1385-opencode/out/sqlite-head.o && echo "sqlite objects identical" || echo "sqlite objects differ"
size /home/david/buster-fast-bench/1385-opencode/out/sqlite-base.o /home/david/buster-fast-bench/1385-opencode/out/sqlite-head.o
for tree in base head; do
  c=$([ $tree = base ] && echo /home/david/buster-fast-bench/1385-opencode/base-73fcf006/build/compiler || echo /home/david/buster-fast-bench/1385-opencode/head-24d2a14b/build/compiler)
  taskset -c 2 perf stat -x, -r 11 -e instructions:u,cycles:u,task-clock -o /home/david/buster-fast-bench/1385-opencode/results/perf-sqlite-$tree.csv -- $c -c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -I/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite -o /home/david/buster-fast-bench/1385-opencode/out/sqlite-perf.o /var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite/sqlite3.c
  echo "perf $tree status $?"
done

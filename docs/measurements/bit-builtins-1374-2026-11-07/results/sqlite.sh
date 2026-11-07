head -1 /var/lib/buster-9700x/owner >> /home/david/buster-fast-bench/1374-opencode/results/holds.txt
unset CPATH C_INCLUDE_PATH
sha256sum /var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite/sqlite3.c
for target in default znver5; do
  march=$([ $target = znver5 ] && echo -march=znver5)
  for r in $(seq 1 11); do
    for tree in base head; do
      c=$([ $tree = base ] && echo /home/david/buster-fast-bench/1374-opencode/base-c3fcc7e2/build/compiler || echo /home/david/buster-fast-bench/1374-opencode/head-8570c6bb/build/compiler)
      s=$(date +%s%N)
      taskset -c 2 $c --time-stages -c $march -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -I/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite -o /home/david/buster-fast-bench/1374-opencode/out/sqlite-$target-$tree.o /var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite/sqlite3.c 2> /home/david/buster-fast-bench/1374-opencode/out/sqlite-$target-$tree-$r.stages
      status=$?
      e=$(date +%s%N)
      echo "sqlite $target $tree $r $(( (e - s) / 1000 )) us status $status"
    done
  done
  cmp /home/david/buster-fast-bench/1374-opencode/out/sqlite-$target-base.o /home/david/buster-fast-bench/1374-opencode/out/sqlite-$target-head.o && echo "sqlite $target objects identical" || echo "sqlite $target objects differ"
  size /home/david/buster-fast-bench/1374-opencode/out/sqlite-$target-base.o /home/david/buster-fast-bench/1374-opencode/out/sqlite-$target-head.o
  for tree in base head; do
    c=$([ $tree = base ] && echo /home/david/buster-fast-bench/1374-opencode/base-c3fcc7e2/build/compiler || echo /home/david/buster-fast-bench/1374-opencode/head-8570c6bb/build/compiler)
    taskset -c 2 perf stat -x, -r 11 -e instructions:u,cycles:u,task-clock -o /home/david/buster-fast-bench/1374-opencode/results/perf-sqlite-$target-$tree.csv -- $c -c $march -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -I/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite -o /home/david/buster-fast-bench/1374-opencode/out/sqlite-perf.o /var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite/sqlite3.c
    echo "perf $target $tree status $?"
  done
done

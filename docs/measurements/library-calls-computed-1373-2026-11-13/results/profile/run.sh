head -1 /var/lib/buster-9700x/owner >> /home/david/buster-fast-bench/1373-claude/results/holds.txt
unset CPATH C_INCLUDE_PATH
for tree in base fix; do
  c=$([ $tree = base ] && echo /home/david/buster-fast-bench/1373-claude/base-b7a95eed/build/compiler || echo /home/david/buster-fast-bench/1373-claude/fix-1228e539/build/compiler)
  taskset -c 2 perf record -q -e instructions:u -c 200003 -o /home/david/buster-fast-bench/1373-claude/results/profile/$tree.data -- $c -c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -I/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite -o /home/david/buster-fast-bench/1373-claude/out/sqlite-prof.o /var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite/sqlite3.c
  echo "record $tree status $?"
done

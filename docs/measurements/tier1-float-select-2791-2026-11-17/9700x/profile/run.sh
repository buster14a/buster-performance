head -1 /var/lib/buster-9700x/owner >> holds.txt
for i in $(seq 1 3); do
    for n in main final; do taskset -c 2 perf record -q -e cycles:u -c $((200003 + 2 * i)) -o $n-$i.data -- /home/david/buster-fast-bench/2791-claude/$n/build/compiler --tier1 -c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -I/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite /var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite/sqlite3.c -o /dev/shm/claude-2791-profile.o; done
done
rm -f /dev/shm/claude-2791-profile.o

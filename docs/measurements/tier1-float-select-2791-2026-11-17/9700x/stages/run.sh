head -1 /var/lib/buster-9700x/owner >> holds.txt
echo "== $(cat /proc/loadavg)" > busy.txt
ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | head -6 >> busy.txt
for i in $(seq 1 7); do
    for n in main final; do taskset -c 2 /home/david/buster-fast-bench/2791-claude/$n/build/compiler --tier1 --time-stages -c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -I/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite /var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite/sqlite3.c -o /dev/shm/claude-2791-stages.o 2> stages-$n-$i.txt; done
done
rm -f /dev/shm/claude-2791-stages.o

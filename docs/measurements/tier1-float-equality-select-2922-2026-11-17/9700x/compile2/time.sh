head -1 /var/lib/buster-9700x/owner >> holds.txt
echo "== $(cat /proc/loadavg)" > busy.txt
ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | head -8 >> busy.txt
taskset -c 2 /home/david/buster-fast-bench/2922-claude/final/build/compiler time-runs --runs 11 --build base /home/david/buster-fast-bench/2922-claude/base/build/compiler --build final /home/david/buster-fast-bench/2922-claude/final/build/compiler --list --tier1 -c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -I/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite /var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite/sqlite3.c -o /dev/shm/claude-2922-runs.o
rm -f /dev/shm/claude-2922-runs.o
echo "== after $(cat /proc/loadavg)" >> busy.txt

set -u
cd "/home/david/buster-fast-bench/droid-zen5/prof-base"
options=(-c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite" "/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite/sqlite3.c")
c=/home/david/buster-fast-bench/droid-zen5/base-9a511a6a/build/compiler
for i in 1 2 3; do taskset -c 2 $c "${options[@]}" -o sqlite3.o --time-stages 2> stages-$i.txt; echo "stages $i status $?"; done
taskset -c 2 $c "${options[@]}" -o sqlite3.o --lanes 1 --time-stages 2> stages-l1.txt; echo "stages lanes1 status $?"
events=task-clock,page-faults,cycles:u,instructions:u,cycles:k,instructions:k,branch-misses:u
taskset -c 2 perf stat -r 11 -e "$events" -o stat.txt -- $c "${options[@]}" -o sqlite3.o; echo "stat status $?"
taskset -c 2 perf stat -r 11 -e "$events" -o stat-l1.txt -- $c "${options[@]}" --lanes 1 -o sqlite3.o; echo "stat l1 status $?"
taskset -c 2 perf record -q -F 20000 -o perf.data -- bash -c 'for run in 1 2 3 4 5; do "$@" > /dev/null 2>&1 || exit 1; done' compile $c "${options[@]}" --lanes 1 -o sqlite3.o; echo "record status $?"

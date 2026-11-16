#!/bin/bash
# quick-ab.sh OUT ROUNDS NAME=COMPILER...: -c sqlite3.c (the census's options) by each compiler in turn, ROUNDS rounds, on
# CPU 2 under perf stat (the task's page faults, minor faults and kernel and user cycles: per-task counts, without the
# teardown); each object compared with the first compiler's. OUT/NAME-ROUND.csv, OUT/objects.txt. One hold of the lock.
set -u
cd "$(dirname "$0")"
out=$1
rounds=$2
shift 2
mkdir -p "$out"
sqlite=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
first=""
: > "$out/objects.txt"
for ((r = 0; r < rounds; r += 1)); do
    for spec in "$@"; do
        name=${spec%%=*}
        compiler=${spec#*=}
        taskset -c 2 perf stat -x, -e page-faults,minor-faults,cycles:k,cycles:u -o "$out/$name-$r.csv" -- "$compiler" -c -DSQLITE_OMIT_LOAD_EXTENSION \
            -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$sqlite" "$sqlite/sqlite3.c" -o "/dev/shm/1167-$name.o" 2> "$out/$name-$r.err"
        if [ -z "$first" ]; then first=$name; fi
        echo "$r $name $(cmp -s "/dev/shm/1167-$first.o" "/dev/shm/1167-$name.o" && echo same || echo DIFFERENT) $(wc -c < "$out/$name-$r.err")" >> "$out/objects.txt"
    done
done
rm -f /dev/shm/1167-*.o

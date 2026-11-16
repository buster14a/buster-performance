#!/bin/bash
# cpuwide-ab.sh OUT ROUNDS A=COMPILER B=COMPILER: -c sqlite3.c (the census's options) by A and B, ROUNDS rounds in ABBA
# order, each compile on CPU 2 under waitall (which waits for the exit helper), counted on CPU 2 as a whole (perf stat
# -C 2: kernel and user cycles and page faults, the exit's teardown included, as #2873's census counted). OUT/NAME-ROUND.csv;
# each object compared with A's (OUT/objects.txt). One hold of the lock.
set -u
cd "$(dirname "$0")"
out=$1
rounds=$2
a=$3
b=$4
mkdir -p "$out"
sqlite=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
: > "$out/objects.txt"
run()
{
    local name=${1%%=*} compiler=${1#*=} round=$2
    perf stat -C 2 -x, -e cycles:k,cycles:u,page-faults -o "$out/$name-$round.csv" -- taskset -c 2 tools/waitall "$compiler" -c -DSQLITE_OMIT_LOAD_EXTENSION \
        -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$sqlite" "$sqlite/sqlite3.c" -o "/dev/shm/1167-$name.o" 2> "$out/$name-$round.err"
}
for ((r = 0; r < rounds; r += 1)); do
    if ((r % 2 == 0)); then run "$a" $r; run "$b" $r; else run "$b" $r; run "$a" $r; fi
    echo "$r $(cmp -s /dev/shm/1167-${a%%=*}.o /dev/shm/1167-${b%%=*}.o && echo same || echo DIFFERENT)" >> "$out/objects.txt"
done
rm -f /dev/shm/1167-*.o

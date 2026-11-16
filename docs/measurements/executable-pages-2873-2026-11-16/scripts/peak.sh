#!/bin/bash
# peak.sh OUT ROUNDS A=COMPILER B=COMPILER: -c sqlite3.c (the census's options) by A and B, ROUNDS rounds in ABBA order
# on CPU 2 after three warm-ups each, from fresh copies of both executables, each one's peak resident set
# (tools/peakrss: wait4's ru_maxrss, KB) in OUT/peak.txt: round-name, KB, status. One hold of the lock.
set -u
cd "$(dirname "$0")"
out=$1
rounds=$2
a=$3
b=$4
mkdir -p "$out"
for spec in "$a" "$b"; do
    cp "${spec#*=}" "$out/${spec%%=*}.compiler"
done
a="${a%%=*}=$PWD/$out/${a%%=*}.compiler"
b="${b%%=*}=$PWD/$out/${b%%=*}.compiler"
sqlite=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
: > "$out/peak.txt"
run()
{
    local name=${1%%=*} compiler=${1#*=} round=$2
    taskset -c 2 tools/peakrss "$out/peak.txt" "$round-$name" "$compiler" -c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 \
        -DSQLITE_ENABLE_RTREE "-I$sqlite" "$sqlite/sqlite3.c" -o /dev/shm/2873-peak.o
}
for w in 1 2 3; do run "$a" warm; run "$b" warm; done
sleep 1
for ((r = 0; r < rounds; r += 1)); do
    if ((r % 2 == 0)); then run "$a" $r; run "$b" $r; else run "$b" $r; run "$a" $r; fi
done
rm -f /dev/shm/2873-peak.o "$out"/*.compiler

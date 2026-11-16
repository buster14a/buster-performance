#!/bin/bash
# events.sh OUT ROUNDS A=COMPILER B=COMPILER: sqlite3.c's -c by A and B from fresh copies, ROUNDS rounds in ABBA order
# after 3 warm-ups each, the compile's own task counted (perf stat, not CPU-wide; user mode): cycles, instructions,
# data and instruction TLB misses, L1 data misses, L2 misses, mispredicted branches. OUT/NAME-ROUND.csv. One hold of
# the lock.
set -u
cd "$(dirname "$0")"
here=$PWD
out=$1
rounds=$2
mkdir -p "$out"
sqlite=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
names=()
declare -A copy
for spec in "$3" "$4"; do
    name=${spec%%=*}
    cp "${spec#*=}" "$out/$name.compiler" || exit 1
    copy[$name]=$here/$out/$name.compiler
    names+=("$name")
done
run() { taskset -c 2 "${copy[$1]}" -c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$sqlite" "$sqlite/sqlite3.c" -o "/dev/shm/2873-ev-$1.o"; }
count() { perf stat -x, -e cycles:u,instructions:u,dTLB-load-misses:u,iTLB-load-misses:u,L1-dcache-load-misses:u,l2_cache_req_stat.ic_dc_miss_in_l2:u,branch-misses:u,ls_dispatch.ld_st_dispatch:u -o "$out/$1-$2.csv" -- taskset -c 2 "${copy[$1]}" -c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$sqlite" "$sqlite/sqlite3.c" -o "/dev/shm/2873-ev-$1.o" 2> "$out/$1-$2.err"; }
a=${names[0]}
b=${names[1]}
for w in 1 2 3; do run "$a"; run "$b"; done
for ((r = 0; r < rounds; r += 1)); do
    if ((r % 2 == 0)); then count "$a" $r; count "$b" $r; else count "$b" $r; count "$a" $r; fi
done
rm -f /dev/shm/2873-ev-* "$out"/*.compiler

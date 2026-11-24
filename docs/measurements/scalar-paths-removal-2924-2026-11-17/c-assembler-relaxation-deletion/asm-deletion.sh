#!/bin/bash
# #2924 C11b's deletion run: base = the tests commit (both paths, the vector default) against head (the scalar relaxation
# alone, every other step vector). Every build and run under the lock, runs on CPU 2: the objects `assemble` makes of
# gcc's and clang's -S of sqlite3.c and of Lua's lvm.c must be the same; then ab, three rounds, around time-runs (five
# runs each) of each input; then benchmark-assembler's four workloads at 2,048 functions, base and head alternately.
set -uo pipefail
cd "$(dirname "$0")"
D=$PWD
. ~/buster-fast-bench/2924-asm-pp-claude/env.sh
L=$EX
R=$D/asm-deletion
mkdir -p $R/logs $R/inputs $R/compilers
BASE=${BASE:?}; HEAD=${HEAD:?}
for side in base head; do
    rev=$BASE; [ $side = head ] && rev=$HEAD
    if [ ! -d $R/$side ]; then git clone -q --shared $W/src $R/$side || exit 1; fi
    git -C $R/$side fetch -q https://github.com/buster14a/buster claude/2924-assembler && git -C $R/$side checkout -q --detach $rev || { echo "checkout $side failed" >> $R/logs/status.txt; exit 1; }
    (cd $R/$side && $L timeout -k 5 900 ./build.sh --config Release > $R/logs/build-$side.log 2>&1) || { echo "build $side failed" >> $R/logs/status.txt; exit 1; }
    cp $R/$side/build/compiler $R/compilers/$side
done
corpus=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
lua=~/buster-fast-bench/2924-c-df-claude/c3pr/inputs/lua-5.4.8/src
S=(-DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -I"$corpus/sqlite")
$L timeout -k 5 600 gcc -O2 -S "${S[@]}" -o $R/inputs/sqlite3-gcc.s "$corpus/sqlite/sqlite3.c"; echo "input gcc: $?" >> $R/logs/status.txt
$L timeout -k 5 600 clang -O2 -masm=intel -S "${S[@]}" -o $R/inputs/sqlite3-clang-intel.s "$corpus/sqlite/sqlite3.c"; echo "input clang: $?" >> $R/logs/status.txt
$L timeout -k 5 600 clang -O2 -S -o $R/inputs/lvm-clang.s "$lua/lvm.c"; echo "input lvm: $?" >> $R/logs/status.txt
for input in sqlite3-gcc sqlite3-clang-intel lvm-clang; do
    for side in base head; do
        $L timeout -k 5 300 taskset -c 2 $R/compilers/$side assemble -o $R/inputs/$input-$side.o $R/inputs/$input.s 2> $R/logs/assemble-$input-$side.err; echo "assemble $input $side: $?" >> $R/logs/status.txt
    done
    cmp -s $R/inputs/$input-base.o $R/inputs/$input-head.o; echo "same object $input: $?" >> $R/logs/status.txt
done
time=/dev/shm/claude-2924-asm-time
rm -f $R/compilers/hl; mkdir -p $R/compilers/hl; cp $R/compilers/base $R/compilers/hl/base; cp $R/compilers/head $R/compilers/hl/head
for input in sqlite3-gcc sqlite3-clang-intel lvm-clang; do
    rm -rf "$time"; mkdir -p "$time"
    (cd "$time" && $R/compilers/head ab --rounds 3 --cpu 2 --lock $L $R/compilers/head \
        -- time-runs --runs 5 --directory "$time" --build base $R/compilers/hl/base --build head $R/compilers/hl/head --list assemble -o "$time/out.o" $R/inputs/$input.s > $R/logs/time-$input.log 2>&1)
    echo "time $input: $?" >> $R/logs/status.txt
done
rm -rf "$time"
for round in 1 2 3; do
    for side in base head; do
        for workload in mixed registers simd att; do
            $L timeout -k 5 300 taskset -c 2 $R/compilers/$side benchmark-assembler --workload $workload --functions 2048 > $R/logs/bench-$workload-$side-$round.log 2>&1
            echo "bench $workload $side $round: $?" >> $R/logs/status.txt
        done
    done
done
echo done >> $R/logs/status.txt

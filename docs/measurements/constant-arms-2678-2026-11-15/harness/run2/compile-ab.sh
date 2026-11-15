#!/bin/bash
# -c sqlite3.c by MAIN's and HEAD's compilers (CI's frozen corpus and its options, less --no-default-config, which -c
# doesn't take): in one lock hold, each object's sizes, instructions and constant-conversion pairs (pairs.c) at Tier 0
# and Tier 1; then ROUNDS rounds, main then head, of perf stat -r 11 pinned to CPU 2, each run a hold of its own; then
# the same rounds of benchmark-lowering-source (warm lowering, in memory). Usage: compile-ab.sh MAIN HEAD CORPUS [ROUNDS]
set -e
dir=$(cd "$(dirname "$0")" && pwd)
main=$1
head=$2
corpus=$3
rounds=${4:-3}
unset CPATH C_INCLUDE_PATH
flags="--predefines $corpus/provenance/gnu17-pinned-predefines.txt --target=x86_64-linux-gnu -march=znver5 -std=gnu17 -nostdinc -isystem $corpus/headers/usr/lib/clang/23/include -isystem $corpus/headers/usr/local/include -isystem $corpus/headers/usr/include"
mkdir -p "$dir/compile"
"$dir/lock.sh" objects bash -c '
    set -e
    cd "$1/compile"
    clang -O2 -o pairs ../pairs.c
    for side in main head; do
        compiler=$2
        [ $side = head ] && compiler=$3
        "$compiler" -c $4 -o $side-t0.o "$5"
        "$compiler" -c --tier1 $4 -o $side-t1.o "$5"
        for tier in t0 t1; do
            echo "objects $side $tier $(size $side-$tier.o | tail -1 | awk "{print \"text=\" \$1 \" data=\" \$2 \" bss=\" \$3}") $(objdump -d --no-show-raw-insn $side-$tier.o | ./pairs)"
        done
    done
    sha256sum "$2" "$3" main-t0.o head-t0.o main-t1.o head-t1.o "$5"' _ "$dir" "$main" "$head" "$flags" "$corpus/sqlite/sqlite3.c"
for round in $(seq 1 $rounds); do
    for side in main head; do
        compiler=$main
        [ $side = head ] && compiler=$head
        set +e
        "$dir/lock.sh" perf-$side-$round bash -c 'taskset -c 2 perf stat -r 11 -x, -e instructions:u,cycles:u,task-clock "$1" -c $2 -o /dev/null "$3" 2> "$4"' _ "$compiler" "$flags" "$corpus/sqlite/sqlite3.c" "$dir/compile/perf-$side-$round.csv"
        status=$?
        set -e
        echo "perf $side round $round exit $status"
        cat "$dir/compile/perf-$side-$round.csv"
    done
done
for round in $(seq 1 $rounds); do
    for side in main head; do
        compiler=$main
        [ $side = head ] && compiler=$head
        set +e
        "$dir/lock.sh" lowering-$side-$round bash -c 'taskset -c 2 "$1" benchmark-lowering-source --passes 5 $2 "$3" > "$4" 2>&1' _ "$compiler" "$flags" "$corpus/sqlite/sqlite3.c" "$dir/compile/lowering-$side-$round.txt"
        status=$?
        set -e
        echo "lowering $side round $round exit $status"
        cat "$dir/compile/lowering-$side-$round.txt"
    done
done

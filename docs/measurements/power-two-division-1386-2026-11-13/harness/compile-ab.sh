#!/bin/bash
# -c sqlite3.c by MAIN's and HEAD's compilers (CI's frozen corpus and options, less --no-default-config, which -c
# doesn't take): each object's sizes and its div/idiv count at Tier 0 and Tier 1 (one lock hold), then perf stat -r 11
# of each, pinned to CPU 2, alternated twice, each a hold of its own. Usage: compile-ab.sh MAIN HEAD CORPUS
set -e
dir=$(cd "$(dirname "$0")" && pwd)
main=$1
head=$2
corpus=$3
unset CPATH C_INCLUDE_PATH
flags="--predefines $corpus/provenance/gnu17-pinned-predefines.txt --target=x86_64-linux-gnu -march=znver5 -std=gnu17 -nostdinc -isystem $corpus/headers/usr/lib/clang/23/include -isystem $corpus/headers/usr/local/include -isystem $corpus/headers/usr/include"
mkdir -p "$dir/compile"
"$dir/lock.sh" objects bash -c '
    set -e
    cd "$1/compile"
    for side in main head; do
        compiler=$2
        [ $side = head ] && compiler=$3
        "$compiler" -c $4 -o $side-t0.o "$5"
        "$compiler" -c --tier1 $4 -o $side-t1.o "$5"
        for tier in t0 t1; do
            echo "objects $side $tier $(size $side-$tier.o | tail -1 | awk "{print \"text=\" \$1 \" data=\" \$2 \" bss=\" \$3}") divides=$(objdump -d --no-show-raw-insn $side-$tier.o | grep -cE "\s(i?div)[lq]?\s")"
        done
    done' _ "$dir" "$main" "$head" "$flags" "$corpus/sqlite/sqlite3.c"
for round in 1 2; do
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
sha256sum "$main" "$head" "$dir"/compile/main-t0.o "$dir"/compile/head-t0.o "$dir"/compile/main-t1.o "$dir"/compile/head-t1.o "$corpus/sqlite/sqlite3.c"

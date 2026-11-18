#!/bin/bash
# #2924 C11's gate: the assembler's vector path against its scalar twin (--scalar), on main 0c113feb1's Release build
# (c10gate's), every run under the lock on CPU 2: benchmark-assembler's four synthetic workloads at 1, 4, 16, 64, 256
# and 2,048 functions, and three real inputs: sqlite3.c by gcc -O2 -S (AT&T), by clang -O2 -S -masm=intel (Intel), and
# Lua's lvm.c by clang -O2 -S (AT&T).
set -uo pipefail
cd "$(dirname "$0")"
D=$PWD
export EXCLUSIVE_OWNER=claude-2924 EXCLUSIVE_TITLE="Scalar paths removed: the assembler's gate" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2924
L=~/buster-fast-bench/exclusive.sh
C=$D/../c10gate/compiler
mkdir -p logs inputs
corpus=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
sqlite=$corpus/sqlite
lua=$D/../c3pr/inputs/lua-5.4.8/src
S=(-DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -I"$sqlite" "$sqlite/sqlite3.c")
[ -f inputs/sqlite3-gcc.s ] || $L timeout -k 5 900 gcc -O2 -S -o inputs/sqlite3-gcc.s "${S[@]}" > logs/inputs.log 2>&1
[ -f inputs/sqlite3-clang-intel.s ] || $L timeout -k 5 900 clang -O2 -S -masm=intel -o inputs/sqlite3-clang-intel.s "${S[@]}" >> logs/inputs.log 2>&1
[ -f inputs/lvm-clang.s ] || $L timeout -k 5 900 clang -O2 -S -o inputs/lvm-clang.s "$lua/lvm.c" >> logs/inputs.log 2>&1
wc -c inputs/*.s > logs/inputs-sizes.txt
for workload in mixed registers simd att; do
    for functions in 1 4 16 64 256 2048; do
        name="$workload-$functions"
        $L timeout -k 5 900 taskset -c 2 "$C" benchmark-assembler --workload "$workload" --functions "$functions" > "logs/$name.log" 2>&1
        echo "$name: $?" >> logs/status.txt
    done
done
for input in sqlite3-gcc sqlite3-clang-intel lvm-clang; do
    $L timeout -k 5 900 taskset -c 2 "$C" benchmark-assembler --input "inputs/$input.s" > "logs/input-$input.log" 2>&1
    echo "input-$input: $?" >> logs/status.txt
done
echo done >> logs/status.txt

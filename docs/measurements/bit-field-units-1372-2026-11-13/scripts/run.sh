#!/bin/bash
# #1372's measurements: k_bits by each compiler with one clang -O2 driver, perf stat'd on CPU 2 (each variant its own
# locked run), then whole compiles timed by time-runs (each its own locked run).
set -euo pipefail
cd ~/buster-fast-bench/1372-claude
export EXCLUSIVE_OWNER=claude-1372 EXCLUSIVE_TITLE="Bit-field access units (#1372)" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/1372
lock=~/buster-fast-bench/exclusive.sh
corpus=~/buster-fast-bench/corpus-391e729af658
mkdir -p out
clang -O2 -c driver.c -o out/driver.o
clang -O0 -c k_bits.c -o out/k-clang-O0.o
clang -O2 -c k_bits.c -o out/k-clang-O2.o
for tree in base head; do
    "$tree/build/compiler" -c k_bits.c -o "out/k-$tree-tier0.o"
    "$tree/build/compiler" -c --tier1 k_bits.c -o "out/k-$tree-tier1.o"
done
variants="base-tier0 head-tier0 base-tier1 head-tier1 clang-O0 clang-O2"
for v in $variants; do
    clang out/driver.o "out/k-$v.o" -o "out/bench-$v"
    objdump -d --no-show-raw-insn "out/k-$v.o" > "out/k-$v.s"
done
sha256sum out/*.o out/bench-* base/build/compiler head/build/compiler > out/identities.sha256
events=cycles:u,instructions:u,ls_bad_status2.stli_other:u,ls_stlf:u
for round in 1 2 3; do
    for v in $variants; do
        $lock timeout 300 perf stat -x, -r 5 -e "$events" -o "out/perf-$v-$round.csv" taskset -c 2 "out/bench-$v" 50000000 > "out/result-$v-$round.txt"
    done
done
gcc -O2 gen_fields.c -o out/gen_fields 2>/dev/null || clang -O2 gen_fields.c -o out/gen_fields
out/gen_fields > out/fields.c
sqlite=(--predefines "$corpus/provenance/gnu17-pinned-predefines.txt" --no-default-config --target=x86_64-linux-gnu -march=znver5 -std=gnu17 -nostdinc
        -isystem "$corpus/headers/usr/lib/clang/23/include" -isystem "$corpus/headers/usr/local/include" -isystem "$corpus/headers/usr/include")
$lock timeout 600 taskset -c 2 head/build/compiler time-runs --runs 21 --warmups 2 --build base base/build/compiler --build head head/build/compiler \
    --list -c "${sqlite[@]}" "$corpus/sqlite/sqlite3.c" -o /tmp/1372-claude-sqlite.o > out/time-sqlite-c.txt 2>&1
$lock timeout 600 taskset -c 2 head/build/compiler time-runs --runs 21 --warmups 2 --build base base/build/compiler --build head head/build/compiler \
    --list -c out/fields.c -o /tmp/1372-claude-fields.o > out/time-fields-c.txt 2>&1
echo done

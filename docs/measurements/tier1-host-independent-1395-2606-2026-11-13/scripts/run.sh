#!/usr/bin/env bash
# Builds the chain kernels by each configuration and times them on CPU 2. COMPILER is the buster build to test.
set -eu
compiler=$1
cd "$(dirname "$0")"
clang -O2 -c driver.c -o driver.o
"$compiler" -c --tier1 kernels.c -o tier1-vector.o
"$compiler" -c --tier1 --scalar kernels.c -o tier1-scalar.o
clang -O0 -c kernels.c -o clang-O0.o
clang -O2 -fno-vectorize -c kernels.c -o clang-O2.o
cmp tier1-vector.o tier1-scalar.o && echo "tier1 vector and scalar objects: identical"
for c in tier1-vector tier1-scalar clang-O0 clang-O2; do
    clang driver.o $c.o -o $c
done
for c in tier1-vector tier1-scalar clang-O0 clang-O2; do
    echo "== $c"
    taskset -c ${BENCH_CPU:-2} ./$c ${BENCH_RUNS:-11}
done
objdump -d --no-show-raw-insn tier1-vector.o > tier1-vector.s

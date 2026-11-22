#!/bin/bash
# #3298's kernel on the 9700X: buster --tier1 with and without the tables pass, clang -O2 and -O0, 11 runs each,
# pinned to CPU 2, under the lock per build/run batch.

cd "$(dirname "$0")"
B=$PWD/buster/build/compiler
X="EXCLUSIVE_OWNER=claude-3298"
echo "commit $(git -C buster rev-parse HEAD)"
"$B" --version 2>/dev/null | head -1 || true
clang --version | head -1
$B --tier1 -O2 -o k-tier1 bench.c
$B --tier1 --tier1-passes=-tables -O2 -o k-tier1-off bench.c
$B -o k-tier0 bench.c
clang -O2 -o k-clang-O2 bench.c
clang -O0 -o k-clang-O0 bench.c
$B --tier1 -c -o k-tier1.o bench.c
objdump -d --no-show-raw-insn k-tier1.o | sed -n '/<f>:/,/^$/p'
for e in k-tier1-off k-tier1 k-tier0 k-clang-O2 k-clang-O0; do
    for r in $(seq 1 11); do
        s=$(date +%s%N); taskset -c 2 ./$e || true; e2=$(date +%s%N)
        echo "$e run$r $(( (e2 - s) / 1000 )) us"
    done
done
for e in k-tier1-off k-tier1 k-clang-O2; do
    perf stat -x, -e cycles,instructions,branches,branch-misses taskset -c 2 ./$e 2>&1 | sed "s/^/$e perf /"
done

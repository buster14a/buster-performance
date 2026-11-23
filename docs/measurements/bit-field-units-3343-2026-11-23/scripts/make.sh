#!/bin/bash
# #3343 (#1372 leftovers): the kernels' objects by base's and head's Tier 0, Tier 1 and Tier 1 with value numbering with
# memory (--tier1-passes=+memory), and by clang -O0 and -O2; each kernel's executable is the same clang -O2 driver
# linked with one object. Every executable's result must agree across the variants. Run under one hold of the lock.
set -euo pipefail
cd ~/buster-fast-bench/1372-3343-claude
mkdir -p out
for c in base head; do
    bin/compiler-$c -c m/kernels.c -o out/k-$c-tier0.o
    bin/compiler-$c -c --tier1 m/kernels.c -o out/k-$c-tier1.o
    bin/compiler-$c -c --tier1 --tier1-passes=+memory m/kernels.c -o out/k-$c-tier1mem.o
done
clang -O0 -c m/kernels.c -o out/k-clang-O0.o
clang -O2 -c m/kernels.c -o out/k-clang-O2.o
variants="base-tier0 head-tier0 base-tier1 head-tier1 base-tier1mem head-tier1mem clang-O0 clang-O2"
for k in 0 1 2 3 4; do
    clang -O2 -DKERNEL=$k -c m/driver.c -o out/d$k.o
    for v in $variants; do clang out/d$k.o out/k-$v.o -o out/bench-$k-$v; done
    results=$(for v in $variants; do out/bench-$k-$v 1000000; done | sort -u)
    echo "kernel $k: $results"
    [ "$(printf '%s\n' "$results" | wc -l)" = 1 ]
done
for v in $variants; do objdump -d --no-show-raw-insn out/k-$v.o > out/k-$v.s; done
clang --version | head -1 > out/clang.txt
sha256sum bin/compiler-* out/k-*.o > out/identities.sha256

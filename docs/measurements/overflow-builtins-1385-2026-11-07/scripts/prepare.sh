#!/bin/bash
# #1385: the kernels' objects by each tree's compiler (Tier 0 and Tier 1, the default x86-64 target, whose forms the
# rows and recipes use at every target) and by clang -O0 and -O2, each linked with one clang -O2 driver object; the
# issue's functions' and the kernels' instruction counts. One lock hold.
set -eu
cd ~/buster-fast-bench/1385-opencode
mkdir -p bin counts
clang -O2 -c drv.c -o bin/drv.o
for tree in base head; do
    compiler=$(ls -d $tree-*/build/compiler)
    "$compiler" -c kern.c -o bin/k-$tree-t0.o
    "$compiler" --tier1 -c kern.c -o bin/k-$tree-t1.o
    clang bin/k-$tree-t0.o bin/drv.o -o bin/$tree-t0
    clang bin/k-$tree-t1.o bin/drv.o -o bin/$tree-t1
    "$compiler" -c funcs.c -o counts/f-$tree-t0.o
    "$compiler" --tier1 -c funcs.c -o counts/f-$tree-t1.o
done
clang -O0 -c kern.c -o bin/k-clang-O0.o
clang -O2 -c kern.c -o bin/k-clang-O2.o
clang bin/k-clang-O0.o bin/drv.o -o bin/clang-O0
clang bin/k-clang-O2.o bin/drv.o -o bin/clang-O2
clang -O0 -c funcs.c -o counts/f-clang-O0.o
clang -O2 -c funcs.c -o counts/f-clang-O2.o
for o in counts/f-*.o bin/k-*.o; do
    objdump -d --no-show-raw-insn "$o" | awk -v object="$o" '/^[0-9a-f]+ <.*>:$/{name=$2} /^ +[0-9a-f]+:/{ if ($0 ~ /int3|nop/) next; c[name]++} END{for(n in c) print object "\t" n "\t" c[n]}' | sort
done > counts/instructions.tsv
ls bin
{ uname -a; clang --version | head -1; cat /sys/devices/system/cpu/cpu2/cpufreq/scaling_governor /sys/devices/system/cpu/cpu2/cpufreq/energy_performance_preference; cat */COMMIT; sha256sum */build/compiler bin/* counts/*.o; } > host.txt 2>&1

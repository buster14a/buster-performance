#!/bin/bash
# #1374: the kernel's objects by each tree's compiler (Tier 0 and Tier 1, three targets) and by clang -O0 and -O2, each
# linked with one clang -O2 driver object; one lock hold.
set -eu
cd ~/buster-fast-bench/1374-opencode
mkdir -p bin
clang -O2 -c drv.c -o bin/drv.o
for march in x86-64 x86-64-v3 znver5; do
    for tree in base head; do
        compiler=$(ls -d $tree-*/build/compiler)
        "$compiler" -march=$march -c kern.c -o bin/k-$tree-t0-$march.o
        "$compiler" -march=$march --tier1 -c kern.c -o bin/k-$tree-t1-$march.o
        clang bin/k-$tree-t0-$march.o bin/drv.o -o bin/$tree-t0-$march
        clang bin/k-$tree-t1-$march.o bin/drv.o -o bin/$tree-t1-$march
    done
    clang -O0 -march=$march -c kern.c -o bin/k-clang-O0-$march.o
    clang -O2 -march=$march -c kern.c -o bin/k-clang-O2-$march.o
    clang bin/k-clang-O0-$march.o bin/drv.o -o bin/clang-O0-$march
    clang bin/k-clang-O2-$march.o bin/drv.o -o bin/clang-O2-$march
done
for b in bin/*-*-*; do [[ -x $b && ! $b == *.o ]] && objdump -d --no-show-raw-insn "$b" | awk '/<kernel>:/,/^$/' | grep -c '^ ' | sed "s|^|$b kernel_instructions |"; done > bin/sizes.txt
ls bin
{ uname -a; clang --version | head -1; cat /sys/devices/system/cpu/cpu2/cpufreq/scaling_governor /sys/devices/system/cpu/cpu2/cpufreq/energy_performance_preference; cat */COMMIT; sha256sum */build/compiler bin/*; } > bin/host.txt 2>&1

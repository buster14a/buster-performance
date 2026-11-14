#!/bin/bash
# #1373: the kernels' objects by each tree's compiler (Tier 0 `-c` and Tier 1 `--tier1 -c`, the default x86-64 target)
# and by clang -O0 and -O2, each linked with one clang -O2 driver object and -lm; one lock hold.
set -eu
cd ~/buster-fast-bench/1373-claude
mkdir -p bin
clang -O2 -c scripts/drv.c -o bin/drv.o
for tree in base head; do
    compiler=$(ls -d $tree-*/build/compiler)
    "$compiler" -c scripts/kern.c -o bin/k-$tree-t0.o
    "$compiler" --tier1 -c scripts/kern.c -o bin/k-$tree-t1.o
    clang bin/k-$tree-t0.o bin/drv.o -lm -o bin/$tree-t0
    clang bin/k-$tree-t1.o bin/drv.o -lm -o bin/$tree-t1
done
clang -O0 -c scripts/kern.c -o bin/k-clang-O0.o
clang -O2 -c scripts/kern.c -o bin/k-clang-O2.o
clang bin/k-clang-O0.o bin/drv.o -lm -o bin/clang-O0
clang bin/k-clang-O2.o bin/drv.o -lm -o bin/clang-O2
for o in bin/k-*.o; do
    for f in copies load32 moves absolutes signs sum_abs sum_labs sum_fabs; do
        printf '%s\t%s\t%s\t%s\n' "$o" "$f" "$(objdump -d --no-show-raw-insn "$o" | awk -v f="<$f>:" '$2 == f {p = 1; next} /^$/ {p = 0} p && /^ / && !/int3|nop/' | wc -l)" \
            "$(objdump -dr "$o" | awk -v f="<$f>:" '$2 == f {p = 1; next} /^$/ {p = 0} p && /R_X86_64_PLT32/ {print $3}' | tr '\n' ' ')"
    done
done > bin/instructions.tsv
ls bin
{ uname -a; clang --version | head -1; cat /sys/devices/system/cpu/cpu2/cpufreq/scaling_governor /sys/devices/system/cpu/cpu2/cpufreq/energy_performance_preference; cat */COMMIT; sha256sum */build/compiler bin/*; } > bin/host.txt 2>&1

#!/bin/bash
# #1373 leftovers: the kernels' objects by each tree's compiler (Tier 0 `-c` and Tier 1 `--tier1 -c`) at the default
# x86-64 target and at -march=znver5, and by clang -O0 and -O2 at both, each linked with one clang -O2 driver object;
# run under one lock hold.
set -eu
cd ~/buster-fast-bench/1373-claude-move
mkdir -p bin
clang -O2 -c scripts/drv.c -o bin/drv.o
for tree in $TREES; do
    for march in x86-64 znver5; do
        $tree/build/compiler -march=$march -c scripts/kern.c -o bin/k-$tree-t0-$march.o
        $tree/build/compiler --tier1 -march=$march -c scripts/kern.c -o bin/k-$tree-t1-$march.o
        clang bin/k-$tree-t0-$march.o bin/drv.o -o bin/$tree-t0-$march
        clang bin/k-$tree-t1-$march.o bin/drv.o -o bin/$tree-t1-$march
    done
done
for march in x86-64 znver5; do
    for o in O0 O2; do
        clang -$o -march=$march -c scripts/kern.c -o bin/k-clang-$o-$march.o
        clang bin/k-clang-$o-$march.o bin/drv.o -o bin/clang-$o-$march
    done
done
for o in bin/k-*.o; do
    for f in loop_move40 loop_move64 loop_move128 loop_far64 loop_far128 sum_copysign sum_copysignf; do
        printf '%s\t%s\t%s\t%s\n' "$o" "$f" "$(objdump -d --no-show-raw-insn "$o" | awk -v f="<$f>:" '$2 == f {p = 1; next} /^$/ {p = 0} p && /^ / && !/int3|nop/' | wc -l)" \
            "$(objdump -dr "$o" | awk -v f="<$f>:" '$2 == f {p = 1; next} /^$/ {p = 0} p && /R_X86_64_PLT32/ {print $3}' | tr '\n' ' ')"
    done
done > results/instructions.tsv
for b in bin/*-x86-64 bin/*-znver5; do printf '%s\t%s\n' "$b" "$(timeout -k 5 120 $b)"; done > results/check.txt
{ uname -a; clang --version | head -1; cat /sys/devices/system/cpu/cpu2/cpufreq/scaling_governor /sys/devices/system/cpu/cpu2/cpufreq/energy_performance_preference; sha256sum */build/compiler bin/*; } > results/host.txt 2>&1

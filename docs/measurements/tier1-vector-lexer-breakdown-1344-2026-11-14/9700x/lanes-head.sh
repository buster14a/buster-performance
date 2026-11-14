#!/usr/bin/env bash
# Does main's Tier 1 object of the lexer depend on the CPUs the compiler may run on? Counts tokenize_c's memmove relocations.
D=$HOME/buster-fast-bench/1344-claude
cd $D/head || exit 1
for cpus in 0 0-3 0-7 0-15; do
    taskset -c $cpus ./build/compiler --tier1 -fno-asynchronous-unwind-tables -march=native -Isrc -fwrapv -funsigned-char -fno-strict-aliasing -c -o $D/lanes-head-$cpus.o src/buster/compiler/c_lexer_benchmark.c 2>/dev/null
    echo "cpus $cpus: status $? memmove relocations $(objdump -dr $D/lanes-head-$cpus.o | grep -c 'R_X86_64_PLT32.*memmove') sha $(sha256sum < $D/lanes-head-$cpus.o | cut -c1-12)"
done

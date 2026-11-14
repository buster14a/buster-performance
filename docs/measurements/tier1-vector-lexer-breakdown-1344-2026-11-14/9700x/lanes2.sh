#!/usr/bin/env bash
# The regression check's commands by main's compiler and by the branch's: the lexer's unit by --tier1 on one lane and on four.
D=$HOME/buster-fast-bench/1344-claude
for side in base head; do
    cd $D/$side || exit 1
    for lanes in 1 4; do
        ./build/compiler --tier1 --lanes $lanes -fno-asynchronous-unwind-tables -march=znver5 -Isrc -fwrapv -funsigned-char -fno-strict-aliasing -c -o $D/check-$side-$lanes.o src/buster/compiler/c_lexer_benchmark.c 2>/dev/null
        echo "$side --lanes $lanes: status $? sha $(sha256sum < $D/check-$side-$lanes.o | cut -c1-12) memmove $(objdump -dr $D/check-$side-$lanes.o | grep -c 'R_X86_64_PLT32.*memmove')"
    done
    cmp $D/check-$side-1.o $D/check-$side-4.o > /dev/null && echo "$side: same object" || echo "$side: objects DIFFER"
done

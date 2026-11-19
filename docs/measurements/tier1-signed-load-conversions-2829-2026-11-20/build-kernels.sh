#!/usr/bin/env bash
set -eu
cd "$(dirname "$0")"
base=$(realpath "$1")
head=$(realpath "$2")
cc=${CC:-clang}
mkdir -p programs
"$cc" -O2 -march=x86-64 -Wall -Wextra -c kernels/harness.c -o programs/driver.o
for arch in x86-64 znver5; do
    for mode in default unroll; do
        options=(--tier1 -O2 --lanes 1 -march="$arch")
        if [[ $mode == unroll ]]; then options+=(--tier1-passes=+unroll); fi
        for v in base head; do
            compiler=$base
            if [[ $v == head ]]; then compiler=$head; fi
            "$compiler" "${options[@]}" -c kernels/kernels.c -o "programs/$v-$arch-$mode.o"
            for pad in 0 16 32 48; do
                printf '.text\n.balign 64\n.space %s, 0x90\n.section .note.GNU-stack,"",@progbits\n' "$pad" | "$cc" -x assembler -c - -o programs/pad.o
                "$cc" -no-pie programs/driver.o programs/pad.o "programs/$v-$arch-$mode.o" -lm -o "programs/$v-$arch-$mode-p$pad"
            done
        done
    done
    "$cc" -O0 -march="$arch" -c kernels/kernels.c -o programs/clang-O0-$arch.o
    "$cc" -O2 -fno-vectorize -fno-slp-vectorize -march="$arch" -c kernels/kernels.c -o programs/clang-scalar-$arch.o
    for v in clang-O0 clang-scalar; do "$cc" -no-pie programs/driver.o "programs/$v-$arch.o" -lm -o "programs/$v-$arch"; done
done

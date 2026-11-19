#!/usr/bin/env bash
set -euo pipefail
base=$(realpath "$1")
head=$(realpath "$2")
cd "$(dirname "$0")"
mkdir -p programs
cc=${CC:-clang}
for scale in 2 4 8; do
    "$cc" -O2 -DSCALE="$scale" -c driver.c -o "programs/driver-$scale.o"
    "$cc" -O2 -march=znver5 -DSCALE="$scale" driver.c recurrence.c -o "programs/oracle-$scale"
    for variant in base head; do
        compiler=$base
        if [[ $variant == head ]]; then compiler=$head; fi
        "$compiler" --tier1 --tier1-strict --verify -O2 -march=znver5 -DSCALE="$scale" -c recurrence.c -o "programs/$variant-$scale.o"
        for pad in 0 16 32 48; do
            printf '.text\n.balign 64\n.space %s, 0x90\n.section .note.GNU-stack,"",@progbits\n' "$pad" | "$cc" -x assembler -c - -o programs/pad.o
            "$cc" -no-pie "programs/driver-$scale.o" programs/pad.o "programs/$variant-$scale.o" -o "programs/$variant-$scale-p$pad"
            nm -S "programs/$variant-$scale-p$pad" | awk -v label="$variant-$scale-p$pad" '$4=="kernel"{print label,$1,$2}'
        done
    done
done

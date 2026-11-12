#!/bin/bash
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md.
#
# stages.sh: one --time-stages compile of every unit size on CPU 2 (three each, the
# last kept), for the token counts and the stage split; inside one hold of the lock.
set -u
cd "$(dirname "$0")"
mkdir -p results/stages out
status=0
for copies in 0 1 4 16 64 350; do
    for r in 1 2 3; do
        taskset -c 2 src/build/compiler --predefines predefines-znver5.h -march=znver5 -fwrapv -funsigned-char -c --lanes 1 \
            --time-stages -o "out/stages-u$copies.o" "units/u$copies.c" > "results/stages/u$copies.txt" 2>&1 || status=1
    done
done
exit $status

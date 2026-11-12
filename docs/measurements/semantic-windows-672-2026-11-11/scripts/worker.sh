#!/bin/bash
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md.
#
# worker.sh COPIES LOOPS ID: compiles units/uCOPIES.c to an object LOOPS times in a row
# (-c --lanes 1, a fresh process each time), into out/ID-uCOPIES.o; stops at the first
# failed compile with its status.
set -u
copies=$1 loops=$2 id=$3
for ((i = 0; i < loops; i += 1)); do
    src/build/compiler --predefines predefines-znver5.h -march=znver5 -fwrapv -funsigned-char -c --lanes 1 \
        -o "out/$id-u$copies.o" "units/u$copies.c" || exit 1
done

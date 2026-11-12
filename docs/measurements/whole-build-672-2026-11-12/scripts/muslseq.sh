#!/bin/bash
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md of buster14a/buster.
#
# muslseq.sh DIRECTORY LANES [-g]: musl's library and its program as one build: the library's two commands (lists a and
# b, prepare.sh's), then link-foreign's link of every object with the start file, the program and libgcc, in DIRECTORY.
. "$(dirname "$0")/common.sh"
d=$1
lanes=$2
g=${3:-}
linklanes=""
if [[ $lanes == 1 ]]; then linklanes="--lanes 1"; fi
cd "$d/a" && "$c" $mo --lanes $lanes -c $g @$t/lists/lib-a.txt > /dev/null 2>&1 &&
    cd "$d/b" && "$c" $mo --lanes $lanes -c $g @$t/lists/lib-b.txt > /dev/null 2>&1 &&
    cd "$d" && "$c" link-foreign $linklanes -static -o hello-q crt1.o hello.o missing.o $(cat objects.txt) $G/libgcc.a

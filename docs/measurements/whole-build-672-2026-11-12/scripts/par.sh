#!/bin/bash
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md of buster14a/buster.
#
# par.sh COMPILER KIND [-g]: the shell's two compiles at once, as make -j runs a build's independent steps, then the
# link of their objects, in the current directory. COMPILER is `buster` (the link by the driver) or `clang` (-O0, the
# link by lld through clang's driver); KIND is `dyn` or `static`.
. "$(dirname "$0")/common.sh"
compiler=$1
kind=$2
g=${3:-}
flag=""
if [[ $kind == static ]]; then flag=-static; fi
if [[ $compiler == buster ]]; then
    "$c" -c $g $sh "$sqlite/shell.c" -o p-shell$g.o &
    first=$!
    "$c" -c $g $sh "$sqlite/sqlite3.c" -o p-sq$g.o &
    second=$!
    wait $first && wait $second && "$c" $flag $g p-shell$g.o p-sq$g.o -lm -o p-$kind$g
else
    /usr/bin/clang -O0 -c $g $sh "$sqlite/shell.c" -o pk-shell$g.o &
    first=$!
    /usr/bin/clang -O0 -c $g $sh "$sqlite/sqlite3.c" -o pk-sq$g.o &
    second=$!
    wait $first && wait $second && /usr/bin/clang -fuse-ld=lld $flag $g pk-shell$g.o pk-sq$g.o -lm -o pk-$kind$g
fi

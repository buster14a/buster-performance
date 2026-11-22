#!/bin/bash
# inputs.sh: #3261's link inputs under ~/buster-fast-bench/3044-claude/inputs, made with main's Release executable
# (run under the 9700X's lock): every benchmark-foreign-strings shape at 4,096 and 131,072 literals (--keep), and
# tools/ci/build_regression.c compiled by the 9700X's clang 23.1.4 at -O2 (br.o), linked as clang links it.
set -eu
D=~/buster-fast-bench/3044-claude
C=$(ls -d ~/.cache/buster/benchpress-clang/*/bin | head -1)
mkdir -p $D/inputs/bench
cd $D/inputs
$C/clang --version | head -1
$C/clang -O2 -c -o br.o $D/main/tools/ci/build_regression.c
$C/clang -### br.o -o br 2>&1 | tail -1 > br.ld
taskset -c 2 $D/main/build/compiler benchmark-foreign-strings --keep --runs 1 --counts 4096,131072 --directory $D/inputs/bench | tail -20

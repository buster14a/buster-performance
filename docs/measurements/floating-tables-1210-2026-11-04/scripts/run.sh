#!/bin/sh
# The commands behind raw/, run on benchpress from ~/buster-fast-bench/652-658-claude, where base-1210 and head-1210
# are `git worktree`s of the two revisions in README.md, each built with
#   BUSTER_HOST_ARCH=znver5 BUSTER_DEBUG_INFO=0 ~/buster-fast-bench/exclusive.sh ./build.sh
# The inputs, made by scripts/gen.c (clang -O2 -o gen gen.c) in inputs/:
#   ./gen float 200000 f > float_f_200000.c     # float, every value spelled with an f suffix (exact in float)
#   ./gen float 200000 x > float_x_200000.c     # float, double literals of v/3, which round to float
#   ./gen double 200000 x > double_x_200000.c   # double, the same literals
#   sed '$ s/};/16777217};/' float_x_200000.c > float_fallback_200000.c   # a last element that refuses the table
B=$PWD/base-1210/build/cmake/znver5-g0/Release/compiler
H=$PWD/head-1210/build/cmake/znver5-g0/Release/compiler
cd inputs
~/buster-fast-bench/exclusive.sh taskset -c 2 $H time-runs --runs 15 --warmups 2 --copies 3 \
    --build main $B --build head $H --build main-again $B \
    --list -fsyntax-only float_f_200000.c --list -fsyntax-only float_x_200000.c --list -fsyntax-only double_x_200000.c \
    --list -fsyntax-only float_fallback_200000.c --list -c float_x_200000.c -o /dev/null > ../ab-1210-large.txt 2>&1

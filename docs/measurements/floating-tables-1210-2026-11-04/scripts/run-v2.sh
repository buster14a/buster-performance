#!/bin/sh
# The commands behind raw/ab-1210-v2-*.txt (head3-1210, f754e1a8) and raw/ab-1210-v3-*.txt (head4-1210, 65f678d9), run
# on benchpress from ~/buster-fast-bench/652-658-claude; each head is a `git worktree` built with
#   BUSTER_HOST_ARCH=znver5 BUSTER_DEBUG_INFO=0 ~/buster-fast-bench/exclusive.sh ./build.sh
# The inputs, made in inputs/ by scripts/gen2.c (clang -O2 -o gen2 gen2.c):
#   for n in 128 4096 200000; do
#       for st in f x s l m; do ./gen2 float $n $st > t_float_${st}_$n.c; done
#       ./gen2 double $n x > t_double_x_$n.c
#       ./gen2 float $n l | sed '$ s/};/16777217};/' > t_float_fallback_$n.c
#   done
HEAD=${1:-head4-1210}
OUT=${2:-v3}
B=$PWD/base-1210/build/cmake/znver5-g0/Release/compiler
H=$PWD/$HEAD/build/cmake/znver5-g0/Release/compiler
cd inputs
L=""
for st in float_f float_x float_s float_l float_m double_x float_fallback; do L="$L --list -fsyntax-only t_${st}_200000.c"; done
~/buster-fast-bench/exclusive.sh taskset -c 2 $H time-runs --runs 15 --warmups 2 --copies 3 \
    --build main $B --build head $H --build main-again $B $L > ../ab-1210-$OUT-large.txt 2>&1
L=""
for n in 128 4096; do for st in float_f float_x float_s float_l float_m double_x float_fallback; do L="$L --list -fsyntax-only t_${st}_$n.c"; done; done
~/buster-fast-bench/exclusive.sh taskset -c 2 $H time-runs --runs 60 --warmups 5 --copies 3 \
    --build main $B --build head $H --build main-again $B $L > ../ab-1210-$OUT-small.txt 2>&1

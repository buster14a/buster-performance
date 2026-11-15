#!/bin/bash
# prof3.sh: main.c's --selection-census -c by BASE and HEAD on CPU 2, six runs each under perf record of user cycles
# (period 50,021 + 2 a run), into out/prof/SIDE.N.data.
set -u
cd ~/buster-fast-bench/2536-step2c3p3-claude
mkdir -p out/prof
cd head
for r in 1 2 3 4 5 6; do
    for side in base head; do
        perf record -q -e cycles:u -c $((50021 + 2 * r)) -o ../out/prof/$side.$r.data taskset -c 2 ../compiler-$side --selection-census --lanes 1 -march=native -Isrc -fwrapv -funsigned-char -c src/buster/compiler/main.c -o /dev/shm/c2c3p3.o 2> /dev/null < /dev/null
    done
done
rm -f /dev/shm/c2c3p3.o

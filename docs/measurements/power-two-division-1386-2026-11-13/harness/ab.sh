#!/bin/bash
# The #1386 kernels' A/B: MAIN's and HEAD's compilers build kernels.c at Tier 0 and Tier 1, clang at -O0 and -O2
# (no vectorizers), each linked with the same clang -O2 driver (one lock hold); then each round, a hold of its own, runs
# each binary once per kernel, interleaved, pinned to CPU 2 (ms for 20,000 calls over 4,096 elements). The table keeps
# each binary's best, median and worst of ROUNDS. Usage: ab.sh MAIN_COMPILER HEAD_COMPILER [ROUNDS]
set -e
dir=$(cd "$(dirname "$0")" && pwd)
main=$1
head=$2
rounds=${3:-11}
cd "$dir"
kernels="udiv umod index sdiv smod ldiv pdiff bytes conv dconv"
variants="m0 h0 m1 h1 c0 c2"
./lock.sh build bash -c '
    set -e
    clang -O2 -c -o driver.o driver.c
    "$1" -c -o m0.o kernels.c
    "$1" -c --tier1 -o m1.o kernels.c
    "$2" -c -o h0.o kernels.c
    "$2" -c --tier1 -o h1.o kernels.c
    clang -O0 -c -o c0.o kernels.c
    clang -O2 -fno-vectorize -fno-slp-vectorize -c -o c2.o kernels.c
    for v in m0 h0 m1 h1 c0 c2; do clang -o $v driver.o $v.o; done' _ "$main" "$head"
for r in $(seq 1 $rounds); do
    ./lock.sh round-$r bash -c '
        for k in '"$kernels"'; do
            for v in '"$variants"'; do
                printf "run %s %s %s %s\n" "$1" $k $v "$(taskset -c 2 ./$v $k | awk -v k=$k "\$1==k{print \$2}")"
            done
        done' _ $r
done > runs.txt
echo "kernel $(for v in $variants; do printf '%s(best/median/worst) ' $v; done)"
python3 -c '
import sys, statistics
d = {}
for line in open("runs.txt"):
    p = line.split()
    d.setdefault((p[2], p[3]), []).append(float(p[4]))
for k in sys.argv[1].split():
    print(k, " ".join("%.1f/%.1f/%.1f" % (min(d[(k, v)]), statistics.median(d[(k, v)]), max(d[(k, v)])) for v in sys.argv[2].split()))
' "$kernels" "$variants"
for v in $variants; do echo "$v $(./$v | tail -1)"; done
sha256sum "$main" "$head" m0.o h0.o m1.o h1.o c0.o c2.o driver.o kernels.c driver.c

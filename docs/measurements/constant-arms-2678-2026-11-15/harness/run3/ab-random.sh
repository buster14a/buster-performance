#!/bin/bash
# The kernels' A/B again with driver-random.c: the same four kernels over 256 windows of 1 Mi elements in a pseudo-random
# order, so that each branch's outcome is a coin's, one window a call. ab.sh's objects (m0, h0, m1, h1, c0, c2), each linked with the random driver (one
# lock hold); then ROUNDS rounds, each a hold of its own, every binary once per kernel, interleaved, pinned to CPU 2.
# Usage: ab-random.sh [ROUNDS]
set -e
dir=$(cd "$(dirname "$0")" && pwd)
rounds=${1:-11}
cd "$dir"
kernels="both one logic dboth"
variants="m0 h0 m1 h1 c0 c2"
./lock.sh build-random bash -c '
    set -e
    clang -O2 -c -o driver-random.o driver-random.c
    for v in m0 h0 m1 h1 c0 c2; do clang -o r$v driver-random.o $v.o; done
    sha256sum driver-random.c driver-random.o m0.o h0.o m1.o h1.o c0.o c2.o'
for r in $(seq 1 $rounds); do
    ./lock.sh random-$r bash -c '
        for k in '"$kernels"'; do
            for v in '"$variants"'; do
                printf "run %s %s %s %s\n" "$1" $k $v "$(taskset -c 2 ./r$v $k | awk -v k=$k "\$1==k{print \$2}")"
            done
        done' _ $r
done > runs-random.txt
echo "kernel $(for v in $variants; do printf '%s(best/median/worst) ' $v; done)"
python3 -c '
import sys, statistics
d = {}
for line in open("runs-random.txt"):
    p = line.split()
    d.setdefault((p[2], p[3]), []).append(float(p[4]))
for k in sys.argv[1].split():
    print(k, " ".join("%.1f/%.1f/%.1f" % (min(d[(k, v)]), statistics.median(d[(k, v)]), max(d[(k, v)])) for v in sys.argv[2].split()))
' "$kernels" "$variants"
./lock.sh checksums-random bash -c 'for v in '"$variants"'; do echo "$v $(taskset -c 2 ./r$v | tail -1)"; done'

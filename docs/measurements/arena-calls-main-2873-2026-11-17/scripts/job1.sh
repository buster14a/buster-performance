#!/bin/bash
# job1.sh: main, and the piece as its patches apply on it (p2a.patch) built as the benchmark builds are, then the start
# order's inputs and list from that build (order.sh), in results/order. A hold of the lock a build and a trace.
cd "$(dirname "$0")"
main=c7caeb56b25c674dfe313edb28ee9ac8d728efe6
: > job1.done
./build-tree.sh main $main > build-main.out 2>&1
HOST_ARCH=znver5 DEBUG_INFO=0 ./build-tree.sh order0 $main p2a.patch > build-order0.out 2>&1
rm -rf results/order
for what in small sqlite "musl 0 2000" list; do
    ./lock.sh timeout -k 5 600 ./order.sh order0 results/order $what; echo "$what $?" >> build-order0.out
done
echo finished > job1.done

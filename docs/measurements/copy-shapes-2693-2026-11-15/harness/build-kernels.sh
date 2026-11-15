#!/bin/bash
# build-kernels.sh COMPILER TAG: #1375's assign and cold kernels (buster-performance e8c1b78f) by buster's Tier 0 and
# Tier 1 (and once by clang -O0), each linked with its clang -O2 driver. N longs: 5 (40 bytes, an overlapping last
# piece), 6 (48), 8 (64), 16 (128), 32 (256), and 4 (32, the largest copy in 8-byte pieces, which #2693 keeps).
set -euo pipefail
B=$1; T=$2; mkdir -p bin
build() # NAME KERNEL DRIVER DEFINES...
{
    local name=$1 kernel=$2 driver=$3; shift 3
    clang -O2 "$@" -c -o bin/d.$name.o $driver
    "$B" -c -O0 "$@" -o bin/$name.$T.t0.o $kernel
    "$B" -c -O0 --tier1 "$@" -o bin/$name.$T.t1.o $kernel
    clang -O2 -o bin/$name.$T.t0 bin/d.$name.o bin/$name.$T.t0.o
    clang -O2 -o bin/$name.$T.t1 bin/d.$name.o bin/$name.$T.t1.o
    if [ ! -e bin/$name.clang ]; then clang -O0 "$@" -c -o bin/$name.clang.o $kernel; clang -O2 -o bin/$name.clang bin/d.$name.o bin/$name.clang.o; fi
}
for n in 4 5 6 8 16 32; do build assign$n kassign.c dassign.c -DN=$n; build cold$n kcold.c dcold.c -DN=$n; done

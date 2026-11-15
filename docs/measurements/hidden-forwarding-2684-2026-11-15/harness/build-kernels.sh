#!/bin/bash
# build-kernels.sh COMPILER TAG: each kernel by buster's Tier 0 and Tier 1 (and once by clang -O0), linked with its clang -O2 driver.
set -euo pipefail
B=$1; T=$2; mkdir -p bin
build() # NAME KERNEL CALLS DEFINES...
{
    local name=$1 kernel=$2 calls=$3; shift 3
    clang -O2 -DCALLS=$calls -c -o bin/d.$name.o driver.c
    "$B" -c -O0 "$@" -o bin/$name.$T.t0.o $kernel
    "$B" -c -O0 --tier1 "$@" -o bin/$name.$T.t1.o $kernel
    clang -O2 -o bin/$name.$T.t0 bin/d.$name.o bin/$name.$T.t0.o
    clang -O2 -o bin/$name.$T.t1 bin/d.$name.o bin/$name.$T.t1.o
    if [ ! -e bin/$name.clang ]; then clang -O0 "$@" -c -o bin/$name.clang.o $kernel; clang -O2 -o bin/$name.clang bin/d.$name.o bin/$name.clang.o; fi
}
build forward3 kforward.c 50000000 -DN=3
build forward8 kforward.c 20000000 -DN=8
build forward64 kforward.c 5000000 -DN=64
build named8 knamed.c 20000000 -DN=8
build named64 knamed.c 5000000 -DN=64

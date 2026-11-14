#!/usr/bin/env bash
# build-all.sh BUSTER MARCH: build the kernels' unit by every configuration, each linked with the same clang -O2 harness.
set -u
BUSTER=$1
MARCH=$2
cd "$(dirname "$0")"
mkdir -p out/$MARCH
clang -O2 -Wall -Wextra -c src/harness.c -o out/$MARCH/harness.o || exit 1
build_one()
{
    name=$1
    shift
    if "$@" -c src/kernels.c -o out/$MARCH/k-$name.o 2> out/$MARCH/k-$name.log; then
        clang out/$MARCH/harness.o out/$MARCH/k-$name.o -o out/$MARCH/h-$name -lm || echo "LINK FAILED $name"
    else
        echo "COMPILE FAILED $name: $(head -3 out/$MARCH/k-$name.log)"
    fi
}
build_one clang-O0 clang -O0 -march=$MARCH
build_one clang-O1 clang -O1 -march=$MARCH
build_one clang-O2-novec-nounroll clang -O2 -march=$MARCH -fno-vectorize -fno-slp-vectorize -fno-unroll-loops
build_one clang-O2-novec clang -O2 -march=$MARCH -fno-vectorize -fno-slp-vectorize
build_one clang-O2 clang -O2 -march=$MARCH
build_one clang-O3 clang -O3 -march=$MARCH
build_one gcc-O2 gcc -O2 -march=$MARCH
build_one gcc-O3 gcc -O3 -march=$MARCH
build_one buster-tier0 "$BUSTER" -O2 -march=$MARCH
build_one buster-tier1 "$BUSTER" --tier1 -O2 -march=$MARCH
build_one buster-tier1-licm "$BUSTER" --tier1 --tier1-passes=+licm -O2 -march=$MARCH
build_one buster-tier1-all "$BUSTER" --tier1 --tier1-passes=+all -O2 -march=$MARCH
ls out/$MARCH | grep -c '^h-'

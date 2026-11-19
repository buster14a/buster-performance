#!/usr/bin/env bash
set -euo pipefail

record=$(cd -- "$(dirname -- "$0")" && pwd)
scratch=$(mktemp -d)
trap 'rm -rf -- "$scratch"' EXIT
base=6427879e1143026a12fb0388a20bdea1fe4b2bc5
head=6a92df5fb1b9159ead7b79a4bcde89a175a26c7f
git init -q "$scratch/buster"
cd "$scratch/buster"
git remote add origin https://github.com/buster14a/buster.git
git fetch --no-tags --depth=1 origin "$base" "$head"
git switch --detach "$base"
lscpu | grep 'Model name'
cc -O2 -march=x86-64-v4 -maes -mgfni -mvaes -mavx512vbmi -mavx512vbmi2 -mavx512vpopcntdq -mavx512bitalg -mavx512vnni tools/ci/vector-probe.c -o "$scratch/probe"
"$scratch/probe"
dirs=$(bash tools/ci/session-toolchain.sh stage)
export PATH="$dirs:$PATH"
export BUSTER_HOST_ARCH=vector BUSTER_DEBUG_INFO=0
clang --version
cmake --version
ninja --version
git show HEAD:src/buster/compiler/ir_optimize_unroll.c > "$scratch/input.bin"
sha256sum "$scratch/input.bin" "$record/countdown.c"
clang -std=c17 -O2 -march=x86-64 -Dreverse_sum=clang_reverse_sum -c "$record/countdown.c" -o "$scratch/oracle.o"
clang -std=c17 -O2 -march=x86-64 -Wall -Wextra -Werror -c "$record/guard.c" -o "$scratch/guard.o"
for revision in base head; do
    if [[ "$revision" == head ]]; then git switch --detach "$head"; fi
    echo "REVISION $revision $(git rev-parse HEAD)"
    ./build.sh --config Release
    ./build/compiler --tier1 --tier1-passes=+unroll --tier1-strict --tier1-report --verify -march=x86-64 -c "$record/countdown.c" -o "$scratch/$revision.o"
    objdump -d -Mintel --no-show-raw-insn "$scratch/$revision.o"
    size -A "$scratch/$revision.o"
    clang -march=x86-64 "$scratch/guard.o" "$scratch/oracle.o" "$scratch/$revision.o" -o "$scratch/guard"
    timeout 20s "$scratch/guard" "$scratch/input.bin"
    bash "$record/schedule-check.sh"
    ./build/compiler --tier1 --tier1-strict --verify -march=x86-64 -c "$record/countdown.c" -o "$scratch/$revision-default.o"
    ./build/compiler test-ir-unroll
    if [[ "$revision" == head ]]; then ./build/compiler test-ir-optimize; fi
done
cmp "$scratch/base-default.o" "$scratch/head-default.o"
sha256sum "$scratch/base-default.o" "$scratch/head-default.o"

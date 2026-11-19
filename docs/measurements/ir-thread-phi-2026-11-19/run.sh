#!/usr/bin/env bash
set -euo pipefail
mkdir -p record
lscpu | grep -E 'Architecture|Model name|Hypervisor' | tee record/cpu.txt
git fetch --no-tags --depth=1 https://github.com/buster14a/buster.git 6af2ca0d196e49c2cd7f593b742dc31ef92660cd
git checkout --detach FETCH_HEAD
test "$(git rev-parse HEAD)" = 6af2ca0d196e49c2cd7f593b742dc31ef92660cd
git rev-parse HEAD | tee record/head.txt
git hash-object src/buster/compiler/ir_thread.c src/buster/compiler/ir_thread_test.c | tee record/blobs.txt
paths=$(bash tools/ci/session-toolchain.sh stage)
export PATH="$paths:$PATH" BUSTER_HOST_ARCH=native BUSTER_DEBUG_INFO=0
clang --version | tee record/clang.txt
./build.sh --config Develop >record/build.log 2>&1 || { tail -80 record/build.log; exit 1; }
./build/compiler test-ir-optimize 2>&1 | tee record/test.log

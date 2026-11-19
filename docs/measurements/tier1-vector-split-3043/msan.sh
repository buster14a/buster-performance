#!/usr/bin/env bash
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Run in a disposable buster checkout at the named base on a qualifying hosted CPU.
set -euo pipefail
base=6427879e1143026a12fb0388a20bdea1fe4b2bc5
head=5b855db18a58979a2401234a68d3816a6fdaf73f
test "$(git rev-parse HEAD)" = "$base"
git fetch -q --depth 1 origin "$head"
work=$(mktemp -d)
export BUSTER_HOST_ARCH=vector BUSTER_DEBUG_INFO=0 BUSTER_SANITIZER=memory BUSTER_SANITIZER_OPTIMIZATION=3
stage=$(bash tools/ci/session-toolchain.sh stage)
export PATH="$stage:$PATH"
clang --version | head -1
GITHUB_ENV="$work/policy" bash tools/ci/sanitizers.sh configure "$work/reports"
while IFS= read -r setting; do export "$setting"; done < "$work/policy"
bash tools/ci/sanitizers.sh probe "$work/canary"
for rev in "$base" "$head"; do
    echo "MSAN $rev"
    git restore --source="$rev" -- src/buster/compiler/ir_vector_split.c src/buster/compiler/tier1_wide_vectors_test.c
    ./build.sh --config Release > "$work/build.log" 2>&1 || { tail -80 "$work/build.log"; exit 1; }
    sha256sum build/compiler
    status=0
    ./build/compiler test-tier1-wide || status=$?
    bash tools/ci/sanitizers.sh audit "$work/reports"
    test "$status" = 0
done

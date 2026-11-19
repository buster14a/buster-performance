#!/usr/bin/env bash
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Copyright (c) 2026 David Gonzalez Martin. See the repository licensing notices.
set -euo pipefail
record=$(cd "$(dirname "$0")" && pwd)
repo=$(git -C "${1:-.}" rev-parse --show-toplevel)
base=6427879e1143026a12fb0388a20bdea1fe4b2bc5
head=$(cat "$record/head.txt")
export RUNNER_TEMP
RUNNER_TEMP=$(mktemp -d "${TMPDIR:-/tmp}/buster-interpreter-link-3032.XXXXXXXX")
printf 'Comparison workspace: %s\n' "$RUNNER_TEMP"
git clone --quiet --shared --no-checkout -- "$repo" "$RUNNER_TEMP/source"
cd "$RUNNER_TEMP/source"
for revision in "$base" "$head"; do
    if ! git cat-file -e "$revision^{commit}" 2>/dev/null; then
        git fetch --no-tags https://github.com/buster14a/buster.git "$revision"
    fi
done
git checkout -q --detach "$base"
owner=src/buster/compiler/interpreter_link.c
tests=src/buster/compiler/interpreter_link_test.c
export BUSTER_HOST_ARCH=vector BUSTER_DEBUG_INFO=0
cc -O2 -march=x86-64-v4 -maes -mgfni -mvaes -mavx512vbmi -mavx512vbmi2 -mavx512vpopcntdq -mavx512bitalg -mavx512vnni tools/ci/vector-probe.c -o "$RUNNER_TEMP/isa"
"$RUNNER_TEMP/isa"
tool_dirs=$(bash tools/ci/session-toolchain.sh stage)
export PATH="$tool_dirs:$PATH" CC=clang
clang --version
cmake --version | head -1
ninja --version
for mode in base head; do
    revision=$base
    if [[ $mode == head ]]; then revision=$head; fi
    git show "$revision:$owner" > "$owner"
    git show "$head:$tests" > "$tests"
    cp "$record/observe.c" src/buster/compiler/probe3032-observe.c
    cp "$record/stress.c" src/buster/compiler/probe3032-stress.c
    git apply "$record/$mode-counters.diff"
    ./build.sh --config Release
    bash "$record/run.sh" "$RUNNER_TEMP/$mode"
done
for name in link units musl c8 c32 c128; do
    cmp "$RUNNER_TEMP/base/$name.out" "$RUNNER_TEMP/head/$name.out"
    cmp "$RUNNER_TEMP/base/$name.trace" "$RUNNER_TEMP/head/$name.trace"
done
for object in "$RUNNER_TEMP/base"/*.o; do
    cmp "$object" "$RUNNER_TEMP/head/${object##*/}"
done
git show "$head:$owner" > "$owner"
git show "$head:$tests" > "$tests"
./build.sh --config Release
./build/compiler test-interpreter-link
./build/compiler interpret-c tests/interpreter/units-main.c tests/interpreter/units-library.c
printf 'All comparison files are in %s\n' "$RUNNER_TEMP"

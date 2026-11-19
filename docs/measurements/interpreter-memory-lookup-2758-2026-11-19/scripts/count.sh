#!/usr/bin/env bash
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Run in a clean, disposable Buster checkout on a four-CPU hosted AVX-512 worker.
set -euo pipefail
scripts=$(cd -- "$(dirname -- "$0")" && pwd -P)
export BUSTER_HOST_ARCH=vector BUSTER_SANITIZER="${BUSTER_SAMPLE_SANITIZER:?choose memory or address}"
case "$BUSTER_SANITIZER" in memory|address) ;; *) exit 2 ;; esac
out="${RUNNER_TEMP:?set a temporary working directory}/lookup-probes-$BUSTER_SANITIZER"
mkdir -p "$out" build
git init -q --template= build/c-testsuite
git -C build/c-testsuite fetch -q --depth 1 https://github.com/c-testsuite/c-testsuite 5c7275656d751de0e68b2d340a95b5681858ed07
git -C build/c-testsuite checkout -q --detach FETCH_HEAD
for side in base head; do
    if [[ $side == head ]]; then
        git apply "$scripts/candidate.patch"
    fi
    git apply "$scripts/$side-probes.patch"
    ./build.sh --config Release --jobs 4
    build/compiler test-ssa-source --typed --tier1 --keep build/c-testsuite/tests/single-exec/00040.c | tee "$out/$side.log"
    work=$(sed -n 's/^test-ssa-source: files kept in //p' "$out/$side.log")
    cp "$work"/run-*-memory/lookup-probes.tsv "$out/$side.tsv"
    cat "$out/$side.tsv"
    git apply -R "$scripts/$side-probes.patch"
done

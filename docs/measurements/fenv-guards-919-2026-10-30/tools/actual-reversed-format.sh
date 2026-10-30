#!/usr/bin/env bash
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Genuine first-party producer protocol control, NOT performance evidence.
set -euo pipefail
stage=$HOME/buster-fast-bench/codex-pr919-20261030
out=$stage/results/protocol-control
mkdir -p "$out"
cd "$stage"
export LC_ALL=C SOURCE_DATE_EPOCH=1792454400
export PATH=/home/david/.cache/buster/benchpress-clang/efdd1dbd089b99bfcfcde7b8eb1236163f2e88df5a981cca4f783ec9cb5e0378/bin:/usr/bin:/bin
unset CPATH C_INCLUDE_PATH LIBRARY_PATH LD_LIBRARY_PATH
printf '%s  %s\n' 1b00eebec4ad080e601d257a56ba5c12b4b1a2957a7d3ebf965253057562818a base/compiler \
    baefd653b210689927b757655fc962768a09f07ae23e193aaed9cfcb8576da52 head/compiler \
    9b5a1ebb8931301dd6bc4be9f01ad28c1327bf2f01d879b69349cc403e7c7b9d controls/access-off.c > "$out/expected.sha256"
sha256sum --check "$out/expected.sha256" > "$out/before-input-check.txt"
command=(taskset -c 2 "$stage/head/compiler" time-runs --runs 21 --warmups 2 --copies 2 --directory "$out" --build head "$stage/head/compiler" --build base "$stage/base/compiler")
for index in 1 2 3; do command+=(--list -fsyntax-only -std=gnu17 -march=znver5 "$stage/controls/access-off.c"); done
printf '%s\0' "${command[@]}" > "$out/producer.argv0"
date -u +before_format_control_utc=%Y-%m-%dT%H:%M:%SZ > "$out/execution-receipt.txt"
"${command[@]}" > "$out/time-p2-s0.log" 2>&1
printf 'producer_exit_status=0\n' >> "$out/execution-receipt.txt"
sha256sum --check "$out/expected.sha256" > "$out/after-input-check.txt"
date -u +after_format_control_utc=%Y-%m-%dT%H:%M:%SZ >> "$out/execution-receipt.txt"
sha256sum "$out/time-p2-s0.log" > "$out/raw.sha256"

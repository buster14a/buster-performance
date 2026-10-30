#!/usr/bin/env bash
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Offline placement adapter only. The ENTIRE zero object must equal production.
set -euo pipefail
input=${1:?PREPROCESSED_INPUT_DIRECTORY}
clang=/home/david/.cache/buster/benchpress-clang/efdd1dbd089b99bfcfcde7b8eb1236163f2e88df5a981cca4f783ec9cb5e0378/bin/clang
printf '%s  %s\n' c336d48383874cffaab0dc4c5c359456d871f21380b746520dde5c7f4c125a67 "$clang" | sha256sum --check
cd "$input"
mapfile -d '' -t flags < flags.nul
sha256sum "$clang" main_unit_checker.c flags.nul "$(realpath "$0")" > before-codegen.sha256
printf '%s\0' "$clang" -S -x cpp-output main_unit_checker.c "${flags[@]}" -Wno-unused-command-line-argument -o checker8.s > codegen.argv0
date -u +before_codegen_utc=%Y-%m-%dT%H:%M:%SZ > execution-receipt.txt
"$clang" -S -x cpp-output main_unit_checker.c "${flags[@]}" -Wno-unused-command-line-argument -o checker8.s
date -u +after_codegen_utc=%Y-%m-%dT%H:%M:%SZ >> execution-receipt.txt
sha256sum --check before-codegen.sha256 > after-codegen-check.txt
sha256sum checker8.s > generated.sha256

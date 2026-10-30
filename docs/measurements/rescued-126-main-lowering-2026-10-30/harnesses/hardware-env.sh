#!/usr/bin/env bash
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Copyright (c) 2026 David Gonzalez Martin. See Buster's LICENSE and LICENSING.md.
# Source this file for the frozen 9700X acceptance; it changes only this process's environment.
toolchain=${BUSTER_TOOLCHAIN_ROOT:-/home/david/buster-fast-bench/codex-rescue-126/toolchain-stage/cache/buster/benchpress-clang/efdd1dbd089b99bfcfcde7b8eb1236163f2e88df5a981cca4f783ec9cb5e0378}
export PATH="$toolchain/bin:$PATH"
export LD_LIBRARY_PATH="$toolchain/lib"
export BUSTER_CLANG_RESOURCE_DIR="$toolchain/lib/clang/23"
export BUSTER_HOST_ARCH=znver5 BUSTER_DEBUG_INFO=0 BUSTER_SANITIZER=none BUSTER_FUZZ_AVAILABLE=0 BUSTER_LINKER=auto
export LC_ALL=C LC_NUMERIC=C SOURCE_DATE_EPOCH=1792454400
export EXCLUSIVE_OWNER=codex-rescue-126
export EXCLUSIVE_TITLE='Finish original Claude cloud issue 126'
export EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/129
unset CPATH C_INCLUDE_PATH BUSTER_ORACLE_CACHE BUSTER_HOST_RUNTIME BUSTER_FUZZ_ENTRY

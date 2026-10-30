#!/usr/bin/env bash
set -euo pipefail
variant=$1
root=/home/david/buster-fast-bench/codex-pr915-20261030
toolchain=/home/david/buster-fast-bench/codex-883-qualification-6a-b68/cache/buster/benchpress-clang/efdd1dbd089b99bfcfcde7b8eb1236163f2e88df5a981cca4f783ec9cb5e0378
cd "$root/$variant"
export PATH="$toolchain/bin:$PATH"
export BUSTER_HOST_ARCH=znver5 BUSTER_DEBUG_INFO=0 LC_ALL=C
clang --version
sha256sum "$toolchain/bin/clang" "$toolchain/LICENSE.TXT"
./build.sh shifts "$root/$variant/placements" main_unit_backend.c 0 64 128 192
sha256sum build/compiler placements/compiler-*

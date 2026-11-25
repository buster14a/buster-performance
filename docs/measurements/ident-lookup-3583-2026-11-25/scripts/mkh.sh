#!/bin/bash
# mkh.sh TREE NAME [EXTRA FLAGS...]: the harness (direct_main.c around TREE's c_direct.c) as bin/direct-NAME, znver5,
# CI's clang, the unit's Release flags.
set -euo pipefail
tree=$1; name=$2; shift 2
cd "$tree"
PATH="$(bash tools/ci/session-toolchain.sh stage):$PATH"
mapfile -d '' -t flags < <(BUSTER_HOST_ARCH=znver5 BUSTER_DEBUG_INFO=0 ./build.sh print-compile-flags --config Release)
clang "${flags[@]}" "$@" -g -static src/buster/compiler/c_direct.c /home/user/ceil/direct_main.c -o /home/user/ceil/bin/direct-$name -Wno-error

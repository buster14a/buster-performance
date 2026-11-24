#!/bin/bash
# harness.sh NAME...: bin/direct-NAME again from trees/NAME's c_direct.c and this directory's direct_main.c (the
# tree's own compile flags). Run under exclusive.sh.
set -euo pipefail
here=$HOME/buster-fast-bench/2850-direct-tx5wvj
for name in "$@"; do
    cd "$here/trees/$name"
    export BUSTER_HOST_ARCH=znver5 BUSTER_DEBUG_INFO=0
    PATH="$(bash tools/ci/session-toolchain.sh stage):$PATH"
    mapfile -d '' -t flags < <(./build.sh print-compile-flags --config Release)
    clang "${flags[@]}" -g -static src/buster/compiler/c_direct.c "$here/direct_main.c" -o "$here/bin/direct-$name" -Wno-error 2>&1 | grep -v 'no-pie' || true
    ls -la "$here/bin/direct-$name"
done

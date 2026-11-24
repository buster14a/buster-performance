#!/bin/bash
# build-tree.sh NAME: trees/NAME -> bin/compiler-NAME (the product, znver5 Release without debug information, as the
# 9700X job builds it) and bin/direct-NAME (direct_main.c around the tree's c_direct.c, the unit's own flags).
# Run under exclusive.sh.
set -euo pipefail
here=$HOME/buster-fast-bench/2850-direct-tx5wvj
name=$1
cd "$here/trees/$name"
export BUSTER_HOST_ARCH=znver5 BUSTER_DEBUG_INFO=0
./build.sh --config Release > "$here/results/build-$name.log" 2>&1
cp "$(./build.sh print-output --config Release)" "$here/bin/compiler-$name"
PATH="$(bash tools/ci/session-toolchain.sh stage):$PATH"
mapfile -d '' -t flags < <(./build.sh print-compile-flags --config Release)
clang "${flags[@]}" -g -static src/buster/compiler/c_direct.c "$here/direct_main.c" -o "$here/bin/direct-$name" -Wno-error
clang --version | head -1
ls -la "$here/bin/compiler-$name" "$here/bin/direct-$name"
tail -4 "$here/results/build-$name.log"

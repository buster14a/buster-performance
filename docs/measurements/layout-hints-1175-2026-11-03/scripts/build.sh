#!/usr/bin/env bash
# build.sh TREE OUTPUT WRAP: a znver5 build of the buster checkout TREE through the clang wrapper directory WRAP
# (wrap-relocs: the production PIE code linked with --emit-relocs; wrap-nopie: -fno-pie code, whose jump tables BOLT can
# follow in check_input_run too; wrap-coverage: clang source coverage), copied to OUTPUT.
set -euo pipefail
wrap="$(realpath "$3")"
cd "$1"
PATH="$wrap:$PATH" BUSTER_HOST_ARCH=znver5 ./build.sh
cp build/compiler "$2"

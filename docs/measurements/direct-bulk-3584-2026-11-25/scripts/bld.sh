#!/bin/bash
# bld.sh NAME: trees/NAME built as the 9700X job builds it (znver5 Release, no debug information), as bin/compiler-NAME.
set -euo pipefail
here=$HOME/buster-fast-bench/3584-direct-s6acj8
cd "$here/trees/$1"
export BUSTER_HOST_ARCH=znver5 BUSTER_DEBUG_INFO=0
./build.sh --config Release --jobs 8 > "$here/build-$1.log" 2>&1 || { tail -20 "$here/build-$1.log"; exit 1; }
cp "$(./build.sh print-output --config Release)" "$here/bin/compiler-$1"
ls -la "$here/bin/compiler-$1"

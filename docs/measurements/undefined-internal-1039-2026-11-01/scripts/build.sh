#!/bin/bash
# build.sh TREE: build TREE's compiler under the shared lock with the staged clang 23.1.4.
set -euo pipefail
tree=$1
export PATH=$HOME/.cache/buster/benchpress-clang/efdd1dbd089b99bfcfcde7b8eb1236163f2e88df5a981cca4f783ec9cb5e0378/bin:$PATH
export LD_LIBRARY_PATH=$HOME/.cache/buster/benchpress-clang/efdd1dbd089b99bfcfcde7b8eb1236163f2e88df5a981cca4f783ec9cb5e0378/lib
export TMPDIR=$HOME/buster-fast-bench/droid-zen5/tmp
mkdir -p "$TMPDIR"
cd "$tree"
EXCLUSIVE_OWNER=droid-zen5 EXCLUSIVE_TITLE="Droid: Zen 5 AVX-512 kernel optimization" EXCLUSIVE_LINK="https://github.com/buster14a/buster" \
  BUSTER_DEBUG_INFO=0 ~/buster-fast-bench/exclusive.sh ./build.sh

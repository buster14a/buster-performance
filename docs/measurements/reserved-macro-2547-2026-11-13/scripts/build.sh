#!/bin/bash
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md of buster14a/buster.
#
# build.sh TREE: the tree's Release build (./build.sh, -O3 -march=native, with debug information, as the whole-build
# record's), one hold of the lock (lock.sh ./build.sh TREE), and the executable's hash.
set -eu
cd "$(dirname "$0")"
. ./common.sh
tree=${1:?a tree}
mkdir -p "$here/results/build"
head -1 /var/lib/buster-9700x/owner >> "$here/results/build/holder.txt"
(cd "$root/$tree" && ./build.sh > "$here/results/build/$tree.log" 2>&1)
sha256sum "$root/$tree/build/compiler" | tee -a "$here/results/build/sha256.txt"

#!/bin/bash
# tests.sh TREE NAME: the foreign linker's blocks of tools/ci/correctness.tests (test-foreign --cross-check,
# test-foreign-corpus, test-link) through TREE's own build/compiler parallel, under the 9700X's lock (#3261).
set -u
D=~/buster-fast-bench/3044-claude
tree=$1; name=$2
cd $D/$tree
awk -v re='foreign|Link represent|link represent' -v ex='raw-string' -f $D/blocks.awk tools/ci/correctness.tests > $D/results/$name-blocks.txt
grep '^== ' $D/results/$name-blocks.txt
export PATH="$(bash tools/ci/session-toolchain.sh stage 2>/dev/null || true):$PATH"
which clang ld.lld mold gcc ld 2>&1 | head -5
clang --version | head -1
BUSTER_COMPILER=$D/$tree/build/compiler timeout -k 10 900 $D/$tree/build/compiler parallel --jobs 8 --timeout 800 < $D/results/$name-blocks.txt
echo "tests exit $?"

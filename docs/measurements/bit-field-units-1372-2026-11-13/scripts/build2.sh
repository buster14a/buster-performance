#!/bin/bash
# head2's Release build under one hold of the 9700X's lock, then its k_bits objects, which must be head's byte for byte.
set -euo pipefail
cd ~/buster-fast-bench/1372-claude
echo $$ > build2.pid
export EXCLUSIVE_OWNER=claude-1372 EXCLUSIVE_TITLE="Bit-field access units (#1372)" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/1372
(cd head2 && ~/buster-fast-bench/exclusive.sh timeout 900 env BUSTER_HOST_ARCH=znver5 BUSTER_DEBUG_INFO=0 ./build.sh --config Release --jobs 8)
~/buster-fast-bench/exclusive.sh timeout 120 bash -c 'head2/build/compiler -c k_bits.c -o out/k-head2-tier0.o && head2/build/compiler -c --tier1 k_bits.c -o out/k-head2-tier1.o &&
    cmp out/k-head-tier0.o out/k-head2-tier0.o && cmp out/k-head-tier1.o out/k-head2-tier1.o && echo "k_bits objects: head2 = head"'
echo built2

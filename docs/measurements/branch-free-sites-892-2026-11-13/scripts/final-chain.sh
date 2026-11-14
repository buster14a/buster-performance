#!/bin/bash
# final-chain.sh: head rebuilt from final.patch, its objects and LBR, then the placements at checker offsets 1040 and 2080.
set -u
base=~/buster-fast-bench/892-claude
cd "$base/head" && git checkout -q -- . && git apply "$base/final.patch" || exit 1
cd "$base"
./chain.sh head
./placements.sh "$base/final.patch" 1040 2080
echo done > final-chain.done

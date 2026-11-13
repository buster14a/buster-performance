#!/bin/bash
# chain.sh TREE: build TREE, then compare objects with main, then its counters and LBR (each step its own hold).
set -u
base=~/buster-fast-bench/892-claude
tree=${1:?tree}
cd "$base" || exit 2
./build.sh "$tree"
grep -q "build $tree status 0" "build-$tree.log" || { echo "build failed" > "chain-$tree.failed"; exit 1; }
rm -f results/objects.done
./objects.sh main "$tree" > "objects-$tree.log" 2>&1
./lbr.sh "$tree" > "lbr-$tree.log" 2>&1
echo done > "chain-$tree.done"

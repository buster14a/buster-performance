#!/bin/bash
# One tree's Release build, as the 9700X job builds it; run under the lock. Arguments: the tree (base | head | stage1)
# and, if not the tree's, the name its binary is kept under.
set -u
tree=$1
cd ~/buster-fast-bench/1340-reach/buster-$tree
start=$(date +%s)
BUSTER_HOST_ARCH=znver5 BUSTER_DEBUG_INFO=0 ./build.sh --config Release > ../build-$tree.log 2>&1
echo "build-status=$? seconds=$(( $(date +%s) - start ))" >> ../build-$tree.log
out=$(BUSTER_HOST_ARCH=znver5 BUSTER_DEBUG_INFO=0 ./build.sh print-output --config Release 2>/dev/null)
name=${2:-$tree}
mkdir -p ../bin && cp "$out" ../bin/compiler-$name && chmod +x ../bin/compiler-$name
{ git rev-parse HEAD; git diff --stat | tail -1; } > ../bin/compiler-$name.commit
tail -2 ../build-$tree.log
sha256sum ../bin/compiler-$name

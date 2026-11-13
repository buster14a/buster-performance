#!/bin/bash
# The x86-64 MSan builds of main and the branch, then each test-ssa-source command on both in the hosted shape; one
# hold of the host lock per run (exclusive.sh), one after another.
set -u
cd ~/buster-fast-bench/2658-claude
hold()
{
    local title=$1 limit=$2
    shift 2
    EXCLUSIVE_OWNER=claude-2658 EXCLUSIVE_TITLE="CI time per runner: $title" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2658 \
        ~/buster-fast-bench/exclusive.sh timeout -k 10 "$limit" "$@"
}
for t in base glue; do
    hold "x86-64 MSan build, $t" 590 scripts/build-tree.sh $t runs/build-$t-x86-64-memory BUSTER_HOST_ARCH=x86-64 BUSTER_SANITIZER=memory BUSTER_SANITIZER_OPTIMIZATION=3 2> runs-build-$t-x86-64-memory.stderr
    echo "build $t exit=$?"
done
for kind in compare random lifetimes; do
    for t in base glue; do
        hold "test-ssa-source $kind, x86-64 MSan, $t" 590 scripts/run-ssa.sh $t runs/$kind-memory-$t ~/buster-fast-bench/2658-claude/$t/build/cmake/x86-64-memory-O3/Release/compiler $kind 4,12,5,13 4 2> runs-$kind-memory-$t.stderr
        echo "$kind $t exit=$?"
    done
done

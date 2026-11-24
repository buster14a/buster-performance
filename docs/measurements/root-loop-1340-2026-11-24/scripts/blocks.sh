#!/bin/bash
# The corpus blocks of tools/ci/correctness.tests, by heading, with the Release head.
cd /home/user/buster || exit 1
L=/home/user/logs/blocks; rm -rf $L; mkdir -p $L
export BUSTER_COMPILER=/home/user/bin/compiler-final BUSTER_CORPUS=/home/user/corpus BUSTER_PARALLEL_CPUS=4
i=0
for heading in "Check semantic mutants of the frozen SQLite and musl sources against Clang" "Check c-testsuite's programs with their bodies read apart on 8 lanes" "Check the frozen SQLite source against Clang" "Check narrow-unsigned sign comparisons and admitted deferred diagnostics [2 CPUs]" "Test the semantic driver's diagnostics and emission against clang, with lazy system headers" "Check the repository's translation units with the checker"; do
    i=$((i + 1))
    awk -v h="== $heading" '$0 == h { on = 1; next } /^== / { on = 0 } on' tools/ci/correctness.tests > $L/block-$i.sh
    echo "== $heading" > $L/block-$i.log
    bash -e $L/block-$i.sh >> $L/block-$i.log 2>&1; echo "exit $?" >> $L/block-$i.log
done
echo done > $L/complete

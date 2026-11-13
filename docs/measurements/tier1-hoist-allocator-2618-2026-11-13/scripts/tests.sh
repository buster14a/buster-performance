#!/usr/bin/env bash
# The Tier 1 correctness steps of tools/ci/correctness.tests that this change touches, each logged.
set -u
cd /home/user/buster
B=${B:-./build/compiler}
corpus=$HOME/.cache/claude-2618/S/corpus
L=$HOME/.cache/claude-2618/tests/logs; mkdir -p $L
if [ ! -d build/c-testsuite/tests ]; then
  git init -q --template= build/c-testsuite && git -C build/c-testsuite fetch -q --depth 1 https://github.com/c-testsuite/c-testsuite 5c7275656d751de0e68b2d340a95b5681858ed07 && git -C build/c-testsuite checkout -q FETCH_HEAD
fi
subset=$(sed -n 's|^\([0-9][0-9]*\)$|build/c-testsuite/tests/single-exec/\1.c|p' tests/c-testsuite/subset.txt)
step() { local name=$1; shift; "$@" > $L/$name.log 2>&1; echo "$name $?" | tee -a $L/summary.txt; }
: > $L/summary.txt
step tier1-pipeline $B test-tier1-pipeline --cross-check
step tier1-cfg $B test-tier1-cfg
step tier1-frame-execution $B test-tier1-frame-execution
step ir $B test-ir
step c-testsuite-tier1 $B test-c-testsuite --tier1 --jobs 3 --subset tests/c-testsuite/subset.txt build/c-testsuite
step ssa-subset-tier1 $B test-ssa-source --typed --tier1 $subset
step ssa-generate-48 $B test-ssa-source --typed --tier1 --generate 48 --clang clang
step ssa-lifetimes-24 $B test-ssa-source --tier1 --generate 24 --seed 141 --lifetimes --clang clang
step ir-source-dominators $B test-ir-source --dominators $subset
step tier1-cfg-source-subset $B test-tier1-cfg-source $subset
step tier1-cfg-source-sqlite $B test-tier1-cfg-source --predefines "$corpus/provenance/gnu17-pinned-predefines.txt" --no-default-config --target=x86_64-linux-gnu -march=znver5 -std=gnu17 -nostdinc -isystem "$corpus/headers/usr/lib/clang/23/include" -isystem "$corpus/headers/usr/local/include" -isystem "$corpus/headers/usr/include" "$corpus/sqlite/sqlite3.c"
echo done >> $L/summary.txt

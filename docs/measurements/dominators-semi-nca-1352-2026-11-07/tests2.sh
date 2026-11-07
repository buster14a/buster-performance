#!/bin/sh
# End-to-end Tier 1 and SSA source tests for #1352, each under the lock separately; summary lines in tests2.out.
cd ~/buster-fast-bench/1352-claude || exit 1
if [ ! -d build/c-testsuite/tests ]; then
  git init -q --template= build/c-testsuite
  git -C build/c-testsuite fetch -q --depth 1 https://github.com/c-testsuite/c-testsuite 5c7275656d751de0e68b2d340a95b5681858ed07
  git -C build/c-testsuite checkout -q FETCH_HEAD
fi
subset=$(sed -n 's|^\([0-9][0-9]*\)$|build/c-testsuite/tests/single-exec/\1.c|p' tests/c-testsuite/subset.txt)
one() {
  ./run.sh t2.log sh -c "$1"
  printf '%s: %s | %s\n' "$1" "$(grep -av '^exclusive.sh\|^  title\|^  link\|^  pull request\|^exit' t2.log | tail -1)" "$(tail -1 t2.log)"
}
one "taskset -c 2 ./build/compiler test-ir-source --dominators tests/ir-source/dominators.c"
one "taskset -c 2 ./build/compiler test-ir-source --dominators $subset"
one "taskset -c 2 ./build/compiler test-ssa-source --typed --tier1 --self-test"
one "taskset -c 2 ./build/compiler test-ssa-source --tier1 --generate 24 --seed 141 --lifetimes --clang clang"
one "taskset -c 2 ./build/compiler test-ssa-source --typed --tier1 $subset"
one "./build/compiler test-c-testsuite --tier1 --jobs 8 --subset tests/c-testsuite/subset.txt build/c-testsuite"
one "./build/compiler test-c-testsuite --cross-check --clang clang --jobs 8 --subset tests/c-testsuite/subset.txt build/c-testsuite"
one "./build.sh check-call-graph"
one "taskset -c 2 ./build/compiler test-ir"
echo finished

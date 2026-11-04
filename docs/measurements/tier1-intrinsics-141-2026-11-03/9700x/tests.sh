#!/usr/bin/env bash
# tests.sh TREE: the tests the change touches, by TREE's build on this Zen 5, one hold of the lock each; tests/TREE/.
. ~/buster-fast-bench/claude-141-intrinsics/common.sh
t=$1
mkdir -p tests/$t
run() {
    local name=$1
    shift
    "$lock" bash -c "cd $t && taskset -c 2-5 build/compiler $* > ../tests/$t/$name.txt 2>&1; echo \"exit \$?\" >> ../tests/$t/$name.txt"
    echo "$t $name: $(grep -E 'checks|failures|failed=|totals|exit' tests/$t/$name.txt | tail -2 | tr '\n' ' ' | cut -c1-200)"
}
run test-ir test-ir
run test-ir-parse test-ir-parse
run test-ir-interpreter test-ir-interpreter
run test-ir-simd test-ir-simd
run test-tier1-select test-tier1-select
run test-tier1-wide test-tier1-wide
run test-ir-lowering test-ir-lowering
run test-ir-source test-ir-source --simd -march=x86-64-v4 tests/ir/vector-i32.c tests/ir/mask-builtins.c tests/ir/bmi-builtins.c
run test-tier1-cfg-source test-tier1-cfg-source --simd -march=x86-64-v4 tests/ir/vector-i32.c tests/ir/mask-builtins.c tests/ir/bmi-builtins.c

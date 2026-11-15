#!/bin/bash
# $1 compiler; runs the interpreter-related correctness commands, one line of result each.
C=$1
cd /home/user/buster
subset=$(sed -n 's|^\([0-9][0-9]*\)$|build/c-testsuite/tests/single-exec/\1.c|p' tests/c-testsuite/subset.txt)
run() {
  local name="$1"; shift
  local start=$(date +%s.%N)
  "$@" > ~/.cache/claude-2758/tests-out/"$name".log 2>&1
  local status=$?
  local end=$(date +%s.%N)
  printf '%-40s status=%d %.1fs\n' "$name" $status $(echo "$end - $start" | bc)
}
mkdir -p ~/.cache/claude-2758/tests-out
run interpreter "$C" test-interpreter
run interpreter-native "$C" test-interpreter-native
run interpreter-link "$C" test-interpreter-link
run ir-interpreter "$C" test-ir-interpreter
run libm-fegetround "$C" interpret-ir --result --bind 100=fegetround tests/ir/libm-call.ir
run libm-getpid "$C" interpret-ir --result --bind 100=getpid tests/ir/libm-call.ir
run ssa "$C" test-ssa
run ssa-ir "$C" test-ssa-ir
run ir "$C" test-ir
run ir-simd "$C" test-ir-simd
run ir-lowering "$C" test-ir-lowering
run ir-source-simd "$C" test-ir-source --simd -march=x86-64-v4 tests/ir/vector-i32.c tests/ir/mask-builtins.c tests/ir/bmi-builtins.c tests/ir/vector-rows.c tests/ir/carrier-rows.c
run ir-metamorphic "$C" test-ir-metamorphic --seed 731 --count 6
run ir-optimize "$C" test-ir-optimize
run ir-gvn "$C" test-ir-gvn
run tier1-masks "$C" test-tier1-masks
run tier1-wide "$C" test-tier1-wide
run ssa-self-test "$C" test-ssa-source --typed --tier1 --self-test
run ssa-generate48 "$C" test-ssa-source --typed --tier1 --generate 48 --clang clang
run ssa-generate24-lifetimes "$C" test-ssa-source --tier1 --generate 24 --seed 141 --lifetimes --clang clang
run ssa-source-typed "$C" test-ssa-source --typed tests/interpreter/source.c
run ssa-source-large "$C" test-ssa-source --typed --tier1 -DBUSTER_INTERPRETER_LARGE_WORDS=64 tests/interpreter/source.c
run interpret-c-units bash -c "\"$C\" interpret-c tests/interpreter/units-main.c tests/interpreter/units-library.c > build/interpreter-units.out && printf 'typed units: 1\n' | cmp - build/interpreter-units.out"
run fences "$C" test-ssa-source --clang clang tests/ir-source/fences.c
run atomics "$C" test-ssa-source --clang clang tests/ir-source/atomics.c
run atomic-stores "$C" test-ssa-source --typed --tier1 --clang clang tests/ir-source/atomic-stores.c
run overflow-builtins "$C" test-ssa-source --typed --tier1 --clang clang tests/ir-source/overflow-builtins.c
run c-testsuite-typed-tier1 "$C" test-ssa-source --typed --tier1 $subset

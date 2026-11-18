#!/usr/bin/env bash
# The interpreters' tests from tools/ci/correctness.tests, with the given compiler: each line's status and its last
# output line. usage: verify.sh COMPILER LOG_DIR
set -u
C="$1"; out="$2"
mkdir -p "$out"
cd /home/user/buster
n=0
fail=0
run() {
    n=$((n + 1))
    local log="$out/$(printf '%02d' $n).log"
    printf '%s\n' "$*" > "$log"
    bash -c "$*" >> "$log" 2>&1
    local rc=$?
    [ $rc -ne 0 ] && fail=$((fail + 1))
    printf 'rc=%d %s :: %s\n' "$rc" "$*" "$(tail -1 "$log" | cut -c1-160)"
}
subset=$(sed -n 's|^\([0-9][0-9]*\)$|build/c-testsuite/tests/single-exec/\1.c|p' tests/c-testsuite/subset.txt | tr '\n' ' ')
run "$C" test-interpreter
run "$C" test-interpreter-native
run "$C" test-interpreter-link
run "$C" test-ir-interpreter
run "$C" test-ir-parse
run "$C" test-ir-reduce
run "$C" test-ir-metamorphic --seed 731 --count 6
run "$C" test-ir-optimize
run "$C" test-ssa-ir
run "$C" test-ssa
run "$C" interpret-ir --result --bind 100=fegetround tests/ir/libm-call.ir
run "$C" interpret-ir --result --bind 100=getpid tests/ir/libm-call.ir
run "$C interpret-c tests/interpreter/units-main.c tests/interpreter/units-library.c > $out/interpreter-units.out && printf 'typed units: 1\n' | cmp - $out/interpreter-units.out"
run "$C" test-ssa-source --typed tests/interpreter/source.c
run "$C" test-ssa-source --typed --tier1 -DBUSTER_INTERPRETER_LARGE_WORDS=64 tests/interpreter/source.c
run "$C" test-ssa-source --typed --tier1 --self-test
run "$C" test-ssa-source --typed --tier1 --generate 48 --clang clang
run "$C" test-ssa-source --tier1 --generate 24 --seed 141 --lifetimes --clang clang
run "$C" test-ssa-source --clang clang tests/ir-source/fences.c
run "$C" test-ssa-source --clang clang tests/ir-source/atomics.c
run "$C" test-ssa-source --typed --tier1 --clang clang tests/ir-source/atomic-stores.c
run "$C" test-ssa-source --typed --tier1 --clang clang tests/ir-source/overflow-builtins.c
run "$C" test-c-testsuite --cross-check --clang clang --jobs 4 --subset tests/c-testsuite/subset.txt build/c-testsuite
run "$C" test-ssa-source --typed --tier1 $subset
printf 'verify: %d commands, %d failed\n' "$n" "$fail"

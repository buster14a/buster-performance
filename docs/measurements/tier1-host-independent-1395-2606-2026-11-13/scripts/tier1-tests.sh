#!/usr/bin/env bash
# The Tier 1 lines of tools/ci/correctness.tests, run in sequence; one PASS/FAIL line per command.
cd "${BUSTER:-.}"
B=./build/compiler
corpus=build/corpus
musl="$corpus/libc/musl"
subset=$(sed -n 's|^\([0-9][0-9]*\)$|build/c-testsuite/tests/single-exec/\1.c|p' tests/c-testsuite/subset.txt)
log=$1
run() { local start=$SECONDS; if "$@" >> "$log.detail" 2>&1; then echo "PASS $((SECONDS - start))s: $*" | cut -c1-200; else echo "FAIL $((SECONDS - start))s: $*" | cut -c1-200; fi; }
run $B test-tier1-frame
run $B test-tier1-frame-execution
run $B test-tier1-select --manifest
run $B test-tier1-liveness
run $B test-tier1-emit
run $B test-tier1-pipeline --cross-check
run $B test-tier1-masks
run $B test-tier1-wide
run $B test-tier1-model
run $B test-tier1-allocation
run $B test-tier1-cfg
run $B test-tier1-schedule
run $B test-emission-metadata
run $B test-emitted-code --cross-check
run $B test-check-debug --cross-check
run $B test-c-testsuite --tier1 --jobs 4 --subset tests/c-testsuite/subset.txt build/c-testsuite
run $B test-ssa-source --typed --tier1 --self-test
run $B test-ssa-source --typed --tier1 --generate 48 --clang clang
run $B test-ssa-source --tier1 --generate 24 --seed 141 --lifetimes --clang clang
run $B test-ssa-source --typed --tier1 $subset
run $B test-ssa-source --typed --tier1 -DBUSTER_INTERPRETER_LARGE_WORDS=64 tests/interpreter/source.c
run $B test-tier1-cfg-source $subset
run $B test-tier1-cfg-source --simd -march=x86-64-v4 tests/ir/vector-i32.c tests/ir/mask-builtins.c tests/ir/bmi-builtins.c tests/ir/vector-rows.c tests/ir/carrier-rows.c
run $B test-tier1-cfg-source --predefines "$corpus/provenance/gnu17-pinned-predefines.txt" --no-default-config --target=x86_64-linux-gnu -march=znver5 -std=gnu17 -nostdinc -isystem "$corpus/headers/usr/lib/clang/23/include" -isystem "$corpus/headers/usr/local/include" -isystem "$corpus/headers/usr/include" "$corpus/sqlite/sqlite3.c"
run $B test-tier1-cfg-source --no-default-config --target=x86_64-linux-gnu -march=znver5 -std=c99 -ffreestanding -nostdinc -D_XOPEN_SOURCE=700 -Os -I "$musl/arch/x86_64" -I "$musl/arch/generic" -I "$corpus/musl-generated/obj/src/internal" -I "$musl/src/include" -I "$musl/src/internal" -I "$corpus/musl-generated/obj/include" -I "$musl/include" "$musl"/src/*/*.c "$musl"/src/*/x86_64/*.c
echo done

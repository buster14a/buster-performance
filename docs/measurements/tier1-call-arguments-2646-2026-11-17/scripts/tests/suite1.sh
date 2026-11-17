#!/usr/bin/env bash
# The heavier Tier 1 consumers, one after another; each line's status in suite1.status.
cd /home/user/buster; X=${X:-./build/compiler}
export SOURCE_DATE_EPOCH=1792454400
corpus=$HOME/.cache/claude-2646/corpus
musl="$corpus/libc/musl"
out=${OUT:-$HOME/.cache/claude-2646/suite1}
mkdir -p $out; : > $out/status
run() { name=$1; shift; s=$(date +%s); "$@" > $out/$name.log 2>&1; echo "$name exit=$? $(( $(date +%s)-s ))s" >> $out/status; }
run cfg-source-ct $X test-tier1-cfg-source $(sed -n 's|^\([0-9][0-9]*\)$|build/c-testsuite/tests/single-exec/\1.c|p' tests/c-testsuite/subset.txt)
run cfg-source-simd $X test-tier1-cfg-source --simd -march=x86-64-v4 tests/ir/vector-i32.c tests/ir/mask-builtins.c tests/ir/bmi-builtins.c tests/ir/vector-rows.c tests/ir/carrier-rows.c
run cfg-source-sqlite $X test-tier1-cfg-source --predefines "$corpus/provenance/gnu17-pinned-predefines.txt" --no-default-config --target=x86_64-linux-gnu -march=znver5 -std=gnu17 -nostdinc -isystem "$corpus/headers/usr/lib/clang/23/include" -isystem "$corpus/headers/usr/local/include" -isystem "$corpus/headers/usr/include" "$corpus/sqlite/sqlite3.c"
run cfg-source-musl $X test-tier1-cfg-source --no-default-config --target=x86_64-linux-gnu -march=znver5 -std=c99 -ffreestanding -nostdinc -D_XOPEN_SOURCE=700 -Os \
  -I "$musl/arch/x86_64" -I "$musl/arch/generic" -I "$corpus/musl-generated/obj/src/internal" -I "$musl/src/include" -I "$musl/src/internal" -I "$corpus/musl-generated/obj/include" -I "$musl/include" \
  "$musl"/src/*/*.c "$musl"/src/*/x86_64/*.c
run calling-convention $X test-calling-convention --cross-check
run check-debug $X test-check-debug --cross-check
run ssa-typed-generate $X test-ssa-source --typed --tier1 --generate 48 --clang clang
run ssa-lifetimes $X test-ssa-source --tier1 --generate 24 --seed 141 --lifetimes --clang clang
run ssa-typed-ct $X test-ssa-source --typed --tier1 $(sed -n 's|^\([0-9][0-9]*\)$|build/c-testsuite/tests/single-exec/\1.c|p' tests/c-testsuite/subset.txt)
run ssa-interp $X test-ssa-source --typed --tier1 -DBUSTER_INTERPRETER_LARGE_WORDS=64 tests/interpreter/source.c
run check-lanes $X test-check-lanes
run emitted-code $X test-emitted-code
run emission-metadata $X test-emission-metadata
for t in test-tier1-allocation test-tier1-cfg test-tier1-emit test-tier1-frame test-tier1-frame-execution test-tier1-liveness test-tier1-masks test-tier1-pipeline test-tier1-select test-tier1-wide test-tier1-schedule; do run $t $X $t; done
echo done >> $out/status

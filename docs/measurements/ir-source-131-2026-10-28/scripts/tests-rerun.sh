#!/bin/bash
# q131d.sh's tests hold again: its script expanded musl's 1,355 paths into bash -c's one argument, past the kernel's
# 128 KB for an argument, so that exclusive.sh couldn't start. Here the held shell expands the globs itself.
cd ~/buster-fast-bench/claude-131
out=~/buster-fast-bench/claude-131/out2
export SOURCE_DATE_EPOCH=1792454400
unset CPATH C_INCLUDE_PATH
EXCLUSIVE_OWNER=claude-131 EXCLUSIVE_TITLE="solve #131 (IR source corpus)" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/131 ~/buster-fast-bench/exclusive.sh bash -c '
cd ~/buster-fast-bench/claude-131/head
out=~/buster-fast-bench/claude-131/out2
corpus=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
musl=$corpus/libc/musl
for t in test-ir test-ir-parse test-ssa-ir test-ir-interpreter test-ir-optimize test-ir-inline test-ir-gvn test-ir-licm test-ir-sroa test-tier1-select test-tier1-pipeline test-call-graph test-ir-lowering; do
    ./build/compiler $t > $out/head-$t.log 2>&1; echo "$t: $?"
done
./build/compiler test-ir-source $(sed -n "s|^\([0-9][0-9]*\)$|$HOME/buster-fast-bench/claude-131/ct/c-testsuite/tests/single-exec/\1.c|p" tests/c-testsuite/subset.txt) > $out/head-ir-source-ct.log 2>&1; echo "ir-source ct: $?"
./build/compiler test-ir-source --predefines $corpus/provenance/gnu17-pinned-predefines.txt --no-default-config --target=x86_64-linux-gnu -march=znver5 -std=gnu17 -nostdinc -isystem $corpus/headers/usr/lib/clang/23/include -isystem $corpus/headers/usr/local/include -isystem $corpus/headers/usr/include $corpus/sqlite/sqlite3.c > $out/head-ir-source-sqlite.log 2>&1; echo "ir-source sqlite: $?"
./build/compiler test-ir-source --no-default-config --target=x86_64-linux-gnu -march=znver5 -std=c99 -ffreestanding -nostdinc -D_XOPEN_SOURCE=700 -Os -I $musl/arch/x86_64 -I $musl/arch/generic -I $corpus/musl-generated/obj/src/internal -I $musl/src/include -I $musl/src/internal -I $corpus/musl-generated/obj/include -I $musl/include $musl/src/*/*.c $musl/src/*/x86_64/*.c > $out/head-ir-source-musl.log 2>&1; echo "ir-source musl: $?"
./build.sh check-call-graph > $out/head-call-graph.log 2>&1; echo "call graph: $?"
' > "$out/tests-rerun.log" 2>&1
echo "tests rerun: $?" >> "$out/progress-rerun"

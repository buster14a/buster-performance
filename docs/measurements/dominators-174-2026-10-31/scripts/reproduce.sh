#!/bin/sh
# Reproduce the #174/#940 dominator source-CFG qualification and measurement.
# Run on the approved 9700X (benchpress); every command takes the shared lock,
# the timed benchmark on CPU 2.  Executed from the repository root of a checkout
# at 5ebf340c39e12f27d0425810d1eefdd4cd2b3db7 built with ./build.sh.
set -eu

corpus=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
musl="$corpus/libc/musl"
out=${1:-.}

# 1. Qualify sqlite3.c and export every qualified CFG.
EXCLUSIVE_OWNER=devin-940 EXCLUSIVE_TITLE="PR 940 sqlite dominators+export" \
  EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/940 \
  ~/buster-fast-bench/exclusive.sh ./build/compiler test-ir-source \
    --dominators-cfg "$out/sqlite3-dom.cfg" \
    --predefines "$corpus/provenance/gnu17-pinned-predefines.txt" \
    --no-default-config --target=x86_64-linux-gnu -march=znver5 -std=gnu17 -nostdinc \
    -isystem "$corpus/headers/usr/lib/clang/23/include" \
    -isystem "$corpus/headers/usr/local/include" \
    -isystem "$corpus/headers/usr/include" \
    "$corpus/sqlite/sqlite3.c"

# 2. Qualify musl's sources (no export: qualification receipt only).
EXCLUSIVE_OWNER=devin-940 EXCLUSIVE_TITLE="PR 940 musl dominators" \
  EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/940 \
  ~/buster-fast-bench/exclusive.sh ./build/compiler test-ir-source --dominators \
    --no-default-config --target=x86_64-linux-gnu -march=znver5 -std=c99 -ffreestanding \
    -nostdinc -D_XOPEN_SOURCE=700 -Os \
    -I "$musl/arch/x86_64" -I "$musl/arch/generic" -I "$corpus/musl-generated/obj/src/internal" \
    -I "$musl/src/include" -I "$musl/src/internal" -I "$corpus/musl-generated/obj/include" \
    -I "$musl/include" \
    "$musl"/src/*/*.c "$musl"/src/*/x86_64/*.c

# 3. Measure the imported CFGs: scalar/vector/AUTO agreement, then timing on CPU 2.
EXCLUSIVE_OWNER=devin-940 EXCLUSIVE_TITLE="PR 940 bench cfg" \
  EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/940 \
  ~/buster-fast-bench/exclusive.sh taskset -c 2 ./build/compiler benchmark-dominators \
    --cfg "$out/sqlite3-dom.cfg"

#!/bin/bash
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Copyright (c) 2026 David Gonzalez Martin.
# One functional acceptance invocation, using the repository's CPU-budgeted
# test runner. Invoke through exclusive.sh from the campaign directory.
set -euo pipefail
root=$PWD
mode=$1
tree=head
if [[ $mode == tsan ]]; then tree=tsan; fi
export BUSTER_1404_OUTPUT=$root/acceptance-$mode
export BUSTER_1404_SCRIPTS=$root/scripts
export BUSTER_1404_CORPUS=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
export BUSTER_1404_MUSL=$BUSTER_1404_CORPUS/libc/musl
mkdir -p "$BUSTER_1404_OUTPUT"
: > "$BUSTER_1404_OUTPUT/status.tsv"
cd "$root/$tree"
git rev-parse HEAD > "$BUSTER_1404_OUTPUT/source.txt"
sha256sum build/compiler >> "$BUSTER_1404_OUTPUT/source.txt"
cat > "$BUSTER_1404_OUTPUT/inventory.tests" <<'TESTS'
== Deferred fixtures and actual expression workers [8 CPUs]
bash "$BUSTER_1404_SCRIPTS/acceptance-case.sh" deferred test-checker-deferred
== Driver lane and diagnostic comparisons [8 CPUs]
bash "$BUSTER_1404_SCRIPTS/acceptance-case.sh" driver test-check-lanes
== C-testsuite with reordered identifiers [8 CPUs]
bash "$BUSTER_1404_SCRIPTS/acceptance-case.sh" c-testsuite test-checker-corpus --clang clang --deferred 8 --id-order 153 --no-default-config --target=x86_64-linux-gnu -march=znver5 -std=gnu17 "$HOME/buster-fast-bench/deferred-lanes-claude/c-testsuite/tests/single-exec"
== SQLite with reordered identifiers [8 CPUs]
bash "$BUSTER_1404_SCRIPTS/acceptance-case.sh" sqlite test-checker-corpus --clang clang --deferred 8 --id-order 153 --no-default-config --target=x86_64-linux-gnu -march=znver5 -std=gnu17 -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -nostdinc -isystem "$BUSTER_1404_CORPUS/headers/usr/lib/clang/23/include" -isystem "$BUSTER_1404_CORPUS/headers/usr/local/include" -isystem "$BUSTER_1404_CORPUS/headers/usr/include" "$BUSTER_1404_CORPUS/sqlite/sqlite3.c"
== Musl corpus [8 CPUs]
bash "$BUSTER_1404_SCRIPTS/acceptance-case.sh" musl test-checker-corpus --clang clang --deferred 8 --no-default-config --target=x86_64-linux-gnu -march=znver5 -std=c99 -ffreestanding -nostdinc -D_XOPEN_SOURCE=700 -Os -pipe -I "$BUSTER_1404_MUSL/arch/x86_64" -I "$BUSTER_1404_MUSL/arch/generic" -I "$BUSTER_1404_CORPUS/musl-generated/obj/src/internal" -I "$BUSTER_1404_MUSL/src/include" -I "$BUSTER_1404_MUSL/src/internal" -I "$BUSTER_1404_CORPUS/musl-generated/obj/include" -I "$BUSTER_1404_MUSL/include" "$BUSTER_1404_MUSL/src/math" "$BUSTER_1404_MUSL/src/string" "$BUSTER_1404_MUSL/src/stdlib" "$BUSTER_1404_MUSL/src/fenv" "$BUSTER_1404_MUSL/src/legacy" "$BUSTER_1404_MUSL/src/process" "$BUSTER_1404_MUSL/src/signal" "$BUSTER_1404_MUSL/src/multibyte"
== Type constructors and capacity bounds
bash "$BUSTER_1404_SCRIPTS/acceptance-case.sh" types test-types
TESTS
if [[ $mode == native ]]; then
    cat >> "$BUSTER_1404_OUTPUT/inventory.tests" <<'TESTS'
== Full checker regressions [2 CPUs]
bash "$BUSTER_1404_SCRIPTS/acceptance-case.sh" checker test-checker --seed 133
== Full driver and timing report regressions [2 CPUs]
bash "$BUSTER_1404_SCRIPTS/acceptance-case.sh" clock-driver test-checker-driver --executable "$BUSTER_COMPILER"
TESTS
fi
exec ./build/compiler parallel --jobs 8 --timeout 600 "$BUSTER_1404_OUTPUT/inventory.tests"

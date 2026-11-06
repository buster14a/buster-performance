#!/bin/bash
# Native acceptance for buster#1404; every test invocation owns the 9700X lock.
set -uo pipefail
root=$HOME/buster-fast-bench/1404-final
cd "$root/tsan"
out=$root/tsan-qualification
mkdir -p "$out"
export EXCLUSIVE_OWNER=codex-1404 EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/1440
lock=$HOME/buster-fast-bench/exclusive.sh
compiler=$root/tsan/build/compiler
corpus=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
run()
{
    local name=$1
    shift
    EXCLUSIVE_TITLE="Issue 1404 TSan $name" "$lock" taskset -c 0-7 "$compiler" "$@" > "$out/$name.log" 2>&1
    local status=$?
    printf '%s\t%s\n' "$name" "$status" | tee -a "$out/status.tsv"
    tail -4 "$out/$name.log"
    return "$status"
}
: > "$out/status.tsv"
git rev-parse HEAD > "$out/source.txt"
sha256sum "$compiler" >> "$out/source.txt"
run deferred test-checker-deferred
run driver test-check-lanes
run c-testsuite test-checker-corpus --clang clang --deferred 8 --id-order 153 \
    --no-default-config --target=x86_64-linux-gnu -march=znver5 -std=gnu17 \
    "$HOME/buster-fast-bench/deferred-lanes-claude/c-testsuite/tests/single-exec"
run sqlite test-checker-corpus --clang clang --deferred 8 --id-order 153 \
    --no-default-config --target=x86_64-linux-gnu -march=znver5 -std=gnu17 \
    -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE \
    -nostdinc -isystem "$corpus/headers/usr/lib/clang/23/include" \
    -isystem "$corpus/headers/usr/local/include" -isystem "$corpus/headers/usr/include" \
    "$corpus/sqlite/sqlite3.c"
musl=$corpus/libc/musl
run musl test-checker-corpus --clang clang --deferred 8 --no-default-config \
    --target=x86_64-linux-gnu -march=znver5 -std=c99 -ffreestanding -nostdinc -D_XOPEN_SOURCE=700 -Os -pipe \
    -I "$musl/arch/x86_64" -I "$musl/arch/generic" -I "$corpus/musl-generated/obj/src/internal" \
    -I "$musl/src/include" -I "$musl/src/internal" -I "$corpus/musl-generated/obj/include" -I "$musl/include" \
    "$musl/src/math" "$musl/src/string" "$musl/src/stdlib" "$musl/src/fenv" "$musl/src/legacy" \
    "$musl/src/process" "$musl/src/signal" "$musl/src/multibyte"
awk -F '\t' '$2 != 0 { failed=1 } END { exit failed }' "$out/status.tsv"

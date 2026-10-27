#!/usr/bin/env bash
# tests.sh: the checker's tests on the head's executable at shift 0, from the head's tree, as the 9700X job runs them,
# each under the lock alone, on CPUs 0 to 7.
set -u
here="$HOME/buster-fast-bench/literal-510"
cd "$here/head"
mkdir -p build && cp "$here/bin/head-s0" build/compiler
unset CPATH C_INCLUDE_PATH
export SOURCE_DATE_EPOCH=1792454400
corpus=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
system=(-nostdinc -isystem "$corpus/headers/usr/lib/clang/23/include" -isystem "$corpus/headers/usr/local/include" -isystem "$corpus/headers/usr/include")
musl="$corpus/libc/musl"
muslflags=(--no-default-config --target=x86_64-linux-gnu -march=znver5 -std=c99 -ffreestanding -nostdinc -D_XOPEN_SOURCE=700 -Os -pipe
    -I "$musl/arch/x86_64" -I "$musl/arch/generic" -I "$corpus/musl-generated/obj/src/internal" -I "$musl/src/include" -I "$musl/src/internal" -I "$corpus/musl-generated/obj/include" -I "$musl/include")
run()
{
    echo "== $*"
    local start=$EPOCHREALTIME
    "$here/locked.sh" taskset -c 0-7 "$@" 2>&1 | tail -15
    echo "status ${PIPESTATUS[0]}, $(awk -v a=$start -v b=$EPOCHREALTIME 'BEGIN { printf "%.1f s", b - a }')"
}
run ./build/compiler test-checker --seed 133
run ./build/compiler test-checker-driver --executable ./build/compiler
run ./build/compiler test-checker-driver --executable ./build/compiler --lazy-system-headers
run ./build/compiler test-checker-corpus --clang /usr/bin/clang --symbols-minimum 348 "${muslflags[@]}" "$musl/src/math" "$musl/src/string" "$musl/src/stdlib" "$musl/src/fenv" "$musl/src/legacy" "$musl/src/process" "$musl/src/signal" "$musl/src/multibyte"
run ./build/compiler test-checker-corpus --clang /usr/bin/clang --semantic-mutations 8 --seed 133 --minimize 0 --no-default-config --target=x86_64-linux-gnu -march=znver5 -std=gnu17 "${system[@]}" "$corpus/sqlite/sqlite3.c"
run ./build/compiler test-checker-corpus --clang /usr/bin/clang --semantic-mutations 96 --seed 133 --minimize 0 "${muslflags[@]}" --files-from tests/preprocessor-oracle/musl-subset.txt --root "$musl"
run ./build/compiler test-checker-corpus --clang /usr/bin/clang --deferred 8 --symbols --no-default-config --target=x86_64-linux-gnu -march=znver5 -std=gnu17 "${system[@]}" "$corpus/sqlite/sqlite3.c"
run ./build/compiler test-checker-deferred

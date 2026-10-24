#!/usr/bin/env bash
# Original #335 qualification glue; run outside the shared lock from the campaign directory.
set -euo pipefail
export EXCLUSIVE_OWNER=codex-335-336
export EXCLUSIVE_TITLE='Take over 335 and 336; review open PRs'
export EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/335
lock=~/buster-fast-bench/exclusive.sh
corpus=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
musl=$corpus/libc/musl
system=(-march=znver5 -nostdinc -isystem "$corpus/headers/usr/lib/clang/23/include" -isystem "$corpus/headers/usr/local/include" -isystem "$corpus/headers/usr/include")
musl_flags=(-march=znver5 -std=c99 -ffreestanding -nostdinc -D_XOPEN_SOURCE=700 -Os -I "$musl/arch/x86_64" -I "$musl/arch/generic" -I "$corpus/musl-generated/obj/src/internal" -I "$musl/src/include" -I "$musl/src/internal" -I "$corpus/musl-generated/obj/include" -I "$musl/include")
"$lock" ./head/build/compiler test-profile > raw/test-profile.txt 2>&1
"$lock" ./head/build/compiler test-parser --clang > raw/test-parser.txt 2>&1
"$lock" ./head/build/compiler test-parser --clang -std=c99 > raw/test-parser-c99.txt 2>&1
"$lock" ./head/build/compiler test-parser --clang -std=c23 > raw/test-parser-c23.txt 2>&1
"$lock" ./head/build/compiler test-preprocessor --clang > raw/test-preprocessor.txt 2>&1
"$lock" ./head/build/compiler test-parser --clang "${system[@]}" "$corpus/sqlite/sqlite3.c" > raw/test-parser-sqlite.txt 2>&1
run_input()
{
    local name=$1
    shift
    "$lock" ./head/build/compiler test-preprocessor --compare-clang --clang /usr/bin/clang "$@" > "raw/oracle-$name.txt" 2>&1
    for driver in parse checker; do
        local command=(-fsyntax-only)
        [ "$driver" = parse ] && command=(parse -fsyntax-only)
        for spin in 0 200; do
            ./head/build/compiler ab --rounds 5 --cpu 2 --lock "$lock" head -- time-runs --runs 21 --after-scalar "$spin" --list "${command[@]}" "$@" --list "${command[@]}" --parser-keywords "$@" > "raw/flag-$name-$driver-spin$spin.txt"
        done
    done
    for process in 1 2 3; do
        "$lock" taskset -c 2 ./head/build/compiler benchmark-parser "$@" > "raw/benchmark-$name-$process.txt"
        "$lock" taskset -c 2 ./qualify "$@" > "raw/accounting-$name-off-$process.txt"
        "$lock" taskset -c 2 ./qualify --parser-keywords "$@" > "raw/accounting-$name-on-$process.txt"
    done
}
run_input small "${musl_flags[@]}" "$musl/src/stdio/vfprintf.c"
run_input headers "${system[@]}" inputs/headers.c
run_input sqlite "${system[@]}" "$corpus/sqlite/sqlite3.c"

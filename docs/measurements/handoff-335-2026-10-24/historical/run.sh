#!/bin/bash
# #335's measurements on the locked Ryzen 7 9700X: run from ~/buster-fast-bench/handoff-335, which holds the trees
# harness-acde1ef (main 1dde9db with time-runs) and fused-ec3441d (the same with the fused handoff), each built with its
# own ./build.sh under the lock, and inputs/headers.c (this directory's). ab takes the lock for each run and pins it to
# CPU 2, so this script runs outside the lock. Every output goes to raw/.
#   ./run.sh [rounds]
set -e
rounds=${1:-5}
lock=~/buster-fast-bench/exclusive.sh
export EXCLUSIVE_OWNER=claude-335-handoff EXCLUSIVE_TITLE='#335 preprocessing-to-parser handoff' \
    EXCLUSIVE_LINK=https://claude.ai/code/session_01LUKTEbEnuQCHJ1kzJ8iha7
corpus=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
musl=$corpus/libc/musl
system=(-march=znver5 -nostdinc -isystem "$corpus/headers/usr/lib/clang/23/include" -isystem "$corpus/headers/usr/local/include"
        -isystem "$corpus/headers/usr/include")
musl_flags=(-march=znver5 -std=c99 -ffreestanding -nostdinc -D_XOPEN_SOURCE=700 -Os -I "$musl/arch/x86_64" -I "$musl/arch/generic"
            -I "$corpus/musl-generated/obj/src/internal" -I "$musl/src/include" -I "$musl/src/internal" -I "$corpus/musl-generated/obj/include"
            -I "$musl/include")
mkdir -p raw
# The inputs: name, then the options and the file.
run_input()
{
    local name=$1
    shift
    local driver
    for driver in parse checker; do
        local command=(-fsyntax-only)
        [ "$driver" = parse ] && command=(parse -fsyntax-only)
        local spin
        for spin in 0 200; do
            # One binary, the flag off and on, interleaved fresh processes.
            ./fused-ec3441d/build/compiler ab --rounds "$rounds" --cpu 2 --lock "$lock" fused-ec3441d \
                -- time-runs --runs 21 --after-scalar "$spin" --list "${command[@]}" "$@" --list "${command[@]}" --parser-keywords "$@" \
                > "raw/flag-$name-$driver-spin$spin.txt"
        done
        # The plain path's code before and after the change, the flag off.
        ./fused-ec3441d/build/compiler ab --rounds "$rounds" --cpu 2 --lock "$lock" harness-acde1ef fused-ec3441d \
            -- time-runs --runs 21 --list "${command[@]}" "$@" > "raw/trees-$name-$driver.txt"
    done
    # In the process: the handoff's rows beside the conversion and the parser, then the two sustained rows alone.
    local p
    for p in 1 2 3; do
        "$lock" taskset -c 2 ./fused-ec3441d/build/compiler benchmark-parser "$@" > "raw/benchmark-$name-$p.txt"
    done
    for row in handoff fused; do
        "$lock" taskset -c 2 ./fused-ec3441d/build/compiler benchmark-parser --only "$row" "$@" > "raw/benchmark-$name-only-$row.txt"
    done
}
run_input small "${musl_flags[@]}" "$musl/src/stdio/vfprintf.c"
run_input headers "${system[@]}" inputs/headers.c
run_input sqlite "${system[@]}" "$corpus/sqlite/sqlite3.c"

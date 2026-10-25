#!/bin/bash
# The refined fused conversion (fused2-9cd3c2f): built under the lock, then benchmark-parser's handoff rows on the three
# inputs (three processes each, and the two rows alone) and the whole-driver A/B on sqlite3.c, both drivers, sustained
# and after 200 ms of scalar work. As run.sh: from ~/buster-fast-bench/handoff-335, outside the lock; outputs in raw2/.
set -e
rounds=${1:-5}
tree=fused2-9cd3c2f
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
mkdir -p raw2
(cd "$tree" && "$lock" ./build.sh > ../raw2/build.txt 2>&1)
# The flag must change nothing the drivers print.
"$lock" bash -c "for d in 'parse -fsyntax-only' '-fsyntax-only'; do ./$tree/build/compiler \$d ${system[*]} $corpus/sqlite/sqlite3.c > raw2/off.txt 2>&1; a=\$?; ./$tree/build/compiler \$d --parser-keywords ${system[*]} $corpus/sqlite/sqlite3.c > raw2/on.txt 2>&1; b=\$?; echo \"\$d: \$a/\$b \$(cmp -s raw2/off.txt raw2/on.txt && echo identical)\"; done" > raw2/check.txt
bench()
{
    local name=$1
    shift
    local p
    for p in 1 2 3; do
        "$lock" taskset -c 2 "./$tree/build/compiler" benchmark-parser "$@" > "raw2/benchmark-$name-$p.txt"
    done
    for row in handoff fused; do
        "$lock" taskset -c 2 "./$tree/build/compiler" benchmark-parser --only "$row" "$@" > "raw2/benchmark-$name-only-$row.txt"
    done
}
bench small "${musl_flags[@]}" "$musl/src/stdio/vfprintf.c"
bench headers "${system[@]}" inputs/headers.c
bench sqlite "${system[@]}" "$corpus/sqlite/sqlite3.c"
for driver in parse checker; do
    command=(-fsyntax-only)
    [ "$driver" = parse ] && command=(parse -fsyntax-only)
    for spin in 0 200; do
        "./$tree/build/compiler" ab --rounds "$rounds" --cpu 2 --lock "$lock" "$tree" \
            -- time-runs --runs 21 --after-scalar "$spin" --list "${command[@]}" "${system[@]}" "$corpus/sqlite/sqlite3.c" \
            --list "${command[@]}" --parser-keywords "${system[@]}" "$corpus/sqlite/sqlite3.c" > "raw2/flag-sqlite-$driver-spin$spin.txt"
    done
done

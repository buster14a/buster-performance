#!/usr/bin/env bash
# Compare two compiler executables' outputs byte for byte: objects, diagnostics and exit statuses.
# usage: compare.sh A B OUT_DIR
set -uo pipefail
A=$1
B=$2
out=$3
S=/tmp/claude-0/-home-user-buster/93411616-8b2b-5c03-9f96-7cf60bf856b2/scratchpad
corpus=$S/corpus
mkdir -p "$out"
export SOURCE_DATE_EPOCH=1792454400
unset CPATH C_INCLUDE_PATH
compared=0
declare -a statuses=()
differed=0
# run NAME ARGS... : each binary writes NAME.{a,b}.o and its diagnostics; both must match.
run()
{
    local name=$1
    shift
    local status_a status_b
    "$A" "$@" -o "$out/$name.a.o" > "$out/$name.a.out" 2> "$out/$name.a.err"
    status_a=$?
    "$B" "$@" -o "$out/$name.b.o" > "$out/$name.b.out" 2> "$out/$name.b.err"
    status_b=$?
    compared=$((compared + 1))
    local same=1
    [ "$status_a" = "$status_b" ] || same=0
    cmp -s "$out/$name.a.out" "$out/$name.b.out" || same=0
    cmp -s "$out/$name.a.err" "$out/$name.b.err" || same=0
    if [ -e "$out/$name.a.o" ] || [ -e "$out/$name.b.o" ]; then
        cmp -s "$out/$name.a.o" "$out/$name.b.o" || same=0
    fi
    local object=0
    for argument in "$@"; do [ "$argument" = -c ] && object=1; done
    if [ "$object" = 1 ] && [ "$status_a" = 0 ] && [ ! -s "$out/$name.a.o" ]; then
        printf 'NO OBJECT %s\n' "$name"
        same=0
    fi
    if grep -q "^usage:" "$out/$name.a.err"; then
        printf "USAGE %s\n" "$name"
        same=0
    fi
    if [ "$same" = 0 ]; then
        differed=$((differed + 1))
        printf 'DIFFER %s (status %s %s)\n' "$name" "$status_a" "$status_b"
    fi
    statuses[$status_a]=$(( ${statuses[$status_a]:-0} + 1 ))
    rm -f "$out/$name.a.o" "$out/$name.b.o" "$out/$name.a.out" "$out/$name.b.out"
    if [ "$status_a" = 0 ]; then rm -f "$out/$name.a.err" "$out/$name.b.err"; fi
}
frozen=(--predefines "$corpus/provenance/gnu17-pinned-predefines.txt" --target=x86_64-linux-gnu -march=znver5 -std=gnu17 -nostdinc
    -isystem "$corpus/headers/usr/lib/clang/23/include" -isystem "$corpus/headers/usr/local/include" -isystem "$corpus/headers/usr/include")
sqlite=$corpus/sqlite
run sqlite-c "${frozen[@]}" -c "$sqlite/sqlite3.c"
run sqlite-c-scalar --scalar "${frozen[@]}" -c "$sqlite/sqlite3.c"
run sqlite-c-g "${frozen[@]}" -g -c "$sqlite/sqlite3.c"
run sqlite-c-lower-all "${frozen[@]}" --lower-all -c "$sqlite/sqlite3.c"
run sqlite-syntax "${frozen[@]}" -Wall -fsyntax-only "$sqlite/sqlite3.c"
run sqlite-measure -c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$sqlite" "$sqlite/sqlite3.c"
run sqlite-shell-c "${frozen[@]}" -c "$sqlite/shell.c" "-I$sqlite"
musl=$corpus/libc/musl
musl_options=(--target=x86_64-linux-gnu -march=znver5 -std=c99 -ffreestanding -nostdinc -D_XOPEN_SOURCE=700 -Os -pipe
    -I "$musl/arch/x86_64" -I "$musl/arch/generic" -I "$corpus/musl-generated/obj/src/internal" -I "$musl/src/include" -I "$musl/src/internal"
    -I "$corpus/musl-generated/obj/include" -I "$musl/include")
for f in "$musl"/src/*/*.c; do
    rel=${f#"$musl/src/"}
    run "musl-${rel//\//-}" "${musl_options[@]}" -c "$f"
done
for f in "$S"/c-testsuite/tests/single-exec/*.c; do
    run "cts-$(basename "$f" .c)" -c "$f"
done
printf 'compared %d, differed %d\n' "$compared" "$differed"
for s in "${!statuses[@]}"; do printf 'status %s: %d\n' "$s" "${statuses[$s]}"; done

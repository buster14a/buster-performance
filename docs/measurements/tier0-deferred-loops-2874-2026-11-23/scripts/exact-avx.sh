#!/bin/bash
# exact-avx.sh OLD NEW OUT: musl's units and tests/**/*.c at targets with AVX (x86-64-v3, znver5), every object compared (buster#2874).
# sqlite3.c (with and without -g), Lua 5.4.8, musl's units, the compiler's own main.c, and tests/**/*.c; `quick` takes
# sqlite3.c, Lua and main.c alone. Prints a line a difference and the totals.
set -u
OLD=$1; NEW=$2; OUT=$3; QUICK=${4:-}
C=/home/user/corpus
LUA=/home/user/inputs/lua-5.4.8/src
B=/home/user/buster
mkdir -p "$OUT"
rm -f "$OUT"/list.txt
SQ="--predefines $C/provenance/gnu17-pinned-predefines.txt -march=znver5 -std=gnu17 -nostdinc -isystem $C/headers/usr/lib/clang/23/include -isystem $C/headers/usr/local/include -isystem $C/headers/usr/include"
MUSL=$C/libc/musl
MU="-std=c99 -nostdinc -ffreestanding -D_XOPEN_SOURCE=700 -I $MUSL/arch/x86_64 -I $MUSL/arch/generic -I $C/musl-generated/obj/src/internal -I $MUSL/src/include -I $MUSL/src/internal -I $C/musl-generated/obj/include -I $MUSL/include"
[ -f "$B/build/predefines.h" ] || clang -dM -E -march=native -fwrapv -funsigned-char -x c /dev/null > "$B/build/predefines.h"
MAIN="-march=native -I$B/src -fwrapv -funsigned-char --predefines $B/build/predefines.h"
{
    declare -A seen
    for f in "$MUSL"/src/*/*.c "$MUSL"/src/*/x86_64/*.c; do
        b=${f##*/}
        if [[ -z ${seen[$b]:-} ]]; then seen[$b]=1; echo "musl-v3 -march=x86-64-v3 $MU|$f"; fi
    done
    find "$B/tests" -name '*.c' | sort | while read -r f; do echo "tests-v3 -march=x86-64-v3|$f"; echo "tests-z5 -march=znver5|$f"; done
} > "$OUT/list.txt"
compare()
{
    local line=$1 tag flags file id
    tag=${line%% *}
    flags=${line#* }
    flags=${flags%%|*}
    file=${line#*|}
    id=$(printf '%s' "$tag|$file" | sha1sum | cut -c1-12)
    # shellcheck disable=SC2086
    "$OLD" -c $flags "$file" -o "$OUT/$id.old.o" > "$OUT/$id.old.txt" 2>&1; local a=$?
    # shellcheck disable=SC2086
    "$NEW" -c $flags "$file" -o "$OUT/$id.new.o" > "$OUT/$id.new.txt" 2>&1; local b=$?
    if [ $a -ne $b ]; then
        echo "STATUS $a $b $tag $file"
    elif [ $a -eq 0 ] && ! cmp -s "$OUT/$id.old.o" "$OUT/$id.new.o"; then
        echo "DIFFER $tag $file $id"
    elif ! cmp -s "$OUT/$id.old.txt" "$OUT/$id.new.txt"; then
        echo "OUTPUT $tag $file $id"
    else
        echo "SAME $a $tag"
        rm -f "$OUT/$id".*
    fi
}
export -f compare
export OLD NEW OUT
tr '\n' '\0' < "$OUT/list.txt" | xargs -0 -P 4 -I{} bash -c 'compare "$@"' _ {} > "$OUT/results.txt"
grep -v '^SAME' "$OUT/results.txt" | head -50
echo "compiles $(wc -l < "$OUT/results.txt") same $(grep -c '^SAME' "$OUT/results.txt") same-built $(grep -c '^SAME 0' "$OUT/results.txt") differ $(grep -c '^DIFFER' "$OUT/results.txt") status $(grep -c '^STATUS' "$OUT/results.txt") output $(grep -c '^OUTPUT' "$OUT/results.txt")"

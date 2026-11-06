#!/bin/bash
# diag.sh BIN OUT KIND MODE FILE [extra...]: BIN's diagnostics and status for FILE, with the corpus KIND's flags, into OUT/KIND/
BIN=$1; OUT=$2; KIND=$3; MODE=$4; FILE=$5; shift 5
C=/home/david/.cache/claude-174/corpus
musl=$C/libc/musl
system=(-nostdinc -isystem "$C/headers/usr/lib/clang/23/include" -isystem "$C/headers/usr/local/include" -isystem "$C/headers/usr/include")
case $KIND in
    musl) flags=(--target=x86_64-linux-gnu -march=znver5 -std=c99 -ffreestanding -nostdinc -D_XOPEN_SOURCE=700 -Os -pipe
                 -I "$musl/arch/x86_64" -I "$musl/arch/generic" -I "$C/musl-generated/obj/src/internal" -I "$musl/src/include"
                 -I "$musl/src/internal" -I "$C/musl-generated/obj/include" -I "$musl/include") ;;
    cts) flags=(--target=x86_64-linux-gnu -march=znver5 -std=gnu17 "${system[@]}") ;;
    sqlite) flags=(--target=x86_64-linux-gnu -march=znver5 -std=gnu17 "${system[@]}") ;;
esac
name=$(printf '%s' "$FILE" | tr '/' '_')
mkdir -p "$OUT/$KIND"
tmp=$(mktemp -d /tmp/droid1340-diag.XXXXXX)
if [ "$MODE" = c ]; then
    "$BIN" -c -o "$tmp/out.o" -Wall -Wextra "${flags[@]}" "$@" "$FILE" > "$OUT/$KIND/$name" 2>&1
else
    "$BIN" -fsyntax-only -Wall -Wextra "${flags[@]}" "$@" "$FILE" > "$OUT/$KIND/$name" 2>&1
fi
echo "status $?" >> "$OUT/$KIND/$name"
rm -rf "$tmp"

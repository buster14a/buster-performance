#!/bin/bash
# shape.sh UNIT: one line for UNIT: the lanes the deferred reader's rule gives its bodies on 8 permitted lanes (the
# `active` of benchmark-checker-deferred's reading on --lanes 8), then its tokens, bodies, body tokens, largest and
# second body, top-level tokens and whether it merged. Six passes; the timings aren't used. UNIT is named as in
# bench.sh (cts/NAME.c, sqlite, syn/NAME.c, musl/PATH.c), with bench.sh's options.
D=~/buster-fast-bench/447-claude
C=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
M=$C/libc/musl
unit=$1
gnu17=(--predefines "$C/provenance/gnu17-pinned-predefines.txt" --clang-features --no-default-config --target=x86_64-linux-gnu -march=znver5 -std=gnu17 -nostdinc -isystem "$C/headers/usr/lib/clang/23/include" -isystem "$C/headers/usr/local/include" -isystem "$C/headers/usr/include")
musl=(--clang-features --no-default-config --target=x86_64-linux-gnu -march=znver5 -std=c99 -ffreestanding -nostdinc -D_XOPEN_SOURCE=700 -Os -I "$M/arch/x86_64" -I "$M/arch/generic" -I "$C/musl-generated/obj/src/internal" -I "$M/src/include" -I "$M/src/internal" -I "$C/musl-generated/obj/include" -I "$M/include")
case "$unit" in
    cts/*) file="$D/c-testsuite/tests/single-exec/${unit#cts/}"; options=("${gnu17[@]}") ;;
    sqlite) file="$C/sqlite/sqlite3.c"; options=("${gnu17[@]}") ;;
    syn/*) file="$D/synthetic/${unit#syn/}"; options=("${gnu17[@]}") ;;
    musl/*) file="$M/src/${unit#musl/}"; options=("${musl[@]}") ;;
esac
unset CPATH C_INCLUDE_PATH
out=$(SOURCE_DATE_EPOCH=1792454400 "$D/main3/build/compiler" benchmark-checker-deferred --passes 6 --lanes 8 "${options[@]}" "$file" 2>&1)
status=$?
line=$(grep 'checker-deferred: file=' <<< "$out" | head -1)
active=$(grep -o 'lanes=8 active=[0-9]*' <<< "$out" | head -1 | cut -d= -f3)
shape=$(grep -o 'tokens=[0-9]* bodies=[0-9]* body_tokens=[0-9]* largest_body=[0-9]* second_body=[0-9]* top_tokens=[0-9]*' <<< "$line" | head -1)
merged=$(grep -o 'merged=.*parse=' <<< "$line" | sed 's/ parse=$//')
printf '%s\t%s\t%s\t%s\tstatus=%s\n' "$unit" "${active:-none}" "${shape:-none}" "${merged:-none}" "$status"

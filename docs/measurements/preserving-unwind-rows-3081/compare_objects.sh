#!/usr/bin/env bash
set -euo pipefail
base=$(realpath "$1")
head=$(realpath "$2")
out=$(realpath -m "$3")
input=$(dirname "$(realpath "$0")")/frames.c
mkdir -p "$out"/{base,head}
for version in base head; do
    compiler=${!version}
    for arch in x86-64 x86-64-v3 x86-64-v4; do
        file="$out/$version/$arch"
        "$compiler" --verify -c -march="$arch" "$input" -o "$file.o"
        objcopy --dump-section .eh_frame="$file.eh" "$file.o" "$file.copy.o"
        readelf --debug-dump=frames-interp "$file.o" > "$file.frames"
        test "$(grep -c 'FDE cie=' "$file.frames")" -eq 6
    done
    "$compiler" --verify -c -march=x86-64-v4 -fno-asynchronous-unwind-tables "$input" -o "$out/$version/no-unwind.o"
    if readelf -SW "$out/$version/no-unwind.o" | grep -q '\.eh_frame\b'; then exit 1; fi
done
for name in x86-64{,-v3,-v4}.{o,eh,frames} no-unwind.o; do cmp "$out/base/$name" "$out/head/$name"; done
wc -c "$out"/base/*.eh
sha256sum "$out"/base/*.eh

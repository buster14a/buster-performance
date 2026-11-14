#!/bin/bash
# ppu.sh COMPILER OUT [OPTION...]: musl's preprocessed units, a process each, -c into OUT; stderr into OUT.err.
c=$1 out=$2; shift 2
rm -rf "$out"; mkdir -p "$out"; : > "$out.err"
cd "$out" || exit 1
for f in "$HOME"/.cache/claude-2531/musl-i/*.i; do
    "$c" -std=c99 -nostdinc -ffreestanding "$@" -c "$f" 2>> "$out.err" || echo "status $? $f" >> "$out.err"
done

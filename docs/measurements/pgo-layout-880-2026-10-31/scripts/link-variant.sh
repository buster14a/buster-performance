#!/usr/bin/env bash
# link-variant.sh NAME OBJDIR OUT SHIFT — SHIFT bytes of padding before main.c's object.
# LINKER env overrides the linker (default: wild, else ld.lld).
set -euo pipefail
ROOT="$HOME/buster-fast-bench/devin-880"
name=$1; objdir=$2; out=$3; shift_bytes=$4
cd "$ROOT/src"
mapfile -d '' -t SOURCES < "$objdir/sources.argv0"
mapfile -d '' -t LDEXTRA < "$objdir/ldextra.argv0" || LDEXTRA=()
alignment=$(readelf -SW "$objdir/0.o" | awk '$0 ~ /\] \.text / { print $NF }')
[[ "$alignment" =~ ^[1-9][0-9]*$ ]] || { echo "link-variant: can't read .text alignment of ${SOURCES[0]}" >&2; exit 1; }
[ $((shift_bytes % alignment)) -eq 0 ] || { echo "link-variant: $shift_bytes not a multiple of .text alignment $alignment" >&2; exit 1; }
linked=()
if [ "$shift_bytes" -gt 0 ]; then
    padding="$objdir/padding-$shift_bytes.o"
    printf '\t.section .text.buster_shift_padding,"axR",@progbits\n\t.balign %d\n\t.globl buster_shift_padding\nbuster_shift_padding:\n\t.skip %d\n' \
        "$alignment" "$shift_bytes" | clang -c -x assembler - -o "$padding"
    linked+=("$padding")
fi
for i in "${!SOURCES[@]}"; do linked+=("$objdir/$i.o"); done
linker=${LINKER:-$(command -v wild || command -v ld.lld)}
clang -no-pie --ld-path="$linker" "${LDEXTRA[@]+"${LDEXTRA[@]}"}" "${linked[@]}" -lm -ldl -o "$out"
if [ "$shift_bytes" -gt 0 ]; then
    nm "$out" | grep ' buster_shift_padding$' > /dev/null || { echo "link-variant: linker dropped padding" >&2; exit 1; }
fi

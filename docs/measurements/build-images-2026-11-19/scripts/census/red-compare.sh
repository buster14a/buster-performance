#!/usr/bin/env bash
# Compiles musl's units and their reduced forms, each set as one command on one lane, and compares the objects' sections
# that carry code and data (not the symbol table's file name, not debug sections).
set -u
here=$(cd "$(dirname "$0")" && pwd)
T=${TIMECMD:-$here/../spawn/timecmd}
source "$here/musl-opts.sh"
compiler=${COMPILER:-/home/user/buster/build/compiler}
reduced=${REDUCED:-$here/musl-red2}
mapfile -t units < <(LC_ALL=C "$here/musl-units.sh")
work=/dev/shm/red-compare.$$
mkdir -p "$work/orig" "$work/red"
cd "$work/orig"; echo "originals, one command:"; "$T" "$compiler" -c --lanes 1 "${opts[@]}" "${units[@]}" 2>/dev/null
cd "$reduced"; mapfile -t reds < <(ls *.c)
cd "$work/red"; echo "reduced, one command:"; "$T" "$compiler" -c --lanes 1 -std=c99 -ffreestanding -w "${reds[@]/#/$reduced/}" 2> "$work/red-errors.txt"
echo "reduced errors: $(grep -c 'error:' "$work/red-errors.txt")"
grep 'error:' "$work/red-errors.txt" | head -5
same=0; differ=0; missing=0
for o in "$work/orig"/*.o; do
    b=${o##*/}
    if [[ ! -f "$work/red/$b" ]]; then missing=$((missing+1)); continue; fi
    a=$(objcopy -O binary --only-section=.text "$o" /dev/stdout 2>/dev/null | sha1sum)
    r=$(objcopy -O binary --only-section=.text "$work/red/$b" /dev/stdout 2>/dev/null | sha1sum)
    if [[ "$a" == "$r" ]]; then same=$((same+1)); else differ=$((differ+1)); fi
done
echo ".text the same: $same, differ: $differ, no reduced object: $missing"
rm -rf "$work"

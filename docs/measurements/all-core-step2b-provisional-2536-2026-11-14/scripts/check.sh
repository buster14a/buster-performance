#!/bin/bash
# check.sh NAME DIRECTORY OPTIONS...: out/NAME.files' units each compiled by -c and by --provisional-selection -c on CPU 2
# from DIRECTORY; out/NAME.txt a line a unit: its name, the option's report, and whether the objects are the same bytes.
set -u
name=$1 directory=$2
shift 2
compiler=$PWD/compiler-head
out=$PWD/out
mkdir -p "$out/o"
: > "$out/$name.txt"
while read -r f; do
    base=$(basename "$f")
    (cd "$directory" && taskset -c 2 "$compiler" --lanes 1 "$@" -c "$f" -o "$out/o/$name.e.o" 2> /dev/null < /dev/null)
    (cd "$directory" && taskset -c 2 "$compiler" --provisional-selection --lanes 1 "$@" -c "$f" -o "$out/o/$name.p.o" 2> "$out/o/$name.err" < /dev/null)
    verdict=different
    cmp -s "$out/o/$name.e.o" "$out/o/$name.p.o" && verdict=same
    printf '%s\t%s\t%s\n' "$base" "$(grep '^provisional-selection' "$out/o/$name.err" | tr '\t' ' ')" "$verdict" >> "$out/$name.txt"
    rm -f "$out/o/$name.e.o" "$out/o/$name.p.o"
done < "$out/$name.files"

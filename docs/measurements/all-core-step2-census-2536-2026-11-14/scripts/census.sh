#!/bin/bash
# census.sh NAME DIRECTORY OPTIONS...: out/NAME.files' units each compiled by --selection-census -c on CPU 2 from
# DIRECTORY; out/NAME.txt has a line a unit: its name, then the census's report.
set -u
name=$1 directory=$2
shift 2
compiler=$PWD/compiler-head
out=$PWD/out
mkdir -p "$out/o"
: > "$out/$name.txt"
while read -r f; do
    base=$(basename "$f")
    (cd "$directory" && taskset -c 2 "$compiler" --selection-census --lanes 1 "$@" -c "$f" -o "$out/o/$name.o" 2> "$out/o/$name.err" < /dev/null)
    printf '%s\t%s\n' "$base" "$(grep '^selection-census' "$out/o/$name.err")" >> "$out/$name.txt"
done < "$out/$name.files"

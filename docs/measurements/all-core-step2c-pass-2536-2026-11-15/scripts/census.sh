#!/bin/bash
# census.sh NAME DIRECTORY OPTIONS...: out/NAME.files' units from DIRECTORY on CPU 2, each by BASE's and HEAD's
# --selection-census -c, then by HEAD's -c and --provisional-selection -c. out/NAME.txt has a line a unit: its name, the
# two censuses' counts and whether they are the same, the option's report and whether the objects are the same bytes;
# out/NAME.ticks the two censuses' ticks.
set -u
name=$1 directory=$2
shift 2
here=$PWD
out=$PWD/out
mkdir -p "$out/o"
: > "$out/$name.txt"
: > "$out/$name.ticks"
while read -r f; do
    unit=$(basename "$f")
    for side in base head; do
        (cd "$directory" && taskset -c 2 "$here/compiler-$side" --selection-census --lanes 1 "$@" -c "$f" -o "$out/o/$name.$side.o" 2> "$out/o/$name.$side.err" < /dev/null)
    done
    b=$(grep -P '^selection-census\t' "$out/o/$name.base.err")
    h=$(grep -P '^selection-census\t' "$out/o/$name.head.err")
    census=different
    [ -n "$h" ] && [ "$b" = "$h" ] && census=same
    printf '%s\tbase\t%s\thead\t%s\n' "$unit" "$(grep '^selection-census-ticks' "$out/o/$name.base.err" | cut -f2-)" "$(grep '^selection-census-ticks' "$out/o/$name.head.err" | cut -f2-)" >> "$out/$name.ticks"
    (cd "$directory" && taskset -c 2 "$here/compiler-head" --lanes 1 "$@" -c "$f" -o "$out/o/$name.e.o" 2> /dev/null < /dev/null)
    (cd "$directory" && taskset -c 2 "$here/compiler-head" --provisional-selection --lanes 1 "$@" -c "$f" -o "$out/o/$name.p.o" 2> "$out/o/$name.p.err" < /dev/null)
    verdict=different
    cmp -s "$out/o/$name.e.o" "$out/o/$name.p.o" && verdict=same
    [ -f "$out/o/$name.e.o" ] || verdict=no-object
    printf '%s\t%s\tcensus %s\t%s\tobjects %s\n' "$unit" "$h" "$census" "$(grep '^provisional-selection' "$out/o/$name.p.err" | tr '\t' ' ')" "$verdict" >> "$out/$name.txt"
    rm -f "$out/o/$name.e.o" "$out/o/$name.p.o" "$out/o/$name.base.o" "$out/o/$name.head.o"
done < "$out/$name.files"

#!/bin/bash
# objects.sh NAME DIRECTORY OPTIONS...: out/NAME.files' units from DIRECTORY on CPU 2, each by BASE's and HEAD's -c;
# out/NAME.txt a line a unit: its name, whether the objects are the same bytes, whether stderr is the same text, and
# both exit statuses.
set -u
name=$1 directory=$2
shift 2
here=$PWD
out=$PWD/out
mkdir -p "$out/o"
: > "$out/$name.txt"
while read -r f; do
    for side in base head; do
        (cd "$directory" && taskset -c 2 "$here/compiler-$side" --lanes 1 "$@" -c "$f" -o "$out/o/$name.$side.o" 2> "$out/o/$name.$side.err" < /dev/null; echo $? > "$out/o/$name.$side.status")
    done
    objects=different
    cmp -s "$out/o/$name.base.o" "$out/o/$name.head.o" && objects=same
    [ -f "$out/o/$name.base.o" ] || [ -f "$out/o/$name.head.o" ] || objects=none
    errors=different
    cmp -s "$out/o/$name.base.err" "$out/o/$name.head.err" && errors=same
    printf '%s\t%s\t%s\t%s\t%s\n' "$(basename "$f")" "$objects" "$errors" "$(cat "$out/o/$name.base.status")" "$(cat "$out/o/$name.head.status")" >> "$out/$name.txt"
    rm -f "$out/o/$name".*
done < "$out/$name.files"

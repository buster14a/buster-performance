#!/bin/bash
# objects.sh NAME DIRECTORY OPTIONS...: out/NAME.files' units from DIRECTORY on CPU 2, each by BASE's -c and HEAD's -c,
# then by HEAD's --deferred-lowering -c at --emit-window=1, the default 2,048 and 0 (∞). out/NAME.txt has a line a unit:
# its name, whether HEAD's object, stderr and exit status are BASE's, and whether each deferred one's are HEAD's plain.
set -u
name=$1 directory=$2
shift 2
here=$PWD
out=$PWD/out
mkdir -p "$out/o"
: > "$out/$name.txt"
same()
{
    local verdict=different
    cmp -s "$out/o/$name.$1.o" "$out/o/$name.$2.o" && cmp -s "$out/o/$name.$1.err" "$out/o/$name.$2.err" && [ "$(cat "$out/o/$name.$1.status")" = "$(cat "$out/o/$name.$2.status")" ] && verdict=same
    [ -f "$out/o/$name.$1.o" ] || [ -f "$out/o/$name.$2.o" ] || verdict="$verdict-no-object"
    printf '%s' "$verdict"
}
compile()
{
    local tag=$1 side=$2
    shift 2
    rm -f "$out/o/$name.$tag.o"
    (cd "$directory" && taskset -c 2 "$here/compiler-$side" --lanes 1 "$@" -c "$f" -o "$out/o/$name.$tag.o" 2> "$out/o/$name.$tag.err" < /dev/null; echo $? > "$out/o/$name.$tag.status")
}
while read -r f; do
    unit=$(basename "$f")
    compile b base "$@"
    compile h head "$@"
    compile d1 head --deferred-lowering --emit-window=1 "$@"
    compile d2048 head --deferred-lowering "$@"
    compile dinf head --deferred-lowering --emit-window=0 "$@"
    printf '%s\thead %s\tdeferred-1 %s\tdeferred-2048 %s\tdeferred-inf %s\tstatus %s\n' "$unit" "$(same b h)" "$(same h d1)" "$(same h d2048)" "$(same h dinf)" "$(cat "$out/o/$name.h.status")" >> "$out/$name.txt"
done < "$out/$name.files"
rm -f "$out/o/$name".*

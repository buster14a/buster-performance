#!/bin/bash
# units.sh NAME DIRECTORY OPTIONS...: out/NAME.files' units from DIRECTORY on CPU 2, each by BASE's -c and HEAD's -c, by
# HEAD's --provisional-selection -c and by HEAD's --selection-census -c. out/NAME.txt has a line a unit: its name;
# whether HEAD's object, stderr and exit status are BASE's; whether the provisional object is HEAD's plain one (or both
# missing) with the option's report; and the census's builtins line.
set -u
name=$1 directory=$2
shift 2
here=$PWD
out=$PWD/out
mkdir -p "$out/o"
: > "$out/$name.txt"
compile()
{
    local tag=$1 side=$2
    shift 2
    rm -f "$out/o/$name.$tag.o"
    (cd "$directory" && taskset -c 2 "$here/compiler-$side" --lanes 1 "$@" -c "$f" -o "$out/o/$name.$tag.o" 2> "$out/o/$name.$tag.err" < /dev/null; echo $? > "$out/o/$name.$tag.status")
}
same()
{
    local objects=same rest=same
    if [ -f "$out/o/$name.$1.o" ] || [ -f "$out/o/$name.$2.o" ]; then
        cmp -s "$out/o/$name.$1.o" "$out/o/$name.$2.o" || objects=different
    else
        objects=none
    fi
    cmp -s "$out/o/$name.$1.err" "$out/o/$name.$2.err" && [ "$(cat "$out/o/$name.$1.status")" = "$(cat "$out/o/$name.$2.status")" ] || rest=different
    printf '%s/%s' "$objects" "$rest"
}
while read -r f; do
    unit=${f#$here/head/}
    unit=${unit##*/corpora/preprocessor-391e729af658/}
    compile b base "$@"
    compile h head "$@"
    compile p head --provisional-selection "$@"
    compile s head --selection-census "$@"
    objects=different
    if [ -f "$out/o/$name.h.o" ] || [ -f "$out/o/$name.p.o" ]; then
        cmp -s "$out/o/$name.h.o" "$out/o/$name.p.o" && objects=same
    else
        objects=none
    fi
    printf '%s\thead %s\tprovisional %s %s\t%s\n' "$unit" "$(same b h)" "$objects" "$(grep -P '^provisional-selection\t' "$out/o/$name.p.err" | tr '\t' ' ')" \
        "$(grep -P '^selection-census-builtins\t' "$out/o/$name.s.err" | cut -f2- | tr '\t' ' ')" >> "$out/$name.txt"
done < "$out/$name.files"
rm -f "$out/o/$name".*

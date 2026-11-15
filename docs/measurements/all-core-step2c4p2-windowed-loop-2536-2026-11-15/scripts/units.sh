#!/bin/bash
# units.sh NAME DIRECTORY OPTIONS...: out/NAME.files' units from DIRECTORY on CPU 2, each by BASE's -c, HEAD's -c and
# HEAD's --windowed-loop -c at --emit-window=1, 2048 and 0 (W = infinity). out/NAME.txt has a line a unit: its name;
# whether HEAD's object, stderr and exit status are BASE's; and for each window whether the windowed object (or both
# missing), stderr but the options' reports, and exit status are HEAD's plain ones, with its windowed-loop report.
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
    (cd "$directory" && taskset -c 2 "$here/compiler-$side" --lanes 1 "$@" -c "$f" -o "$out/o/$name.$tag.o" 2> "$out/o/$name.$tag.raw" < /dev/null; echo $? > "$out/o/$name.$tag.status")
    grep -vP '^(provisional-selection|windowed-loop)\t' "$out/o/$name.$tag.raw" > "$out/o/$name.$tag.err"
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
    line="$unit	head $(same b h)"
    for w in 1 2048 0; do
        compile w$w head --windowed-loop --emit-window=$w "$@"
        line="$line	W$w $(same h w$w) $(grep -P '^windowed-loop\t' "$out/o/$name.w$w.raw" | cut -f3)"
    done
    printf '%s\n' "$line" >> "$out/$name.txt"
done < "$out/$name.files"
rm -f "$out/o/$name".*

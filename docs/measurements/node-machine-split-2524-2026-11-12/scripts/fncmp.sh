#!/bin/bash
# fncmp.sh A.o B.o PATTERN: each function matching PATTERN in both objects, its instruction count in each and whether
# its normalized disassembly (addresses, offsets of jumps and relocations stripped) is the same.
a=$1; b=$2; pattern=$3
dir=$(mktemp -d)
for o in "$a" "$b"; do
    tag=$( [ "$o" = "$a" ] && echo a || echo b )
    objdump -d --no-show-raw-insn -M intel "$o" | awk -v dir="$dir/$tag" '
        /^[0-9a-f]+ <.*>:$/ { name=$2; gsub(/[<>:]/, "", name); file=dir "." name; next }
        /^$/ { file=""; next }
        file != "" && /^ *[0-9a-f]+:/ { line=$0; sub(/^ *[0-9a-f]+:\t/, "", line); gsub(/0x[0-9a-f]+/, "X", line); gsub(/[0-9a-f]+ <[^>]*>/, "L", line); print line > file }'
done
for f in "$dir"/a.*; do
    name=${f#$dir/a.}
    [[ $name =~ $pattern ]] || continue
    na=$(wc -l < "$f"); nb=$( [ -f "$dir/b.$name" ] && wc -l < "$dir/b.$name" || echo missing)
    same=$(cmp -s "$f" "$dir/b.$name" && echo same || echo DIFFERENT)
    printf '%-40s %6s %6s %s\n' "$name" "$na" "$nb" "$same"
done
for f in "$dir"/b.*; do
    name=${f#$dir/b.}
    [[ $name =~ $pattern ]] || continue
    [ -f "$dir/a.$name" ] || printf '%-40s %6s %6s %s\n' "$name" missing "$(wc -l < "$f")" "only-b"
done
echo "$dir"

#!/bin/bash
# label.sh NAMES OWNERS-TABLE SITES DELTA: names.txt with each mapping's label: the first frame of its owner's stack
# (OWNERS-TABLE: an address less one, then its frames innermost first, from llvm-symbolizer) whose file:line SITES
# names; a mapping of the source file by file_cache_probe is the source (its length) or a header. DELTA is the
# executable's text segment's address less its file offset (strace -k gives file offsets). Writes
# `ORDINAL ADDRESS LENGTH LABEL`.
names=$1
owners=$2
sites=$3
delta=$4
while read -r ordinal address length flags owner rest; do
    key=$(printf '0x%x' $((0x$owner + delta - 1)))
    frames=$(awk -F'\t' -v k="$key" '$1 == k {print $2}' "$owners")
    label=""
    while IFS=$'\t' read -r site name; do
        if [[ -z $label && $frames == *"($site)"* ]]; then
            label=$name
        fi
    done < "$sites"
    if [[ $frames == *"file_cache_probe"* ]]; then
        label=$([[ $length == 9110dd ]] && echo "the source file (sqlite3.c, mapped)" || echo "a header file (mapped)")
    fi
    echo "$ordinal $address $length ${label:-$rest}"
done < "$names"

#!/bin/bash
# usage: sumknobs.sh OUTDIR: per config and setting, the printing medians of each round and their median.
cd "$1" || exit 1
n=$(wc -l < settings.txt)
for config in mainP mainE; do
    for (( i=0; i<n; i++ )); do
        prints=$(grep -ho "(printing [0-9.]* ms)" $config.$i.*.txt 2>/dev/null | grep -o "[0-9.]*" | sort -n | tr '\n' ' ')
        mp=$(echo $prints | tr ' ' '\n' | awk 'NF {a[++n]=$1} END {if (n) print a[int((n+1)/2)]}')
        printf "%-6s %-55s printing median %8s  [%s]\n" $config "$(sed -n "$((i+1))p" settings.txt)" "$mp" "$prints"
    done
done

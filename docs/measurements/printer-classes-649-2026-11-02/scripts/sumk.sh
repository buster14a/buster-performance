#!/bin/bash
# usage: sumk.sh OUTDIR: per config and entry of an abk.sh run, printing and whole medians.
cd "$1" || exit 1
n=$(wc -l < entries.txt)
for config in mainP mainE sqliteP sqliteE; do
    for (( i=0; i<n; i++ )); do
        prints=$(grep -ho "(printing [0-9.]* ms)" $config.$i.*.txt 2>/dev/null | grep -o "[0-9.]*" | sort -n | tr '\n' ' ')
        wholes=$(grep -ho "with printing [0-9.]* ms" $config.$i.*.txt 2>/dev/null | grep -o "[0-9.]*" | sort -n | tr '\n' ' ')
        mp=$(echo $prints | tr ' ' '\n' | awk 'NF {a[++n]=$1} END {if (n) print a[int((n+1)/2)]}')
        mw=$(echo $wholes | tr ' ' '\n' | awk 'NF {a[++n]=$1} END {if (n) print a[int((n+1)/2)]}')
        printf "%-8s %-32s printing %8s [%s] whole %8s\n" $config "$(sed -n "$((i+1))p" entries.txt)" "$mp" "$prints" "$mw"
    done
done

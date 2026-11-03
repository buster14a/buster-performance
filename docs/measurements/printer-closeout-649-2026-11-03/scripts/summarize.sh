#!/bin/bash
# usage: summarize.sh OUTDIR: per config and tree, the printing and whole medians of each run, and their median.
cd "$1" || exit 1
for config in mainP mainE sqliteP sqliteE; do
    for tree in $(ls $config.*.txt 2>/dev/null | sed "s/^$config\.\(.*\)\.[0-9]*\.txt$/\1/" | sort -u); do
        prints=$(grep -ho "(printing [0-9.]* ms)" $config.$tree.*.txt | grep -o "[0-9.]*" | sort -n | tr '\n' ' ')
        wholes=$(grep -ho "with printing [0-9.]* ms" $config.$tree.*.txt | grep -o "[0-9.]*" | sort -n | tr '\n' ' ')
        mp=$(echo $prints | tr ' ' '\n' | awk '{a[NR]=$1} END {print a[int((NR+1)/2)]}')
        mw=$(echo $wholes | tr ' ' '\n' | awk '{a[NR]=$1} END {print a[int((NR+1)/2)]}')
        waits=-
        printf "%-8s %-6s printing median %8s  [%s]  whole median %8s  [%s] (waited: %s)\n" $config $tree "$mp" "$prints" "$mw" "$wholes" "$waits"
    done
done

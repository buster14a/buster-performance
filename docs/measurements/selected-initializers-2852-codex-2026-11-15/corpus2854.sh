#!/bin/bash
set -u
root="$HOME/buster-fast-bench/2803-codex-6af9ef"
clang="$HOME/.cache/buster/benchpress-clang/efdd1dbd089b99bfcfcde7b8eb1236163f2e88df5a981cca4f783ec9cb5e0378/bin/clang"
out="$root/data-comparison"
mkdir -p "$out"
printf 'before\n'; cat /proc/loadavg; ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | head
printf 'file\tcompiler\tstatus\trodata\tdata\tbss\n'
while read -r id; do
    [[ "$id" =~ ^[0-9]+$ ]] || continue
    src="$root/c-testsuite/tests/single-exec/$id.c"
    for variant in base pr2854 clang; do
        if [ "$variant" = clang ]; then compiler="$clang"; else compiler="$root/$variant/build/cmake/znver5/Release/compiler"; fi
        if "$compiler" -c "$src" -o "$out/$variant.o" > "$out/$id-$variant.out" 2>&1; then
            size -A "$out/$variant.o" | awk -v id="$id" -v v="$variant" 'BEGIN {r=0;d=0;b=0} $1 ~ /^\.rodata/ {r+=$2} $1 ~ /^\.data/ {d+=$2} $1 ~ /^\.bss/ {b+=$2} END {printf "%s\t%s\tok\t%d\t%d\t%d\n",id,v,r,d,b}'
        else printf '%s\t%s\tfail\t-\t-\t-\n' "$id" "$variant"; fi
    done
done < "$root/pr2854/tests/c-testsuite/subset.txt"
printf 'after\n'; cat /proc/loadavg; ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | head

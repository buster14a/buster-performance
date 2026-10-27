#!/bin/bash
# The medians of each stage per tree, from ab.sh's OUT, and perf stat's user instructions and cycles.
out=$1
shift
for tree in "$@"; do
    echo "== $tree"
    cat "$out"/stages-$tree-*.txt | awk -F'\t' '$1=="time-stage" && NF>=4 {print $2"\t"$3}' |
        sort -k1,1 -k2,2n | awk -F'\t' '{v[$1]=v[$1]" "$2; n[$1]++} END {for (s in v) {split(substr(v[s],2),a," "); asort(a); m=a[int((n[s]+1)/2)]; printf "%s\t%.3f\n", s, m}}' |
        grep -E "^(check-declarations|static-data|select|emit-setup|check-program|check-expressions|lower|total)\b"
    cat "$out"/stat-$tree-*.txt | awk -F, '/instructions:u/ {i+=$1; ni++} /cycles:u/ {c+=$1; nc++} END {printf "instructions:u\t%.1f M\ncycles:u\t%.1f M\n", i/ni/1e6, c/nc/1e6}'
done

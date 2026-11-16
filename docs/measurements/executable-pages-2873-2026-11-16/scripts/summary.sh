#!/bin/bash
# summary.sh OUT: the phases' fault maps of sqlite3.c and the medians of their counts.
cd "$(dirname "$0")/$1" || exit 1
cat host.txt
cat *-check.txt collapse*.txt 2> /dev/null
for p in before code data after; do
    [ -f "$p-sqlite.txt" ] || continue
    echo "== $p"
    cat "$p-sqlite.txt" | grep -v "^==" | awk -F'\t' '{printf "  %-34s %8s %6s %6s\n", $1, $3, $4, $6}'
    for k in sqlite musl; do
        for f in $p-$k-[0-9].csv; do
            awk -F, '/cycles:k/{k=$1} /cycles:u/{u=$1} /page-faults/{f=$1} /iTLB/{t=$1} END{printf "%.3f %.3f %d %d\n", k/1e6, u/1e6, f, t}' "$f"
        done | sort -n | awk -v name="$p $k" '{k[NR]=$1; u[NR]=$2; f[NR]=$3; t[NR]=$4} END{m=int((NR+1)/2); printf "  %-14s kernel %.2f M (median of %d: %.2f to %.2f)  user(at median kernel) %.2f M  faults %d  iTLB misses %d\n", name, k[m], NR, k[1], k[NR], u[m], f[m], t[m]}'
    done
done
